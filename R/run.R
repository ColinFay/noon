.pool <- new.env()

#' Close all open MIDI watchers
#'
#' @return Used for side-effect
#' @export
#'
#' @examples
#' if (interactive()){
#'   midi_close_all()
#' }
midi_close_all <- function(){
  for (i in names(.pool)){
    .pool[[i]]$kill()
  }
}

#' Listen to midi events
#'
#' These functinos will launch a process
#' that checks every `n` seconds (default 0.5)
#' if any/a given midi event has been received on any/a given
#' midi interface.
#'
#' `midi_all()`, listens for all interfaces and all events (except the clock,
#' which can be listen with `with_clock = FALSE`), `midi_one_event()` listens to
#' one specific event on all interfaces, `midi_one_interface()` listens to any
#' event from one interface, and `midi_one_event_one_interface()` listens to one
#' event on one interface.
#'
#' @return A background process listen to MIDI events
#'
#' @export
#' @rdname midi_listen
#'
#' @param interface name of the interface to listen to. Must be one of `midi_list()`.
#' @param event the event to listen to. Available event are "noteoff", "noteon",
#' "poly aftertouch", "cc", "program", "channel aftertouch", "pitch", "position", "select", "start", "continue", "stop", and "reset"
#' @param callback The callback function to execute when R receives a MIDI message.
#' This function takes one argument, which is the JSON MIDI message.
#' @param n Time in second between each check for a new MIDI message.
#' @param with_clock Whether or not to listen to the clock event.
#'
#' @examples
#' if (interactive()){
#'   # Launch
#'   midi_all()
#'   # Kill the process
#'   midi_close_all()
#' }
midi_all <- function(
  callback = ~ cat(.x, "\n"),
  n = 0.5,
  with_clock = FALSE
){
  script <- system.file("cordes/midi_all.js", package = "noon")
  extra_args <- c(script, as.numeric(with_clock))
  listen_to_midi(
    callback,
    n,
    extra_args
  )
}

#' @export
#' @rdname midi_listen

midi_one_event <- function(
  event = c(
    'noteoff',
    'noteon',
    'poly aftertouch',
    'cc',
    'program',
    'channel aftertouch',
    'pitch',
    'position',
    'select',
    'start',
    'continue',
    'stop',
    'reset'
  ),
  callback = ~ cat(.x, "\n"),
  n = 0.5
){
  event <- match.arg(event)
  script <- system.file("cordes/midi_one_event.js", package = "noon")
  extra_args <- c(script, event)
  listen_to_midi(
    callback,
    n,
    extra_args
  )
}
#' @export
#' @rdname midi_listen
#'
midi_one_interface <- function(
  interface,
  callback = ~ cat(.x, "\n"),
  n = 0,
  with_clock = FALSE
){
  script <- system.file("cordes/midi_one_interface.js", package = "noon")
  extra_args <- c(script, as.numeric(with_clock), interface)
  listen_to_midi(
    callback,
    n,
    extra_args
  )
}

#' @export
#' @rdname midi_listen
midi_one_event_one_interface <- function(
  event = c(
    'noteoff',
    'noteon',
    'poly aftertouch',
    'cc',
    'program',
    'channel aftertouch',
    'pitch',
    'position',
    'select',
    'start',
    'continue',
    'stop',
    'reset'
  ),
  interface,
  callback = ~ cat(.x, "\n"),
  n = 0.5
){
  event <- match.arg(event)

  script <- system.file("cordes/midi_one_event_one_interface.js", package = "noon")
  extra_args <- c(script, event, interface)
  listen_to_midi(
    callback,
    n,
    extra_args
  )
}

#' @importFrom rlang as_function
#' @importFrom processx process
#' @importFrom digest digest
#' @importFrom later later
listen_to_midi <- function(
  callback,
  n,
  extra_args
){
  callback <- as_function(callback)
  p <- process$new(
    "node",
    extra_args,
    "|",
    "|",
    "|"
  )
  read_midi <- function(p){
    if (p$is_alive()){
      output <- p$read_output_lines()
      if (length(output) > 0 && output != ""){
        lapply(output, function(x){
          callback (x)
        })
      }
    }
    later(~ read_midi(p), n)
  }
  later(~ read_midi(p), n)
  .pool[[
    digest(p)
  ]] <- p
  return(invisible(p))
}

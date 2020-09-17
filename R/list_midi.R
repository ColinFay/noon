#' List MIDI interfaces
#'
#' This function will list all available MIDI interfaces.
#'
#' @return A JSON array of interface names
#' @export
#' @importFrom processx run
#'
#' @examples
#' if (interactive()){
#'   midi_list()
#' }
midi_list <- function(){
  res <- run(
    "node", c(
      system.file("cordes/midi_list.js", package = "noon")
    )
  )
  if (res$status == 0){
    res$stdout
  } else {
    stop(res$stderr)
  }

}

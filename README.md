
<!-- README.md is generated from README.Rmd. Please edit that file -->

noon
====

<!-- badges: start -->
<!-- badges: end -->

`{noon}` allows to watch for incoming MIDI events from R. Because why
not.

Install
-------

You’ll need a running installation of NodeJS, that you can get from
[nodejs.org](https://nodejs.org/en/download/).

Then, the package can be installed with:

    remotes::install_github("ColinFay/noon")

After install, you’ll need to run **one time** `noon_npm_install()` to
set up all the Node dependencies.

    library(noon)
    noon_npm_install()

Functions reference
-------------------

`midi_list()`
-------------

List all the available midi interfaces:

    midi_list()

### `midi_all()`

`midi_all()` will launch a process that checks every `n` seconds
(default 0.5) if a new midi event has been received on all the midi
interface.

It takes a function defining what to do with the message (note it’s
received in JSON). By default, R will `cat()` the output.

    midi_all()

This function takes the following arguments:

-   callback: The callback function to execute when R receives a MIDI
    message. This function takes one argument, which is the JSON MIDI
    message.
-   n: time in second between each check for a new MIDI message.
-   with\_clock: whether or not to listen to the clock event.

The message is received with the following format:

    {"input":"microKONTROL PORT A","event":"cc","msg":{"channel":4,"controller":13,"value":127,"_type":"cc"}}

### `midi_close_all()`

Don’t forget to `midi_close_all()`, if you don’t want to watch on MIDI
inputs anymore.

    midi_close_all()

### `midi_one_event()`

This function will listen to one event type only (all interfaces)

    midi_one_event(event = "cc", fun = handle)

This function takes the following arguments:

-   callback: The callback function to execute when R receives a MIDI
    message. This function takes one argument, which is the JSON MIDI
    message.
-   n: time in second between each check for a new MIDI message.
-   event: the event to listen to. Available event are “noteoff”,
    “noteon”, “poly aftertouch”, “cc”, “program”, “channel aftertouch”,
    “pitch”, “position”, “select”, “start”, “continue”, “stop”, and
    “reset”

`midi_one_interface()`
----------------------

This function will listen to one interface type only (all events)

    midi_one_interface(interface = "microKONTROL PORT A")

This function takes the following arguments:

-   interface: name of the interface to listen to. Must be one of
    `midi_list()`.
-   callback: The callback function to execute when R receives a MIDI
    message. This function takes one argument, which is the JSON MIDI
    message.
-   n: time in second between each check for a new MIDI message.
-   with\_clock: whether or not to listen to the clock event.

`midi_one_event_one_interface()`
--------------------------------

This function will listen to one event on one interface

    midi_one_event_one_interface(event = "cc", interface = "microKONTROL PORT A")

-   event: the event to listen to. Available event are “noteoff”,
    “noteon”, “poly aftertouch”, “cc”, “program”, “channel aftertouch”,
    “pitch”, “position”, “select”, “start”, “continue”, “stop”, and
    “reset”
-   interface: name of the interface to listen to. Must be one of
    `midi_list()`.
-   callback: The callback function to execute when R receives a MIDI
    message. This function takes one argument, which is the JSON MIDI
    message.
-   n: time in second between each check for a new MIDI message.
-   with\_clock: whether or not to listen to the clock event.

About the `callback` argument
-----------------------------

Each function takes a `callback` parameter, which define the logic to
handle the message (received as a JSON string) under the following
format:

    {"input":"microKONTROL PORT A","event":"cc","msg":{"channel":4,"controller":13,"value":127,"_type":"cc"}}

> Important note: given that the functions checks the for MIDI midi on a
> recursive basis (i.e every `n` seconds), it’s possible that at some
> point R receives more than one JSON strings in a row, for example if
> you ‘noteon’ and ‘noteoff’ very quickly. The `callback` will then be
> `lapply`-ed on all the inputs.

    handle <- function(x){
      print(jsonlite::fromJSON(x))
    }
    midi_all(callback = handle)

Note that it can also be written as a formula, following `{rlang}`
syntax.

    midi_all(callback = ~ print(jsonlite::fromJSON(.x)))

### Some `callback` example

-   `load_all()` on a button press

<!-- -->

    load_all <- function(x){
      x <- jsonlite::fromJSON(x)
      # listen on event 16 and only on press (value 127)
      if (x$msg$controller == 16 && x$msg$value == 127){
        cli::cat_line("Reloading the package")
        pkgload::load_all()
      }
    }
    midi_all(callback = load_all)

-   `ggplot()` on a button press

<!-- -->

    library(ggplot2)
    ggplotit <- function(x){
      x <- jsonlite::fromJSON(x)
      if (x$msg$controller == 15 && x$msg$value == 127){
        gg <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
          geom_point()
        print(gg)
      }
    }
    midi_all(callback = ggplotit)

-   A dev oriented workflow

<!-- -->

    handle <- function(x){
      x <- jsonlite::fromJSON(x)
      
      if (x$msg$controller == 11 && x$msg$value == 127){
        cli::cat_line("Opening README")
        rstudioapi::navigateToFile("README.Rmd")
      }
      
      if (x$msg$controller == 12 && x$msg$value == 127){
        cli::cat_line("Opening DESCRIPTION")
        rstudioapi::navigateToFile("DESCRIPTION")
      }
      
      if (x$msg$controller == 13 && x$msg$value == 127){
        cli::cat_line("Testing")
        devtools::test()
      }
      if (x$msg$controller == 14 && x$msg$value == 127){
        cli::cat_line("Checking")
        devtools::check()
      }
      if (x$msg$controller == 15 && x$msg$value == 127){
        cli::cat_line("Document")
        devtools::document()
      }
      if (x$msg$controller == 16 && x$msg$value == 127){
        cli::cat_line("Reloading the package")
        pkgload::load_all()
      }
    }
    midi_all(callback = handle)

-   `{beepr}`

<!-- -->

    library(beepr)
    handle <- function(x){
      x <- jsonlite::fromJSON(x)
      cli::cat_rule(x$msg$note)
      note <- switch(
        as.character(x$msg$note), 
        "60" = 1,
        "61" = 2,
        "62" = 3,
        "63" = 4,
        "64" = 5,
        "65" = 6,
        "66" = 7,
        "67" = 8,
        "68" = 9,
        "69" = 10,
        "70" = 11
      )
      beep(note)
      
    }
    midi_one_event(event = "noteon", callback = handle,  n = 0)

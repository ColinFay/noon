#' Install noon npm dependencies
#'
#' @inheritParams cordes::cordes_npm_install
#'
#' @importFrom cordes cordes_npm_install
#' @return Used for side effect
#' @export
#'
#' @examples
#' if (interactive()){
#'   noon_npm_install()
#' }
noon_npm_install <- function(
  package = "noon",
  force = FALSE
){
  run(
    command = "npm",
    args = c("install"),
    wd = system.file("cordes", package = "noon")
  )
}

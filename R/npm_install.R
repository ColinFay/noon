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
  res <- cordes_npm_install(package = package, force = force)
  if (res$status == 0){
    message("npm installation finished")
  } else {
    stop("npm installation finished")
  }
}

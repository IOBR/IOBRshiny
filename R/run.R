#########################################
#### A Shiny App for IOBR ###############
#########################################
#########################################


#' Run IOBR Shiny App
#'
#' @importFrom shiny shinyAppFile
#' @param runMode default is 'client' for personal user, set it to 'server' for running on server.
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' app_run()
#' }
app_run <- function(runMode = "client") {
  shiny::shinyAppFile(system.file("shinyapp", "app.R", package = "IOBRshiny"))
}
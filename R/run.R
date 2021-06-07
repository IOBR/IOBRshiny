#########################################
#### A Shiny App for IOBR ###############
#########################################
#########################################


#' Run IOBR Shiny App
#'
#' @importFrom shiny shinyAppFile
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' app_run()
#' }
app_run <- function() {
  shiny::shinyAppFile(system.file("shinyapp", "app.R", package = "IOBRshiny"))
}
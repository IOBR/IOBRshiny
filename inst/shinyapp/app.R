
# Global setting ------------------------------

library(shiny)
library(shinydashboard)
library(waiter)

source(system.file("shinyapp", "ui.R", package = "IOBRshiny"))
source(system.file("shinyapp", "server.R", package = "IOBRshiny"))




# Run the application ---------------------------------
shiny::shinyApp(ui = ui, server = server)

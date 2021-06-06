
# Global setting ------------------------------

library(shiny)
library(shinydashboard)
library(waiter)

source(system.file("shinyapp", "ui.R", package = "IOBRshiny"))
source(system.file("shinyapp", "server.R", package = "IOBRshiny"))

# Put tabs here --------------------------------------------------------
tabs_path <- system.file("shinyapp", "tabs", package = "IOBRshiny", mustWork = TRUE)
tabs_file <- dir(tabs_path, pattern = "\\.R$", full.names = TRUE)
sapply(tabs_file, function(x, y) source(x, local = y), y = environment())

# Put server here --------------------------------------------------------
server_path <- system.file("shinyapp", "server", package = "IOBRshiny", mustWork = TRUE)
server_file <- dir(server_path, pattern = "\\.R$", full.names = TRUE)
sapply(server_file, function(x, y) source(x, local = y), y = environment())

# Run the application ---------------------------------
shiny::shinyApp(ui = ui, server = server)

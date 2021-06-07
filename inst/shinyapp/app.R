
# Global setting ------------------------------

library(shiny)
library(shinydashboard)
library(waiter)
library(IOBR)
library(DT)
options(shiny.maxRequestSize=1024*1024^2)

# source(system.file("shinyapp", "server.R", package = "IOBRshiny"))

# Put tabs here --------------------------------------------------------
ui_path <- system.file("shinyapp", "ui", package = "IOBRshiny", mustWork = TRUE)
ui_file <- dir(ui_path, pattern = "\\.R$", full.names = TRUE)
sapply(ui_file, function(x, y) source(x, local = y), y = environment())

# Put server here --------------------------------------------------------
server_path <- system.file("shinyapp", "server", package = "IOBRshiny", mustWork = TRUE)
server_file <- dir(server_path, pattern = "\\.R$", full.names = TRUE)
sapply(server_file, function(x, y) source(x, local = y), y = environment())

# Put modules here --------------------------------------------------------
modules_path <- system.file("shinyapp", "modules", package = "IOBRshiny", mustWork = TRUE)
modules_file <- dir(modules_path, pattern = "\\.R$", full.names = TRUE)
sapply(modules_file, function(x, y) source(x, local = y), y = environment())




# UI part -----------------------------------------
ui <- tagList(
  tags$head(
    tags$title("IOBRshiny"),
    tags$style(
      HTML(".shiny-notification {
              height: 100px;
              width: 800px;
              position:fixed;
              top: calc(50% - 50px);;
              left: calc(50% - 400px);;
            }")
    )
  ),
  shinyjs::useShinyjs(),
  # waiter::use_waiter(),
  # waiter::waiter_on_busy(html = spin_3k(), color = transparent(0.7)),
  navbarPage(
    id = "navbar",
    title = div(
      img(src = "IOBR-logo.png", height = 49.6, style = "margin:-20px -15px -15px -15px")
    ),
    # # inst/shinyapp/ui
    ui.page_home(),
    ui.sig_cal(),
    ui.TME_dec(),
    # ui.page_repository(),
    # ui.page_general_analysis(),
    # ui.page_pancan(),
    # ui.page_global(),
    # ui.page_help(),
    # ui.page_developers(),
    # footer = ui.footer(),
    collapsible = TRUE,
    theme = shinythemes::shinytheme("flatly")
  )
)

# Server Part ---------------------------------
server <- function(input, output, session) {
  
  # inst/shinyapp/server
  source("server/server-TME_dec.R", local = TRUE)
  # source("server/server-sig_cal.R", local = TRUE)
  server.sig_cal()
  # source(server_file("repository.R"), local = TRUE)
  # source(server_file("modules.R"), local = TRUE)
  # source(server_file("global.R"), local = TRUE)
  # source(server_file("general-analysis.R"), local = TRUE)
}

# Run the application ---------------------------------
shiny::shinyApp(
  ui = ui, 
  server = server
  )

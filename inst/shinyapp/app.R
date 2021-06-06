
# Global setting ------------------------------

library(shiny)
library(shinydashboard)
library(waiter)


source(system.file("shinyapp", "server.R", package = "IOBRshiny"))

# Put tabs here --------------------------------------------------------
tabs_path <- system.file("shinyapp", "tabs", package = "IOBRshiny", mustWork = TRUE)
tabs_file <- dir(tabs_path, pattern = "\\.R$", full.names = TRUE)
sapply(tabs_file, function(x, y) source(x, local = y), y = environment())

# Put server here --------------------------------------------------------
server_path <- system.file("shinyapp", "server", package = "IOBRshiny", mustWork = TRUE)
server_file <- dir(server_path, pattern = "\\.R$", full.names = TRUE)
sapply(server_file, function(x, y) source(x, local = y), y = environment())




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
  use_waiter(),
  waiter_on_busy(html = spin_3k(), color = transparent(0.7)),
  navbarPage(
    id = "navbar",
    title = div(
      img(src = "IOBR-logo.png", height = 49.6, style = "margin:-20px -15px -15px -15px")
    ),
    # # inst/shinyapp/ui
    ui.page_home(),
    #source("tabs/homeTab.R", local = TRUE)$value,
    source("tabs/TME_decTab.R", local = TRUE)$value,
    source("tabs/Sig_calTab.R", local = TRUE)$value,
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

# Run the application ---------------------------------
shiny::shinyApp(
  ui = ui, 
  server = server
  )

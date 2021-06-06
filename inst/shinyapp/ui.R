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
    source("tabs/homeTab.R", local = TRUE)$value,
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
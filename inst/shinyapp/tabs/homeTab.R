# Home Page

tabPanel(title = "Home", icon = icon("home"),
         tagList(
           tags$head(
             tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
           )
         ),
         br(),
         p(class = "lead", "Welcome to", strong("IOBRshiny"),": a user friendly web application for IOBR package"),
         tags$div(class = "home",
                  img(src = "IOBR-Package.png", width = 900)
                  ),
         h4(class = "outer", "How does it work?"),
         tags$div(class = "home",
                  img(src = "IOBR-Workflow.png", width = 900)
         )
         
)
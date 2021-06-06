
tabPanel(title = "Signature Calculation", icon = icon("calculator"),
           fluidPage(
             sidebarLayout(
               sidebarPanel = sidebarPanel(
                 h4("siderbar"),
                 fileInput("upload", "Upload a file",accept = c(".csv", ".tsv")),
                 numericInput("n", "Rows", value = 5, min = 1, step = 1)

               ),
               mainPanel = mainPanel(
                 h4("mainPanel"),
                 tableOutput("head"),
                 box(plotOutput("plot1", height = 250)),
                 
                 box(
                   title = "Controls",
                   sliderInput("slider", "Number of observations:", 1, 100, 50)
                 )
               )
             )
           )



  )


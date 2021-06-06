

# ui.sig_cal <- function(id) {
#   ns <- NS(id)
# 
# }
# 
# server.sig_cal <- function(input, output, session) {
#   ns <- session$ns
#  
# }

server.sig_cal <- function(input, output, session) {
  
  ns <- session$ns
  
  data <- reactive({
    req(input$file)
    
    ext <- tools::file_ext(input$file$name)
    switch(ext,
           csv = vroom::vroom(input$file$datapath, delim = ","),
           tsv = vroom::vroom(input$file$datapath, delim = "\t"),
           validate("Invalid file; Please upload a .csv or .tsv file")
    )
  })
  
  output$head <- renderTable({
    head(data(), input$n)
  })
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
}
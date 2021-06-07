ui.modules_sig_cal <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data upload and parameter selection"),
        tags$hr(),
        fileInput(ns("file"), NULL, accept = c(".csv")),
        actionButton(ns("button"), "Run")
      ),
      mainPanel = mainPanel(
        h4("Output"),
        # tagList(
        #   actionButton(ns("button"), label = label),
        #   verbatimTextOutput(ns("out"))
        # ),
        # tableOutput(ns("head"))
        DT::dataTableOutput(ns("head")),
        shinyjs::hidden(
          wellPanel(
            id = ns("save_csv"),
            downloadButton(ns("downloadTable"), "Save as csv")
          )
        )
      )
    )
  )
}

server.modules_sig_cal <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {

      # test
      # data("eset_stad")
      # eset_stad[1:5, 1:5]
      # write.csv(eset_stad,file = "C:/bioinfo/data/eset_stad.csv")
      # eset_stad2 <- read.csv(file = "C:/bioinfo/data/eset_stad.csv",row.names = 1)
      # tmp <- IOBR::calculate_sig_score(pdata = NULL,
      #                                  eset            = eset_stad2,
      #                                  signature       = signature_tme,
      #                                  method          = "pca",
      #                                  mini_gene_count = 2)
      
      
      upfile <- eventReactive(input$file,{
        req(input$file)
        # 
        ext <- tools::file_ext(input$file$name)
        validate(need(ext == "csv", "Please upload a csv file"))
        inFile <- input$file
        if (is.null(inFile))
          return(NULL)
        df <- read.csv(inFile$datapath,header = TRUE, row.names = 1)
        return(df)
        
      })
      
      result <- eventReactive(input$button,{
        df <- upfile()
        res <- IOBR::calculate_sig_score(pdata = NULL,
                                  eset = df,
                                  signature = signature_tme,
                                  method = "pca",
                                  mini_gene_count = 2)
        return(res)
      })
      
      output$head <- DT::renderDataTable({
          df <- result()
          DT::datatable(df)
        })
      
      observeEvent(input$button, {
        if (!is.null(input$file)) {
          shinyjs::show(id = "save_csv")
        } else {
          shinyjs::hide(id = "save_csv")
        }
      })
      
      output$downloadTable <- downloadHandler(
        filename = function() {
          paste0("sig_cal.csv")
        },
        content = function(file) {
          write.csv(result(), file, row.names = FALSE)
        }
      )
      
      
    }
  )
}

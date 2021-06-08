
# Global setting ------------------------------
options(repos = c(BiocManager::repositories(),"rforge" = "http://r-forge.r-project.org"))
getOption("repos")
library(shiny)
library(shinydashboard)
library(waiter)
library(IOBR)
library(DT)
options(shiny.maxRequestSize=100*1024^2)

# Server ----------------------------------------------
server.sig_cal <- function(input, output, session) {
  server.modules_sig_cal(id = "modules_sig_cal")
}

server.tme_dec <- function(input, output, session) {
  server.modules_tme_dec(id = "modules_tme_dec")
}

# UI -------------------------------------------
# Home Page
ui.page_home <- function() {
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
}

ui.sig_cal <- function() {
  tabPanel(title = "Signature Calculation", icon = icon("calculator"),
           ui.modules_sig_cal("modules_sig_cal")
           
           
  )
}

ui.tme_dec <- function(){
  tabPanel(title = "TME deconvolution", icon = icon("braille"),
           ui.modules_tme_dec("modules_tme_dec")
  )
}



# Modules ------------------------------------
signature_list <- list("signature_tme" = signature_tme, 
                       "signature_metabolism" = signature_metabolism, 
                       "signature_collection" = signature_collection,
                       "go_bp" = go_bp,
                       "kegg" = kegg,
                       "hallmark" = hallmark)


ui.modules_sig_cal <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data upload and parameter selection"),
        tags$br(),
        fileInput(ns("file"), label = "Upload file (Maximum Size: 100 MB)", accept = c(".csv")),
        tags$a(href="https://zenodo.org/record/4906552#.YL8BtfkzaUk", "Example data"),
        textInput(ns("ID"), label = h3("Patients identifier (Default: ID)"), value = "ID"),
        selectInput(ns("signature"), label = h3("Signature"), 
                    choices = list("signature_tme" = "signature_tme", 
                                   "signature_metabolism" = "signature_metabolism", 
                                   "signature_collection" = "signature_collection",
                                   "go_bp" = "go_bp",
                                   "kegg" = "kegg",
                                   "hallmark" = "hallmark"), 
                    selected = "signature_tme"),
        tags$br(),
        selectInput(ns("method"), 
                    label = h3("Signature Calculation method"), 
                    choices = list("PCA" = "pca", "ssGSEA" = "ssgsea", "zscore" = "zscore","integration" = "integration"), 
                    selected = "pca"),
        tags$br(),
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
                                         signature = signature_list[[input$signature]],
                                         #signature = signature_tme,
                                         method = input$method,
                                         column_of_sample = input$ID,
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

ui.modules_tme_dec <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data upload and parameter selection"),
        tags$br(),
        fileInput(ns("file"), label = "Upload file (Maximum Size: 100 MB)", accept = c(".csv")),
        tags$a(href="https://zenodo.org/record/4906552#.YL8BtfkzaUk", "Example data"),
        tags$br(),
        selectInput(ns("method"), label = h3("Deconvolution method"), 
                    choices = list("mcpcounter" = "mcpcounter", 
                                   "epic" = "epic", 
                                   "xcell" = "xcell",
                                   "cibersort" = "cibersort",
                                   "cibersort_abs" = "cibersort_abs",
                                   "ips" = "ips",
                                   "quantiseq" = "quantiseq",
                                   "estimate" = "estimate",
                                   "timer" = "timer"), 
                    selected = "cibersort"),
        tags$br(),
        sliderInput(ns("perm"), label = h3("Permutations"), min = 100, 
                    max = 1000, value = 200,step = 100),
        tags$br(),
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

server.modules_tme_dec <- function(id) {
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
        res <- IOBR::deconvo_tme(eset = df,
                                 method = input$method, 
                                 arrays = FALSE, 
                                 perm = input$perm)
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


# UI All -----------------------------------------
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
  waiter::use_waiter(),
  waiter::waiter_on_busy(html = spin_3k(), color = transparent(0.7)),
  navbarPage(
    id = "navbar",
    title = div(
      img(src = "IOBR-logo.png", height = 49.6, style = "margin:-20px -15px -15px -15px")
    ),
    # # inst/shinyapp/ui
    ui.page_home(),
    ui.sig_cal(),
    ui.tme_dec(),
    collapsible = TRUE,
    theme = shinythemes::shinytheme("cerulean")
  )
)

# Server All ---------------------------------
server <- function(input, output, session) {
  
  # inst/shinyapp/server
  server.sig_cal()
  server.tme_dec()
  
}

# Run the application ---------------------------------
shiny::shinyApp(
  ui = ui, 
  server = server
)

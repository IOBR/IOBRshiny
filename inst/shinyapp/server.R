

server <- function(input, output, session) {
  
  # inst/shinyapp/server
  source("server/TME_dec.R", local = TRUE)$value
  # source(server_file("repository.R"), local = TRUE)
  # source(server_file("modules.R"), local = TRUE)
  # source(server_file("global.R"), local = TRUE)
  # source(server_file("general-analysis.R"), local = TRUE)
}
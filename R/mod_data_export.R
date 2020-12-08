#' data_export UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_export_ui <- function(id){
  ns <- NS(id)
  tagList(
    radioButtons(ns("file_download_opts"),
                 label = "Filetype", 
                 choices = c("Excel", "Text"),
                 selected = "Excel", 
                 inline = TRUE),
    uiOutput(ns("filename")),
    uiOutput(ns("text_file_widget")),
    downloadButton(ns("download"), 
                   label = "Download",
                   style="display: block; margin: 0 auto; width: 200px;color: black;")
  )
}
    
#' data_export Server Function
#'
#' @noRd 
mod_data_export_server <- function(input, output, session, dataset){
  ns <- session$ns
  
  output$filename <- renderUI({
    if (input$file_download_opts == "Excel") {
      textInput(ns("filename_user"), 
                label = "File name",
                value = paste0(Sys.Date(), "-", "MyData"))
    } else {
      textInput(ns("filename_user"), 
                label = "File name",
                value = paste0(Sys.Date(), "-", "MyData"))
    }
  })
  
  output$text_file_widget <- renderUI({
    if (input$file_download_opts == "Text") {
      selectInput(ns("delimeter"), 
                  label = "Choose delimeter", 
                  multiple = F, 
                  choices = c("Comma" = ',',
                              "Semi-colon" = ';',
                              "Colon" = ":",
                              "Space" = " ",
                              "Tab" = "\t"))
    }
  })
  
  final_file_name <- reactive({
    if (input$file_download_opts == "Excel") {
      return(paste0(input$filename_user, ".xlsx"))
    } else {
      return(paste0(input$filename_user, ".txt"))
    }
  })
  
  output$download <- downloadHandler(
    filename = function() {
      final_file_name()
    },
    
    content = function(file) {
      print(file)
      if (input$file_download_opts == "Excel") {
        writexl::write_xlsx(x = dataset$processed_data(), 
                            path = file) 
      } else {
        utils::write.table(dataset$processed_data(),
                           file = file, 
                           sep = input$delimeter, 
                           row.names = F)
      }
    }
  )
  
  
}
    
## To be copied in the UI
# mod_data_export_ui("data_export_ui_1")
    
## To be copied in the server
# callModule(mod_data_export_server, "data_export_ui_1")
 

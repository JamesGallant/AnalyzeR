#' file_upload UI Function
#'
#' @description file upload module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
#' 
#' @return returns a reactive dataframe containing standardised data
#'  

mod_file_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    numericInput(ns("experiment_count"),
                 label = "Number of data files",
                 value = 1,
                 min = 1),
    actionButton(ns("render_input"),
                 label = "Render upload button",
                 icon = icon("fas fa-plus-circle"),
                 width = 200),
    
    fileInput(ns("user_file_metadata"),
              label = "upload metadata",
              accept = c("text/csv",
                         ".csv"), 
              buttonLabel = tags$i(class="fas fa-upload")),
    
    uiOutput(ns("upload_widgets")),
    
    actionButton(ns("submit"),
                 label = "Submit",
                 icon = icon("far fa-play-circle"),
                 width = 200)
  )
}
    
#' file_upload Server Function
#'
#' @noRd 
mod_file_upload_server <- function(input, output, session){
  ns <- session$ns
  
  eventCounter <- reactiveValues(count=0)
  
  observeEvent(input$render_input, {
    eventCounter$count <- eventCounter$count + 1
    experiment_count <- input$experiment_count
    output$upload_widgets <- renderUI({
      lapply(1:experiment_count, function(x) {
        fileInput(ns(paste0("user_file_data", x)),
                  label = "upload experiment",
                  accept = c("text/csv",
                             ".csv"), 
                  buttonLabel = tags$i(class="fas fa-upload"))
      })
    })
  })
  
  user_data <- eventReactive(input$submit, {
    metadata_filepath <- input$user_file_metadata$datapath
    metadata_extension <- tools::file_ext(input$user_file_metadata$datapath)
    
    req(metadata_filepath)
    
    validate(
      need(metadata_extension == "csv", "Please select a csv file")
    )
    
    metadata <- utils::read.csv(file = metadata_filepath, header = T, sep = ",")
    req(input$user_file_data1)
    
    dataframes <- list()
    
    for (dataset_count in 1:input$experiment_count) {
      filepath <- eval(parse(text = paste("input$user_file_data", dataset_count, "$datapath", sep = '')))
      filename <- strsplit(x = eval(parse(text = paste("input$user_file_data", dataset_count, "$name", sep = ''))),
                           split = "\\.")[[1]][1]
      
      userdata <- utils::read.csv(file = filepath, header = TRUE)
      
      integratedIntensity <- columngrep(substring="Intensity_IntegratedIntensity", dataframe=userdata)
      meanintensity <- columngrep(substring="Intensity_MeanIntensity", dataframe=userdata)
      
      target_cols <- c(integratedIntensity, meanintensity, "ImageNumber")
      userdata <- userdata[target_cols]
      
      userdata = userdata %>% 
        # -- not very good practise, this will propagate to plots and be annoying
        dplyr::mutate(user_factor = filename)
      
      
      userdata <- cross_map_df(df1 = metadata, df2 = userdata, df1_index_col = "Group_Index", 
                               df1_target_col = columngrep(substring = "FileName", dataframe = metadata)[1],
                               df2_matching_col = "ImageNumber")
      
      
      
      dataframes[[dataset_count]] <- userdata
    }
    
    combined_data <- dplyr::bind_rows(dataframes)
    
    return(combined_data)
  })
  
  return(
    list(
      uploaded_data = reactive({ user_data() })
    )
  )
  
}
    
## To be copied in the UI
# mod_file_upload_ui("file_upload_ui_1")
    
## To be copied in the server
# callModule(mod_file_upload_server, "file_upload_ui_1")
 

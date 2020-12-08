#' data_handling UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 
mod_data_handling_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("colpick")),
    checkboxGroupInput(ns("user_opts"), 
                       label = "Data options", 
                       choices = c("Transform", "Impute"), 
                       inline = TRUE),
    uiOutput(ns("display_transforms")),
    uiOutput(ns("display_impute")),
    uiOutput(ns("impute_fixed_value"))
  )
}
    
#' data_handling Server Function
#'
#' @noRd 
mod_data_handling_server <- function(input, output, session, dataset){
  ns <- session$ns
  
  output$display_transforms <- renderUI({
    display_widget <- c(!is.null(input$user_opts), "Transform" %in% input$user_opts)
    if (all(display_widget)) {
      selectInput(ns("transforms"), 
                  label = "Choose Transform", 
                  choices = c("log10", "log2", "ln", "square root"), 
                  selected = "log2",
                  multiple = F)
    }
  })
  
  output$display_impute <- renderUI({
    display_widget <- c(!is.null(input$user_opts), "Impute" %in% input$user_opts)
    if (all(display_widget)) {
      selectInput(ns("imputation"),
                  label = "Imputation method",
                  choices = c("mean", "median", "lower quantile", "fixed value"), 
                  selected = "lower quantile")
    }
  })
  
  output$impute_fixed_value <- renderUI({
    display_widget <- c(!is.null(input$imputation), input$imputation == "fixed value")
    if (all(display_widget)) {
      numericInput(ns("imputation_value"), 
                   label = "Choose value", value = 0)
    }
  })
  
  output$colpick <- renderUI({
    data <- dataset$uploaded_data()
    
    columns <- c(columngrep(dataframe = data, substring="Intensity_IntegratedIntensity"),
                 columngrep(dataframe = data, substring="Intensity_MeanIntensity"))
    
    shinyWidgets::pickerInput(ns("user_col_select"),
                                        label = "Select columns", 
                                        choices = unlist(columns),
                                        multiple = T,
                                        options = list(`actions-box` = TRUE, 
                                                       `selected-text-format` = "count > 0"), 
                                        choicesOpt = list(
                                                         style = rep(("color: black;"),length(columns))))
    
  })
  
  

  return(
    list(
      user_opts = reactive({input$user_opts}),
      transforms = reactive({ input$transforms }),
      columns = reactive({ input$user_col_select }),
      imputations = reactive({ input$imputation}),
      imputation_value = reactive({ input$imputation_value })
    )
  )
  

}
    
## To be copied in the UI
# mod_data_handling_ui("data_handling_ui_1")
    
## To be copied in the server
# callModule(mod_data_handling_server, "data_handling_ui_1")
 

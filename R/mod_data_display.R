#' data_display UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_display_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("display_data"))
  )
}
    
#' data_display Server Function
#'
#' @noRd 
mod_data_display_server <- function(input, output, session, dataset, metadata){
  ns <- session$ns
  
  display <- reactive({
    if (is.null(dataset$uploaded_data())) {
      out <- NULL
    } else {
    
      if (is.null(metadata$user_opts())) {
        out <- dataset$uploaded_data()
      } else {
        run_function <- c("Transform" %in% metadata$user_opts(), "Impute" %in% metadata$user_opts())
        if (all(run_function)) {
          
          transformed <- switch (metadata$transforms(),
                                 "log10" = {transform_log10(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                                 "ln" = {transform_ln(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                                 "log2" = {transform_log2(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                                 "square root" = {transform_sqrt(dataset=dataset$uploaded_data(), columns=metadata$columns())})
          
          out <- switch (metadata$imputations(),
                         "mean" = {impute_mean(dataset=transformed, columns=metadata$columns())},
                         "median" = {impute_median(dataset=transformed, columns=metadata$columns())},
                         "lower quantile" = {impute_lower(dataset=transformed, columns=metadata$columns())},
                         "fixed value" = {impute_fixed(dataset=transformed, columns=metadata$columns(), 
                                                       value=metadata$imputation_value())})
          
        } else if (metadata$user_opts()[1] == "Transform") {
          
          out <- switch (metadata$transforms(),
                         "log10" = {transform_log10(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "ln" = {transform_ln(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "log2" = {transform_log2(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "square root" = {transform_sqrt(dataset=dataset$uploaded_data(), columns=metadata$columns())})
          
        } else if (metadata$user_opts()[1] == "Impute") {
          
          out <- switch (metadata$imputations(),
                         "mean" = {impute_mean(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "median" = {impute_median(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "lower quantile" = {impute_lower(dataset=dataset$uploaded_data(), columns=metadata$columns())},
                         "fixed value" = {impute_fixed(dataset=dataset$uploaded_data(), columns=metadata$columns(), 
                                                       value=metadata$imputation_value())})
        } 
        
      }
    }
      
    return(out)
  })
  
  output$display_data <- DT::renderDataTable({

      DT::datatable(display(), extensions = 'Buttons',
                    options = list( 
                      dom = "Blfrtip",
                      scrollX = T,
                      scrollY = T,
                      # customize the length menu
                      lengthMenu = list( c(10, 20, -1) # declare values
                                         , c(10, 20, "All") # declare titles
                      ), # end of lengthMenu customization
                      pageLength = 10 
                    ))
  })
  
  return(
    list(
      processed_data = reactive({ display()  })
    )
  )
}
    
## To be copied in the UI
# mod_data_display_ui("data_display_ui_1")
    
## To be copied in the server
# callModule(mod_data_display_server, "data_display_ui_1")
 

#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  # -- returns reactive data dataframe, feed into second mod
  user_data <- callModule(mod_file_upload_server, "file_upload_ui_1")
  
  meta_data <- callModule(mod_data_handling_server, "data_handling_ui_1", dataset=user_data)
  
  processed_data <- callModule(mod_data_display_server, "data_display_ui_1", dataset=user_data, metadata=meta_data)
  
  callModule(mod_data_export_server, "data_export_ui_1", dataset = processed_data)
  
  plot_handling_inputs <- callModule(mod_plot_handling_server, "plot_handling_ui_1", dataset = processed_data)
  
  callModule(mod_plot_display_server, "plot_display_ui_1", plot_settings = plot_handling_inputs, plot_data = processed_data)
  
}

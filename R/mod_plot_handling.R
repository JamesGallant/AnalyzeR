#' plot_handling UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_handling_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(ns("widget_plot_type"),
                label = "Select plot type",
                choices = c("Bar", 
                            "Point", 
                            "Boxplot",
                            "Density",
                            "Violin"),
                selected = "Point",
                multiple = FALSE),
    uiOutput(ns("widget_point_type")),
    uiOutput(ns("widget_point_size")),
    uiOutput(ns("widget_x_axis")),
    uiOutput(ns("widget_y_axis")),
    radioButtons(inputId = ns("widget_fill_choice"),
                 label = "Fill by", 
                 choices = c("Factor", "Static"), inline = TRUE, 
                 selected = "Static"),
    uiOutput(ns("widget_fill_opts"))
  )
}
    
#' plot_handling Server Function
#'
#' @noRd 
mod_plot_handling_server <- function(input, output, session, dataset){
  ns <- session$ns
  
  output$widget_point_type <- renderUI({
    if (input$widget_plot_type == "Point" | input$widget_plot_type == "Boxplot") {
      selectInput(ns("point_type"), 
                  label = "Select point shape",
                  choices = c(
                    "Circle" = 21, 
                    "Square" = 22,
                    "Diamond" = 23,
                    "Triangle1" = 24,
                    "Triangle2" = 25
                  ), selected = "Circle") 
    } else {
      return(NULL)
    }
  })
  
  output$widget_point_size <- renderUI({
    if (input$widget_plot_type == "Point" | input$widget_plot_type == "Boxplot") {
      sliderInput(ns("point_size"),
                  label = "Select point size",
                  min = 1, max = 20, step = 1,
                  value = 3, animate = TRUE, width = 200)
    }
  })
  
  output$widget_x_axis <- renderUI({
    col_options <- c("None", colnames(dataset$processed_data()))
    
    shinyWidgets::pickerInput(ns("user_column_x"),
                              label = "Select X axis", 
                              choices = unlist(col_options),
                              multiple = FALSE,
                              options = list(`actions-box` = TRUE, 
                                             `selected-text-format` = "count > 0"), 
                              choicesOpt = list(
                                style = rep(("color: black;"),length(col_options))))
  })
  
  output$widget_y_axis <- renderUI({
    col_options <- c("None", colnames(dataset$processed_data()))
    
    shinyWidgets::pickerInput(ns("user_column_y"),
                              label = "Select y axis", 
                              choices = unlist(col_options),
                              multiple = FALSE,
                              options = list(`actions-box` = TRUE, 
                                             `selected-text-format` = "count > 0"), 
                              choicesOpt = list(
                                style = rep(("color: black;"),length(col_options))))
  })
  
  user_colour <- reactive({
    if (input$widget_fill_choice == "Static") {
      return(colourpicker::colourInput(ns("widget_fill_picker_static"), 
                                       label = "Choose fill colour",
                                       value = "#000000",
                                       allowTransparent = TRUE))
    } else {
      
      dataset <- dataset$processed_data()
      validate(need(!is.numeric(dataset$user_factor),message = "Choose non numeric data for factors"))
      #-- This returns the name of user_factor column, name stays static as requested by Coen
      return(lapply(unique(dataset$user_factor), function(x) {
        colourpicker::colourInput(ns(paste("widget_fill_picker_dynamic", x, sep = "_")), 
                                  label = paste(x, "colour", sep = " "),
                                  value = "#000000",
                                  allowTransparent = TRUE)
      }))
      
    }
  })
  
  output$widget_fill_opts <- renderUI({
    user_colour()
  })
  
  return(
    list(
      plot_type = reactive({input$widget_plot_type}),
      point_type = reactive({ input$point_type }),
      point_size = reactive({ input$point_size }),
      user_column_x = reactive({ input$user_column_x}),
      user_column_y = reactive({ input$user_column_y }),
      fill_choice = reactive({ input$widget_fill_choice }),
      static_widget_col = reactive({ input$widget_fill_picker_static }),
      dynamic_widget_col = reactive({ 
        dataset <- dataset$processed_data()
        ids <- lapply(unique(dataset$user_factor), function(x) {
          # -- if this does not work use intergers
          eval(parse(text=paste("input$widget_fill_picker_dynamic", eval(x), sep = "_")))
        })
        return(ids)
      })
    )
  )

}
    
## To be copied in the UI
# mod_plot_handling_ui("plot_handling_ui_1")
    
## To be copied in the server
# callModule(mod_plot_handling_server, "plot_handling_ui_1")
 

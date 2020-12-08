#' plot_display UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
#'
mod_plot_display_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      fluidRow(
        column(6,
               plotOutput(ns("user_plot")),
               fluidRow(
                 column(4,
                        textInput(ns("plot_filename"),
                                  label = "Filename",
                                  placeholder = "plot name")),
                 column(4,
                        selectInput(ns("filetype"), 
                                    label = "Filetype", 
                                    choices = c("tiff", "jpeg",
                                                "png", "pdf",
                                                "svg"),
                                    selected = "tiff")),
                 column(4,
                        downloadButton(outputId = ns("figure_download"), 
                                       label = "download", 
                                       style="display: block; margin-top: 2.6vh; width: 200px;color: black;"))
               )),
        column(6,
               fluidRow(
                 column(3,
                        uiOutput(ns("widget_x_axis"))),
                 column(3,
                        uiOutput(ns("widget_y_axis"))),
                 column(3,
                        sliderInput(ns("widget_tick_x_rotate"), 
                                    label = "Rotate x axis",
                                    min = 0, max = 90, step = 10, value = 0)),
                 column(3,
                        sliderInput(ns("widget_tick_y_rotate"), 
                                    label = "Rotate y axis",
                                    min = 0, max = 90, step = 10, value = 0))
                 ),
               fluidRow(
                 column(3,
                        textInput(ns("widget_plot_title"), 
                                  label = "Plot title", 
                                  placeholder = "Your title here")),
                 column(3,
                        sliderInput(ns("widget_title_position"), 
                                    label = "Position plot", 
                                    min = 0, max = 1, step = 0.1, value = 0.5)),
                 column(6,
                        radioButtons(ns("widget_legend_position"),
                                     label = "Legend position", 
                                     choices = c("none", "left", "right", "bottom", "top"),
                                     inline = TRUE))
               )
      )
    )))
}
    
#' plot_display Server Function
#'
#' @noRd 
mod_plot_display_server <- function(input, output, session, plot_settings, plot_data){
  ns <- session$ns
  
  output$widget_x_axis <- renderUI({
    return(textInput(ns("label_x_axis"), 
                     label = "X axis label", 
                     value = plot_settings$user_column_x()))
  })
  
  output$widget_y_axis <- renderUI({
    return(textInput(ns("label_y_axis"), 
                     label = "Y axis label", 
                     value = plot_settings$user_column_y()))
  })
  
  colour <- reactive({
    if (plot_settings$fill_choice() == "Factor") {
      return(plot_settings$dynamic_widget_col())
    } else {
      return(plot_settings$static_widget_col())
    }
  })
  
  gg_plot <- reactive({
    #-- able to add way more plots easily this way calls from utils_plot_display.R
    p <-  switch (plot_settings$plot_type(), 
                 "Point" = {point_plot(data = plot_data$processed_data(), 
                                   xcol = plot_settings$user_column_x(), 
                                   ycol = plot_settings$user_column_y(), 
                                   user_colour = colour(),
                                   type = plot_settings$point_type(),
                                   size = plot_settings$point_size(),
                                   x_axis_label = input$label_x_axis, 
                                   x_axis_rotation = input$widget_tick_x_rotate,
                                   y_axis_label = input$label_y_axis, 
                                   y_axis_rotation = input$widget_tick_y_rotate,
                                   plot_title = input$widget_plot_title, 
                                   plot_title_position = input$widget_title_position,
                                   legend_position = input$widget_legend_position)},
                 
                 "Bar" = {bar_plot(data = plot_data$processed_data(),
                                   xcol = plot_settings$user_column_x(), 
                                   ycol = plot_settings$user_column_y(),
                                   user_colour = colour(),
                                   x_axis_label = input$label_x_axis, 
                                   x_axis_rotation = input$widget_tick_x_rotate,
                                   y_axis_label = input$label_y_axis, 
                                   y_axis_rotation = input$widget_tick_y_rotate,
                                   plot_title = input$widget_plot_title, 
                                   plot_title_position = input$widget_title_position,
                                   legend_position = input$widget_legend_position)},
                 
                 "Boxplot" = {box_plot(data = plot_data$processed_data(),
                                       xcol = plot_settings$user_column_x(), 
                                       ycol = plot_settings$user_column_y(),
                                       user_colour = colour(),
                                       size = plot_settings$point_size(),
                                       type = plot_settings$point_type(),
                                       x_axis_label = input$label_x_axis, 
                                       x_axis_rotation = input$widget_tick_x_rotate,
                                       y_axis_label = input$label_y_axis, 
                                       y_axis_rotation = input$widget_tick_y_rotate,
                                       plot_title = input$widget_plot_title, 
                                       plot_title_position = input$widget_title_position,
                                       legend_position = input$widget_legend_position)},
                 
                 "Density" = {density_plot(data = plot_data$processed_data(),
                                           xcol = plot_settings$user_column_x(), 
                                           ycol = plot_settings$user_column_y(),
                                           user_colour = colour(),
                                           x_axis_label = input$label_x_axis, 
                                           x_axis_rotation = input$widget_tick_x_rotate,
                                           y_axis_label = input$label_y_axis, 
                                           y_axis_rotation = input$widget_tick_y_rotate,
                                           plot_title = input$widget_plot_title, 
                                           plot_title_position = input$widget_title_position,
                                           legend_position = input$widget_legend_position)},
                 
                 "Violin" = {violin_plot(data = plot_data$processed_data(),
                                         xcol = plot_settings$user_column_x(), 
                                         ycol = plot_settings$user_column_y(),
                                         user_colour = colour(),
                                         x_axis_label = input$label_x_axis, 
                                         x_axis_rotation = input$widget_tick_x_rotate,
                                         y_axis_label = input$label_y_axis, 
                                         y_axis_rotation = input$widget_tick_y_rotate,
                                         plot_title = input$widget_plot_title, 
                                         plot_title_position = input$widget_title_position,
                                         legend_position = input$widget_legend_position)})
    
    
    return(p)

  })
    
  output$user_plot <- renderPlot({
    if (!is.null(plot_data$processed_data())) {
      
      gg_plot()
    }
  })
  
  file_name <- reactive({
    if (input$plot_filename == "") {
      name <- paste(Sys.Date(), ".", input$filetype, sep = "")
    } else {
      name <- paste(input$plot_filename, ".", input$filetype, sep = "")
    }
    
    return(name)
  })
  
  output$figure_download <- downloadHandler(
    filename = function() { file_name() },
    content = function(file) {
      ggsave(file, 
             plot = gg_plot(),
             device = input$filetype,
             dpi = 300)
    }
  )
}
    
## To be copied in the UI
# mod_plot_display_ui("plot_display_ui_1")
    
## To be copied in the server
# callModule(mod_plot_display_server, "plot_display_ui_1")
 

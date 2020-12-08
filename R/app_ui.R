#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Fishalyzer"),
      # -- sidebar items
      shinydashboard::dashboardSidebar(
        # -- conditionally render panel based on current active tab
        conditionalPanel(
          condition = "input.maintabs == 'welcome'",
          shinydashboard::sidebarMenu(
            # -- items for welcome tab in sidebar
          )
        ),
        conditionalPanel(
          condition = "input.maintabs == 'data'",
          shinydashboard::sidebarMenu(
            ## -- items for data handiling in sidebar
            shinydashboard::menuItem(text = "File upload",
                                     icon = icon("fas fa-file-upload"),
                                     mod_file_upload_ui("file_upload_ui_1")),
            shinydashboard::menuItem(text = "Data handling",
                                     icon = icon("fas fa-calculator"),
                                     mod_data_handling_ui("data_handling_ui_1")),
            shinydashboard::menuItem(text = "Export data",
                                     icon = icon("fas fa-file-download"),
                                     mod_data_export_ui("data_export_ui_1"))
          )
        ),
        conditionalPanel(
          condition = "input.maintabs == 'plotting'",
          shinydashboard::sidebarMenu(
            # -- items for the plotting tab in sidebar
            shinydashboard::menuItem(text = "Plot controls",
                                     icon = icon("fas fa-chart-line"),
                                     mod_plot_handling_ui("plot_handling_ui_1"))
          )
        )
      ),
      # -- body items
      shinydashboard::dashboardBody(
        tabsetPanel(id = "maintabs",
                    tabPanel(title = "Welcome",
                             value = "welcome",
                             tags$div(style = "background-color: white",
                                      includeMarkdown(
                                        system.file("/app/www/readit.md", package = "FishalyzeR")
                                      ))),
                    tabPanel(title = "Data",
                             value = "data",
                             icon = icon("fas fa-database"),
                             fluidPage(
                               fluidRow(
                                 mod_data_display_ui("data_display_ui_1")
                               )
                             )),
                    tabPanel(title = "Plotting",
                             value = "plotting",
                             icon = icon("fas fa-chart-pie"),
                             fluidPage(
                               fluidRow(
                                 mod_plot_display_ui("plot_display_ui_1")
                               )
                             )))
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'FishalyzeR'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


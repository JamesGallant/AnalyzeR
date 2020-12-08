# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Add one line by package you want to add as dependency
usethis::use_package("shinydashboard")
usethis::use_package("shiny")
usethis::use_package("dplyr")
usethis::use_pipe()
usethis::use_package("shinyWidgets")
usethis::use_package("writexl")
usethis::use_package("ggplot2")
usethis::use_package("colourpicker")
usethis::use_package("qpdf")
usethis::use_package("stats")

## Add modules ----
## Create a module infrastructu re in R/
#golem::add_module( name = "name_of_module1", utils = "module1_utils", fct = "module1_fct" ) # Name of the module
golem::add_module( name = "file_upload"  )
golem::add_module(name = "data_handling")
golem::add_module(name = "data_display")
golem::add_module(name = "data_export")
golem::add_module(name = "plot_handling")
golem::add_module(name = "plot_display")


## Add helper functions ----
## Creates ftc_* and utils_*
golem::add_utils( "file_upload" )
golem::add_utils("data_display")
golem::add_utils("plot_display")

## External resources
## Creates .js and .css files at inst/app/www
#golem::add_js_file( "tutorials" )
#golem::add_js_handler( "handlers" )

## Add internal datasets ----
## If you have data in your package
#usethis::use_data_raw( name = "my_dataset", open = FALSE ) 

## Tests ----
## Add one line by test you want to create
usethis::use_test( "app" )
usethis::use_test( "file_upload" )
usethis::use_test("data_display")
# Documentation

## Vignette ----
usethis::use_vignette("FishalyzeR")
devtools::build_vignettes()

## Code coverage ----
## (You'll need GitHub there)
usethis::use_coverage()
usethis::use_github()
usethis::use_travis()
usethis::use_appveyor()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")


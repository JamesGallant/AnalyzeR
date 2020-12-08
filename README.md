
<div>
  <img src = "inst\app\www\gifs\intro.gif", width = 90%>
</div>
# Welcome to Fishalyzer data visualization

Fishalyzer is used in conjunction with the cell profiler output for automatic detection and intenity counting of zebrafish embryo's. This document explains how to use this software and alter it.

## Using Fishalyzer

Fishalyzer is hosted at [insert link here]() and can be accessed in the browser. 

### Installing from a R package
If you recieved this software as a tar.gz R package it can be installed in the following way

```r
remotes::install_local(path_to_package)
```
The application can be opened with the following code:
```r
Fishalyzer::run_app()
```

### Requirements
You only require the outputs from cell profiler. At minimum there should be two files, a file containing the metadata of your analysis and a file containing the intensity meassurements. The names you give in cell profiler will be used as is here. The name of the file containing the intensity meassurements will be used as a factor later on. If you would like to change the `user_factor` field, change the meassurements file. 

### Uploading
Choose the number of files to upload, the metadata file is always required. Select the number of meassurement files by increasing the counter and click render upload button. If you have two meassurement files then these should be set to two. You can rerender these buttons to start new uploads. All the columns with the name __intensity__ will be extracted from the meassurements file(s) and the name of the file will be used to create a factor for colouring. The image number and filename will be extracted from the metadata file and a single table will be created. 

### Data handling
This section is optional and provides some interaction with the data. Its possible to select either a single column or multiple columns to perform actions on. The actions are transformations and imputations. Several transformations are availible, log2 is the default. Transformations are used to change the distribution of data to make it more visually appealing while retaining the characteristics of the data frame or for statistics. Several imputations are availible, however I recommend lower quantile. Lower quantile finds the lowest and highest standard deviation of the lower quantile from the normal distribution. This standard deviation is used to choose numbers at random within this quantile. The data has to be normally distributed for this to make sense. This option works best for data that is missing either due to being below the detection limit or missing as a result of experimental factors. 

## Exporting data
You can choose to export the table to excel or any common text file variant for outside analysis. 

## Plotting
A large number of plots are available as well as controls for them. Select the plot type and change the layouts by selecting which data to plot on the x axis/y-axis. The `user_factor` column can be used to colour by each uploaded file. To do this, select fill by factor and use the colour picker to change the colours. The transparency can be controlled by selecting the transparency value in the far right bar of the colour picker. 

## Download plots
To download a plot, create the plot first and keep it in the visual pane. Select the filename, if no file name is selected the current date will be used. Select the type of file, most common filetypes are available for both rastered and vector based plots. If you would like to edit the plot in software like illustrator or photoshop use SVG or PDF as the filetype. Clicking download will save the plot in your downloads folder.

## Reactivity
The data flow is reactive in this application, meaning that changes in data handling will flow through to the plots as well. 

## Developing

Fishalyzer is created with the shiny web frame work maintained by R studio. Knowledge of the R statistical programming language and the shiny web framework is thus required. Fishalyzer follows a modular design based
on the [Golem](https://engineering-shiny.org/successfulshinyapp.html) package. Use this guide to familiarise yourself with the folder and file structures.

### Virtual environments

The dependencies are tracked using renv and the lockfile that comes with this project. If you add packages, remmber to declare them in the namespace and that they are properly installed in a virtual R environment.


using renv
```r
library(renv)

init() # intialises a new virtual environment

restore(lockfile = path_to_lockfile) # restores a previous environment

install.packages(package_name) # adds a package to the renv

snapshot() # store the package in the lockfile
```
Distribute the lockfile for others to remain updated with the project. 


### Version control

You can follow any type of version control, we used the git flow style.

```bash
git clone --single-branch --branch <dev> <remote-repo> # clone the dev branch of the repo

git checkout -b dev/feature # create a feature branch and tests

git checkout dev # switch to dev once done

git merge dev dev/feature # merge branches

git push # push to remote and create pull reques

```
### Testing

Utility functions are tested, unless they are from other well tested packages or from base R. Follow the golem instructions for creating tests. 

### Deploying as a R package

Once you have made your changes test the package:
```r
devtools::check()
```
If evereything works:
```r
devtools::build()

```
A tar.gz will be created which can be used to install the package in the R-lib folder. The tar.gz is usually created one level up.


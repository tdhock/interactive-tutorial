##
##
##  Install script for useR 2016 tutorial on interactive graphics
##
##

CRANpackages <- c("dplyr", "shiny", "plotly", "xts", "highcharter", "DiagrammeR", "dygraphs",
                  "ggplot2", "htmlwidgets", "leaflet", "viridis")

install.packages(CRANpackages)

require(devtools)
install_github('ramnathv/rCharts', force=TRUE)

install_github('ekstroem/MESS', force=TRUE)



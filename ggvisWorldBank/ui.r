data(WorldBank, package="animint")
years <- unique(WorldBank$year)

shinyUI(pageWithSidebar(
  div(),
  sidebarPanel(
    sliderInput("year", "Year", min = min(years), max = max(years),
                value=1970, step = 1),
    uiOutput("ggvis_ui")
  ),
  mainPanel(
    ggvis_output("plot1")
    ##tableOutput("mtc_table")
  )
))

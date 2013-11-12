data(WorldBank, package="animint")
years <- unique(WorldBank$year)

shinyUI(pageWithSidebar(
  div(),
  sidebarPanel(
    sliderInput("year", "Year", min = min(years), max = max(years),
                value=1970, step = 1, format="#",
                animate=animationOptions(interval=2000, loop=TRUE))
  ),
  mainPanel(
    ggvis_output("ggvis"),
    plotOutput("ggplot2")
  )
))

data(WorldBank, package="animint")
years <- unique(WorldBank$year)
countries <- sort(unique(WorldBank$country))
countryList <- structure(as.list(countries),names=countries)
shinyUI(pageWithSidebar(
  div(),
  sidebarPanel(
    sliderInput("year", "Year", min = min(years), max = max(years),
                value=1970, step = 1, format="#",
                animate=animationOptions(interval=2000, loop=TRUE)),
    selectInput("country", "Country", countryList, selected="Japan")
  ),
  mainPanel(
    ggvis_output("scatter"),
    ggvis_output("ts")
  )
))

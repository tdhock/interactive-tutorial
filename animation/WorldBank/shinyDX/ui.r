years <- unique(WorldBank$year)
countries <- sort(unique(WorldBank$country))
countryList <- structure(as.list(countries),names=countries)
vars <- names(WorldBank)
shinyUI(pageWithSidebar(
  div(),
  sidebarPanel(
    sliderInput("year", "Year", min = min(years), max = max(years),
                value=1970, step = 1, format="#",
                animate=animationOptions(interval=2000, loop=TRUE)),
    selectInput("country", "Country", countryList, selected="Japan"),
    selectInput("x", "Scatterplot x",
                vars, selected="fertility.rate"),
    selectInput("y", "Scatterplot y",
                vars, selected="life.expectancy"),
    selectInput("size", "Scatterplot size",
                vars, selected="population"),
    selectInput("label", "Scatterplot text label",
                vars, selected="country"),
    selectInput("color", "Scatterplot and time series color",
                vars, selected="region"),
    selectInput("tsy", "Time series y", vars, selected="life.expectancy")
  ),
  mainPanel(
    plotOutput("scatter"),
    plotOutput("ts")
  )
))

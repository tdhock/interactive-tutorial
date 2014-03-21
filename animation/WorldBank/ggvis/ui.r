data(WorldBank, package="animint")
years <- unique(WorldBank$year)
countries <- sort(unique(WorldBank$country))
countryList <- structure(as.list(countries),names=countries)
shinyUI(fluidPage(
  titlePanel("ggvis Interactive Graphics"),
  fluidRow(
    column(2, sliderInput("year", "Year", min = min(years), max = max(years),
                           value=1970, step = 1, format="#",
                           animate=animationOptions(interval=2000, loop=TRUE)),
                    selectInput("country", "Country", countryList, selected="Japan")), 
    column(4, ggvis_output("ts")),
    column(6, ggvis_output("scatter"))   
  )
))

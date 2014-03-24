data(WorldBank, package="animint")
years <- unique(WorldBank$year)
countries <- sort(unique(WorldBank$country))
countryList <- structure(as.list(countries),names=countries)
shinyUI(fluidPage(
  titlePanel("ggvis Interactive Graphics", tags$head(tags$style(type="text/css", "#g47 { display: none;} #g25 { display: none;} #g69 { display: none;} .ggvis-control { display: none;}"))
  ),
  fluidRow(
    column(2, sliderInput("year", "Year", min = 1960, max = 2011,
                           value=1960, step = 1, format="#",
                           animate=animationOptions(interval=2000, loop=TRUE)),
                    selectInput("country", "Country", countryList, selected="Japan")), 
    column(4, ggvis_output("ts")),
    column(6, ggvis_output("scatter"))   
  )
))

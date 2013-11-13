library(shiny)
library(ggvis)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)
regions <- levels(WorldBank$region)

shinyServer(function(input, output, session) {
  this.year <- reactive({
    current.year <- as.character(input$year)
    dat <- years[[current.year]]
    selected <- input$country == dat$country
    dat$hilite <- ifelse(selected, "yes", "no")
    dat$width <- ifelse(selected, 5, 0)
    dat
  })
  scatter <- ggvis(this.year,
                   props(x= ~fertility.rate, y= ~life.expectancy,
                         size= ~population, fill= ~region,
                         ##strokeWidth= ~width,
                         stroke= ~hilite),
                   mark_symbol(),
                   dscale("stroke", "nominal", range=c("white", "black")),
                   ##dscale("strokeWidth","numeric",domain=c(0,5),range=c(0,5)),
                   dscale("x", "numeric", domain=fertility.range),
                   dscale("y", "numeric", domain=life.range))
  r_gv <- reactive(scatter)
  # Set up observers for the spec and the data
  observe_ggvis(r_gv, "scatter", session, "svg")
})

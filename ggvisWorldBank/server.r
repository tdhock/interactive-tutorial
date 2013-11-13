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

  r_gv <- reactive({
    this.year <- years[[as.character(input$year)]]
    this.year$hilite <- ifelse(this.year$country==input$country, "yes", "no")
    this.country <- subset(this.year, country==input$country)
    ggvis(props(x = ~fertility.rate, y = ~life.expectancy),
          ##dscale("opacity", "nominal", domain=c("yes","no"), range=c(1,1/2)),
          mark_symbol(props(size = ~population,
                            ##opacity = ~hilite,
                            fill = ~region), this.year),
          ##mark_text(props(text = ~country), this.country),
          dscale("x", "numeric", domain=fertility.range),
          ##dscale("colour", "nominal", domain=regions, range=region.colors),
          dscale("y", "numeric", domain=life.range))
  })
  # Set up observers for the spec and the data
  observe_ggvis(r_gv, "ggvis", session, "svg")

})

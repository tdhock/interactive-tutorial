library(shiny)
library(ggvis)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
countries <- split(WorldBank, WorldBank$country)
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)
regions <- levels(WorldBank$region)

library(RColorBrewer)
region.colors <- brewer.pal(length(regions), "Set1")

shinyServer(function(input, output, session) {
  this.year <- reactive({
    current.year <- as.character(input$year)
    dat <- years[[current.year]]
    selected <- input$country == dat$country
    dat$hilite <- ifelse(selected, "yes", "no")
    dat$width <- ifelse(selected, 5, 0)
    dat
  })
  ## Scatterplot.
  scatter <- ggvis(this.year,
                   props(x= ~fertility.rate, y= ~life.expectancy,
                         size= ~population, stroke= ~region,
                         ##strokeWidth= ~width,
                         fill= ~hilite),
                   mark_symbol(),
                   dscale("fill", "nominal", range=c("white", "black")),
                   dscale("stroke", "nominal", range=region.colors),
                   ##dscale("strokeWidth","numeric",domain=c(0,5),range=c(0,5)),
                   dscale("x", "numeric", domain=fertility.range),
                   dscale("y", "numeric", domain=life.range))
  r_gv <- reactive(scatter)
  observe_ggvis(r_gv, "scatter", session, "svg")
  ## Time series plot
  this.country <- reactive({
    countries[[input$country]]
  })
  this.year.vline <- reactive({
    current.year <- as.character(input$year)
    dat <- years[[current.year]][1:2,]
    dat$life.expectancy <- life.range
    dat
  })
  ts <- ggvis(props(x= ~year, y= ~life.expectancy),
              ##mark_line(data=by_group(country)), #doesn't work!
              mark_symbol(props(fill := "white", stroke := "black",
                                opacity := 1/10),
                          data=WorldBank),
              mark_symbol(data=this.country),
              mark_line(data=this.year.vline))
  r_gv2 <- reactive(ts)
  # Set up observers for the spec and the data
  observe_ggvis(r_gv2, "ts", session, "svg")
})


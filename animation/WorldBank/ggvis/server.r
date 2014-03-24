library(shiny)
library(ggvis)

data(WorldBank, package="animint")
WorldBank <- subset(WorldBank, !is.na(life.expectancy) & !is.na(population) & !is.na(fertility.rate))
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
  scatter <- ggvis(this.year,
                   props(x= ~fertility.rate, y= ~life.expectancy,
                         size= ~population, stroke= ~region,
                         ##strokeWidth= ~width,
                         fill= ~hilite)) +
                   layer_point() +
                   dscale("stroke", "nominal", range=region.colors, name="stroke") +
                   dscale("fill", "nominal", name="fill", range=c("white", "black")) +
                   dscale("size", "numeric", name="size") +
                   dscale("x", "numeric", domain=fertility.range) + #manual limits!
                   dscale("y", "numeric", domain=life.range) + 
    guide_axis("x", title="Fertility Rate") + 
    guide_axis("y", title="Life Expectancy") +
    guide_legend(size = "size", title="Population") +
    guide_legend(fill = "stroke", stroke="stroke", orient="left", title="Region") + 
    guide_legend(stroke = "fill", orient="left", title="", values=c("", ""), 
                 properties=list(
                   legend=props(size=0, stroke="transparent", fill="transparent", 
                                strokeOpacity=0, fillOpacity=0, strokeWidth='0px'), 
                   symbols=props(size=0, stroke="transparent", fill="transparent", 
                                 strokeOpacity=0, fillOpacity=0, strokeWidth='0px'))) +
    opts(width=450, height=400)
  
  scatter$legends[which(sapply(scatter$legends, function(i)  i$title==""))][[1]][["properties"]][["legend"]]$y <- 50
  r_gv <- reactive(scatter)
  observe_ggvis(r_gv, "scatter", session, "svg")
  this.country <- reactive({
    countries[[input$country]]
  })
  this.year.vline <- reactive({
    current.year <- as.character(input$year)
    dat <- years[[current.year]][1:2,]
    dat$life.expectancy <- life.range
    subset(dat, !is.na(life.expectancy) & !is.na(region) & !is.na(year))
  })
  ts <- ggvis(props(x= ~year, y= ~life.expectancy),
              layer_path(props(stroke:="black", opacity := 2/10),
                          data=subset(WorldBank, !is.na(life.expectancy))),
              layer_path(data=this.country, props(stroke=~region, strokeWidth :=2, opacity:=1)),
              layer_path(data=this.year.vline)) + 
    guide_axis("x", title="Year", format="04d") + 
    guide_axis("y", title="Life Expectancy") +
    guide_legend(fill = "stroke", stroke="stroke",orient="left", title="", values=c("", ""), 
                 properties=list(
                   legend=props(size=0, stroke="transparent", fill="transparent", 
                                strokeOpacity=0, fillOpacity=0, strokeWidth='0px'), 
                   symbols=props(size=0, stroke="transparent", fill="transparent", 
                                 strokeOpacity=0, fillOpacity=0, strokeWidth='0px'))) +
    opts(width=425, height=400)
  r_gv2 <- reactive(ts)
  observe_ggvis(r_gv2, "ts", session, "svg")
})

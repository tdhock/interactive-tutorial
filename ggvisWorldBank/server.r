library(shiny)
library(ggvis)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)

shinyServer(function(input, output, session) {

  r_gv <- reactive({
    this.year <- years[[as.character(input$year)]]
    this.country <- subset(this.year, country==input$country)
    ggvis(this.year,
          props(x = ~fertility.rate, y = ~life.expectancy,
                size = ~population),
          mark_symbol(),
          dscale("x", "numeric", domain=fertility.range),
          dscale("y", "numeric", domain=life.range))
  })

  # Set up observers for the spec and the data
  observe_ggvis(r_gv, "ggvis", session, "svg")

  output$ggplot2 <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    this.country <- subset(this.year, country==input$country)
    gg <- ggplot()+
      geom_point(aes(fertility.rate, life.expectancy,
                     colour=region, size=population),
                 data=this.year)+
      geom_text(aes(fertility.rate, life.expectancy, label=country),
                data=this.country)+
      continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,10))
      },breaks=pop.breaks, limits=pop.range)+
      xlim(fertility.range)+ylim(life.range)
    print(gg)
  })

})

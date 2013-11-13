library(shiny)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
## Need to manually specify scale ranges so the axes do not change
## between animation frames.
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)

shinyServer(function(input, output, session) {
  output$ggplot2 <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    this.year$hilite <- ifelse(this.year$country == input$country, "yes", "no")
    this.country <- subset(this.year, country==input$country)
    gg <- ggplot()+
      geom_point(aes(fertility.rate, life.expectancy, 
                     colour=region, size=population,
                     alpha=hilite),
                 data=this.year)+
      scale_alpha_manual(values=c(yes=1,no=1/2), guide=FALSE)+
      geom_text(aes(fertility.rate, life.expectancy, label=country),
                data=this.country)+
      continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,10))
      },breaks=pop.breaks, limits=pop.range)+
      xlim(fertility.range)+ylim(life.range)
    print(gg)
  })
})

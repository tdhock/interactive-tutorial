library(shiny)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)
shinyServer(function(input, output, session) {
  output$scatter <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    this.year$hilite <- ifelse(this.year$country == input$country, "yes", "no")
    this.country <- subset(this.year, country==input$country)
    gg <- ggplot()+
      geom_point(aes(fertility.rate, life.expectancy, 
                     colour=region, size=population,
                     alpha=hilite),
                 data=this.year)+
      scale_alpha_manual(values=c(yes=1,no=1/2), guide=FALSE)+
      continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,10))
      },breaks=pop.breaks, limits=pop.range)+
      xlim(fertility.range)+ylim(life.range)#Manually specify limits!
    if(!is.na(this.country$fert)){
      gg <- gg+
        geom_text(aes(fertility.rate, life.expectancy, label=country),
                  data=this.country)
    }
    print(gg)
  })
  output$ts <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    WorldBank$hilite <- ifelse(WorldBank$country == input$country, "yes", "no")
    gg <- ggplot()+
      geom_vline(aes(xintercept=year), data=this.year[1,])+
      scale_alpha_manual(values=c(yes=1,no=1/10), guide=FALSE)+
      geom_line(aes(year, life.expectancy, group=country, alpha=hilite),
                data=WorldBank)+
      ylim(life.range)
    print(gg)
  })
})

library(animation)
library(grid)
library(ggplot2)
data(WorldBank, package="animint")
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
years <- split(WorldBank, WorldBank$year)
ani.options(ani.width=800,ani.height=800)
saveHTML({
  for(year in names(years)){
    grid.newpage()
    wb <- years[[year]]
    selectedCountry <- "Japan"
    l <- grid.layout(nrow=2)
    pushViewport(viewport(layout=l))
    YearLabel <- CountryLabel <- subset(wb, country == selectedCountry)
    YearLabel$fertility.rate <- 5
    YearLabel$life.expectancy <- 80
    TimeSeries <- ggplot()+
      geom_vline(aes(xintercept=year), data=YearLabel)+
      geom_line(aes(year, life.expectancy, group=country, colour=region,
                    alpha=ifelse(country==selectedCountry, 1, 1/10)),
                data=WorldBank, size=1.5)+
      scale_alpha_identity()
    print(TimeSeries, vp=viewport(layout.pos.col=1,layout.pos.row=1))
    scatter <- ggplot(,aes(fertility.rate, life.expectancy))+
      geom_point(aes(colour=region, size=population), data=wb, alpha=1/2)+
      geom_text(aes(label=sprintf("Year = %d",year)), data=YearLabel)+
      geom_text(aes(label=country), data=CountryLabel)+
      continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,20), c(0,1))
      }, breaks=10^(4:9), limits=range(WorldBank$population, na.rm=TRUE))+
      xlim(fertility.range)+ylim(life.range) #manually specify limits!
    if(any(!is.na(wb$fertility.rate))){
      print(scatter, vp=viewport(layout.pos.col=1,layout.pos.row=2))
    }
  }
})

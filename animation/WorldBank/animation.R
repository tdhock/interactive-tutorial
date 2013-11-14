library(animation)
library(grid)
library(ggplot2)
data(WorldBank, package="animint")
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)
years <- split(WorldBank, WorldBank$year)
ani.options(ani.width=1000)
saveHTML({
  for(year in names(years)){
    grid.newpage()
    wb <- years[[year]]
    selectedCountry <- "Japan"
    l <- grid.layout(ncol=2, widths=c(1, 2))
    pushViewport(viewport(layout=l))
    YearLabel <- CountryLabel <- subset(wb, country == selectedCountry)
    YearLabel$fertility.rate <- 5
    YearLabel$life.expectancy <- 80
    TimeSeries <- ggplot()+
      geom_vline(aes(xintercept=year), data=YearLabel)+
      geom_line(aes(year, life.expectancy, group=country,
                    alpha=ifelse(country==selectedCountry, 1, 1/10)),
                data=WorldBank, size=2)+
      scale_alpha_identity()
    print(TimeSeries, vp=viewport(layout.pos.col=1,layout.pos.row=1))
    scatter <- ggplot(,aes(fertility.rate, life.expectancy))+
      geom_point(aes(colour=region, size=population), data=wb, alpha=1/2)+
      geom_text(aes(label=sprintf("Year = %d",year)), data=YearLabel)+
      geom_text(aes(label=country), data=CountryLabel)+
      continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,10))
      },breaks=pop.breaks, limits=pop.range)+
      xlim(fertility.range)+ylim(life.range) #manually specify limits!
    if(any(!is.na(wb$fertility.rate))){
      print(scatter, vp=viewport(layout.pos.col=2,layout.pos.row=1))
    }
  }
})

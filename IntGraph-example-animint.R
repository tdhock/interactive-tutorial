##```{r animintWorldBankEx, echo=FALSE}
library(animint)
data(WorldBank)
WorldBank$region <- sub(" [(].*", "", WorldBank$region)
years <- data.frame(year=unique(WorldBank$year))
not.na <- subset(WorldBank, !is.na(fertility.rate))
by.country <- split(not.na, not.na$country)
min.years <- do.call(rbind, lapply(by.country, subset, year == min(year)))
min.years$year <- 1959
add.x.var <- function(df, x.var){
  data.frame(df, x.var=factor(x.var, c("life expectancy", "year")))
}
viz.facets <- list(
  duration=list(year=500),
  time=list(variable="year", ms=1000),
  selector.types=list(country="multiple"),
  first=list(country=c(
               "United States", "France", "Japan", "Oman", "Timor-Leste")),
  scatterTS=ggplot()+
    theme_bw()+
    theme(panel.margin=grid::unit(0, "lines"))+
    theme_animint(width=700)+
    scale_size_animint(breaks=10^(10:1))+
    geom_text(aes(x=55, y=9, label=paste("year =", year), showSelected=year),
              data=add.x.var(years, "life expectancy"))+
    geom_point(aes(x=life.expectancy, y=fertility.rate, color=region,
                   size=population,
                   key=country,
                   showSelected=year,
                   clickSelects=country),
               data=add.x.var(WorldBank, "life expectancy"))+
    geom_text(aes(x=life.expectancy, y=fertility.rate, label=country,
                  key=country,
                  clickSelects=country,
                  showSelected=year,
                  showSelected2=country,
                  showSelected3=region),
              data=add.x.var(WorldBank, "life expectancy"))+
    facet_grid(. ~ x.var, scales="free")+
    xlab("")+
    ylab("fertility rate (children per mother)")+
    geom_tallrect(aes(xmin=year-0.5, xmax=year+0.5,
                      clickSelects=year),
                  alpha=0.5,
                  data=add.x.var(years, "year"))+
    geom_text(aes(year, fertility.rate, label=country, clickSelects=country,
                  hjust=1,
                  showSelected=country),
              data=add.x.var(min.years, "year"))+
    geom_line(aes(x=year, y=fertility.rate, group=country, color=region,
                  clickSelects=country),
              size=3,
              alpha=0.6,
              data=add.x.var(WorldBank, "year"))+
    geom_point(aes(x=year, y=fertility.rate, group=country, color=region,
                   size=population,
                   showSelected=country,
                   clickSelects=country),
              alpha=0.6,
              data=add.x.var(not.na, "year")))
structure(viz.facets, class="animint")
##```


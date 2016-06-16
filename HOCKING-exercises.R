library(animint)
data(WorldBank, package="animint")
WorldBank1975 <- subset(WorldBank, year==1975)

## Exercise: try changing the aes mapping of the ggplot, and then
## making a new animint. Quantitative variables like population are
## best shown using the x/y axes or point size. Qualitative variables
## like lending are best shown using point color or fill.
viz.1975 <- list(
  scatter=ggplot()+
  geom_point(
    mapping=aes(
      x=as.numeric(paste(longitude)),
      y=as.numeric(paste(latitude)),
      color=region,
      size=population),
    data=WorldBank1975)+
  scale_size_animint(breaks=10^(9:5)))
structure(viz.1975, class="animint")

## Exercise: use animint to create a data viz with three plots, by
## creating a list with three ggplots. 
WorldBankBefore1975 <- subset(WorldBank, 1970 <= year & year <= 1975)
viz.three.plots <- list(
  scatter=ggplot()+
    geom_point(
      mapping=aes(
        x=life.expectancy,
        y=fertility.rate,
        color=region),
      data=WorldBank1975)+
    geom_path(
      aes(
        x=life.expectancy,
        y=fertility.rate,
        color=region,
        group=country),
      data=WorldBankBefore1975),
  tsFert=ggplot()+
    geom_line(aes(x=year, y=fertility.rate, color=region, group=country),
              data=WorldBank),
  tsLife=ggplot()+
    geom_line(aes(x=year, y=life.expectancy, color=region, group=country),
              data=WorldBank))
structure(viz.three.plots, class="animint")

## Exercise: add another geom. Just add some more geoms with
## aes(showSelected=year) to the data viz.
years <- data.frame(year=unique(WorldBank$year))
tails.list <- list()
WorldBank$other.year <- WorldBank$year
for(year.value in years$year){
  ## For every year, compute the tail (geom_path) which is the data
  ## for the previous 5 years.
  one.tail <- subset(
    WorldBank, year.value-5 <= other.year & other.year <= year.value)
  one.tail$year <- year.value
  tails.list[[paste(year.value)]] <- one.tail
}
tails <- do.call(rbind, tails.list)
viz.scatter <- list(
  scatter=ggplot()+
    geom_path(aes(x=life.expectancy, y=fertility.rate, color=region,
                  group=country,
                  showSelected=year),
              data=tails)+
    geom_point(aes(x=life.expectancy, y=fertility.rate, color=region,
                   showSelected=year),
               data=WorldBank)+
    geom_text(aes(55, 9, label=paste("year =", year),
                  showSelected=year),
              data=years))
structure(viz.scatter, class="animint")

## Exercise: add another plot. Just add another ggplot to the viz list.
viz.scatter.ts <- viz.scatter
viz.scatter.ts$tsFert <- ggplot()+
  geom_line(aes(x=year, y=fertility.rate, color=region, group=country),
            data=WorldBank)+
  geom_vline(aes(xintercept=year, showSelected=year), data=years)
structure(viz.scatter.ts, class="animint")

## Exercise: make an animated data viz that does NOT use smooth
## transitions. Just add the "time" option to the viz list.
viz.anim.only <- viz.scatter.ts
viz.anim.only$time <- list(variable="year", ms=1000)
structure(viz.anim.only, class="animint")

## Exercise: how to get the geom_text to disappear along with the
## point when the region legend is clicked? Add
## aes(showSelected=region).
viz.click <- list(
  scatter=ggplot()+
    geom_point(aes(x=life.expectancy, y=fertility.rate, color=region,
                   key=country,
                   showSelected=year,
                   clickSelects=country),
               data=WorldBank)+
    geom_text(aes(x=life.expectancy, y=fertility.rate, label=country,
                  key=country,
                  showSelected=year,
                  showSelected2=country,
                  showSelected3=region), #added!
              data=WorldBank),
  duration=list(year=2000))
structure(viz.click, class="animint")

## Exercise: how to get the geom_text to disappear when you click it?
## Add aes(clickSelects=country).
viz.multiple <- list(
  scatter=ggplot()+
    geom_point(aes(x=life.expectancy, y=fertility.rate, color=region,
                   key=country,
                   showSelected=year,
                   clickSelects=country),
               data=WorldBank)+
    geom_text(aes(x=life.expectancy, y=fertility.rate, label=country,
                  key=country,
                  clickSelects=country, #added!
                  showSelected=year,
                  showSelected2=country,
                  showSelected3=region), 
              data=WorldBank),
  first=list(
    year=1970,
    country="United States",
    region=c("North America", "South Asia")),
  selector.types=list(country="multiple"),
  duration=list(year=2000))
structure(viz.multiple, class="animint")

## Exercise: add animation and layers.
viz.timeSeries <- viz.multiple
viz.timeSeries$timeSeries <- ggplot()+
  geom_tallrect(aes(xmin=year-0.5, xmax=year+0.5,
                    clickSelects=year),
                alpha=0.5,
                data=years)+
  geom_line(aes(x=year, y=fertility.rate, group=country, color=region,
                clickSelects=country),
            size=3,
            alpha=0.6,
            data=WorldBank)
viz.timeSeries$time <- list(variable="year", ms=1000)
viz.timeSeries$scatter <- viz.multiple$scatter+
    geom_path(aes(x=life.expectancy, y=fertility.rate, color=region,
                  group=country,
                  key=country,
                  clickSelects=country,
                  showSelected=year),
              size=3,
              data=tails)+
    geom_text(aes(55, 9, label=paste("year =", year),
                  showSelected=year),
              data=years)
structure(viz.timeSeries, class="animint")

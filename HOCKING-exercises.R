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

## Exercise: add another geom.
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

## Exercise: add another plot.
viz.scatter.ts <- viz.scatter
viz.scatter.ts$tsFert <- ggplot()+
  geom_line(aes(x=year, y=fertility.rate, color=region, group=country),
            data=WorldBank)+
  geom_vline(aes(xintercept=year, showSelected=year), data=years)
structure(viz.scatter.ts, class="animint")

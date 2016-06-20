library(animint)
data(WorldBank, package="animint")
WorldBank1975 <- subset(WorldBank, year==1975)

## Exercise: try changing the aes mapping of the ggplot, and then
## making a new animint. Quantitative variables like population are
## best shown using the x/y axes or point size. Qualitative variables
## like lending are best shown using point color or fill.
scatter.viz <- list(
  scatter=ggplot()+
  geom_point(
    mapping=aes(
      x=as.numeric(paste(longitude)),
      y=as.numeric(paste(latitude)),
      color=region,
      size=population),
    data=WorldBank1975)+
  scale_size_animint(breaks=10^(9:5)))
structure(scatter.viz, class="animint")

## Exercise: use animint to create a data viz with three plots, by
## creating a list with three ggplots. 
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

## Exercise: add another plot.

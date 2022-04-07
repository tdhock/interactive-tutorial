library(animint2)
data(WorldBank, package="animint2")
years <- unique(WorldBank[, "year", drop=FALSE])
y1960 <- subset(WorldBank, year==1960)
viz <- animint(
  title="Linked scatterplot and time series", #web page title.
  time=list(variable="year",ms=3000), #variable and time delay used for animation.
  duration=list(year=1000), #smooth transition duration in milliseconds.
  selector.types=list(country="multiple"), #single/multiple selection for each variable.
  first=list( #selected values to show when viz is first rendered.
    country=c("Canada", "Japan"),
    year=1970),
  ## ggplots are rendered together for an interactive data viz.
  ts=ggplot()+
    theme_animint(width=500)+
    make_tallrect(WorldBank, "year")+
    geom_text(aes(
      year, life.expectancy, label=country),
      showSelected="country",
      clickSelects="country",
      hjust=1,
      data=y1960)+
    scale_x_continuous(limits=c(1950, NA))+
    geom_line(aes(
      year, life.expectancy, group=country, color=region),
      clickSelects="country",
      data=WorldBank,
      size=4,
      alpha=0.55),
  scatter=ggplot()+
    geom_point(aes(
      fertility.rate, life.expectancy,
      key=country, colour=region, size=population),
      showSelected="year",
      clickSelects="country",
      data=WorldBank)+
    geom_text(aes(
      fertility.rate, life.expectancy,
      key=country,
      label=country),
      showSelected=c("country", "year"),
      data=WorldBank)+
    geom_text(aes(
      5, 80, key=1, label=paste("year =", year)),
      showSelected="year",
      data=years)+
    scale_size_animint(pixel.range=c(2,20), breaks=10^(4:9)))

WorldBank1975 <- subset(WorldBank, year==1975)
WorldBankBefore1975 <- subset(WorldBank, 1970 <= year & year <= 1975)
two.layers <- ggplot()+
  geom_point(
    mapping=aes(x=life.expectancy, y=fertility.rate, color=region),
    data=WorldBank1975)+
  geom_path(aes(
    x=life.expectancy, y=fertility.rate, color=region,
    group=country),
    data=WorldBankBefore1975)
(viz.two.layers <- animint(two.layers))


timeSeries <- ggplot()+
  geom_line(aes(
    x=year, y=fertility.rate,
    color=region, group=country),
    data=WorldBank)

animint(two.layers, timeSeries)

animint(ggplot()+
  facet_grid(. ~ panel, scales="free")+
  geom_point(
    mapping=aes(x=life.expectancy, y=fertility.rate, color=region),
    data=data.frame(panel="life expectancy", WorldBank1975))+
  geom_path(aes(
    x=life.expectancy, y=fertility.rate, color=region,
    group=country),
    data=data.frame(panel="life expectancy", WorldBankBefore1975))+
  geom_line(aes(
    x=year, y=fertility.rate,
    color=region, group=country),
    data=data.frame(panel="year", WorldBank)))

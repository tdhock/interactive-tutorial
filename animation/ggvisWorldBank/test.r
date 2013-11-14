library(ggvis)
data(WorldBank, package="animint")
years <- split(WorldBank, WorldBank$year)
fertility.range <- range(WorldBank$fertility.rate, na.rm=TRUE)
life.range <- range(WorldBank$life.expectancy, na.rm=TRUE)
pop.breaks <- seq(5e8, 1e9, by=1e8)
pop.range <- range(WorldBank$population, na.rm=TRUE)
regions <- levels(WorldBank$region)
current.year <- 5

dat <- years[[current.year]]
ddat <- reactive({
  invalidateLater(2000, NULL)
  current.year <<- current.year + 1
  dat <<- years[[current.year]]
  dat
})
ggvis(ddat,
      props(x = ~fertility.rate, y = ~life.expectancy,
            size = ~population),
      mark_symbol(),
      dscale("x", "numeric", domain=fertility.range),
      dscale("y", "numeric", domain=life.range))

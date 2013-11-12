data(WorldBank, package="animint")

shinyServer(function(input, output, session) {

  # A subset of mtcars
  r_gv <- reactive({
    ggvis(subset(WorldBank,year == input$year),
          props(x = ~fertility.rate, y = ~life.expectancy,
                size = ~population),
          mark_symbol())
  })

  # Set up observers for the spec and the data
  observe_ggvis(r_gv, "ggvis", session, "svg")

  output$ggplot2 <- renderPlot({
    gg <- ggplot(subset(WorldBank, year==input$year))+
      geom_point(aes(fertility.rate, life.expectancy, clickSelects=country,
                     showSelected=year, colour=region, size=population))
    print(gg)
  })

})

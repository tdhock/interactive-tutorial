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
  observe_ggvis(r_gv, "plot1", session, "svg")

  # User interface elements (in the sidebar)
  output$ggvis_ui <- renderControls(r_gv, session)

  ## output$mtc_table <- renderTable({
  ##   mtc()[, c("wt", "mpg")]
  ## })
})

library(shiny)

ui <- fluidPage(
    titlePanel("My title"),
    sidebarLayout(
        sidebarPanel(
            selectInput("xvar", label = h3("Select x"),
                        choices = list("A"=1, "B"=2, "C"=3),
                        selected = 1)),
        mainPanel(
 #           textOutput("text"),
            plotOutput("plot", height="600")
            ))
    )


server <- function(input, output) {
    output$plot <- renderPlot({
        mytext <- input$xvar

        par(mar=c(4,4,0,0)+.1, cex=1.4)
        hist(rnorm(1000))
    })
#    output$text <- renderText( { paste0("Hello ", mytext) } )
}

shinyServer(server)

shinyApp(ui = ui, server = server)

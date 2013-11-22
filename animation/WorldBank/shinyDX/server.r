library(shiny)
years <- split(WorldBank, WorldBank$year)
ranges <- list()
breaks <- list()
for(col.name in names(WorldBank)){
  vec <- WorldBank[[col.name]]
  if(is.numeric(vec)){
    ranges[[col.name]] <- rr <- range(vec, na.rm=TRUE)
    r <- round(rr)
    breaks[[col.name]] <- seq(r[1], r[2], l=5)
  }
}
shinyServer(function(input, output, session) {
  ggupdate <- function(gg, aes.var, input.var=aes.var){
    var.name <- input[[input.var]]
    var.range <- ranges[[var.name]]
    if(!is.null(var.range)){#Manually specify limits!
      limfun <- get(sprintf("%slim",aes.var))
      gg <- gg+limfun(var.range)
    }
    gg
  }    
  output$scatter <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    this.year$hilite <- ifelse(this.year$country == input$country, "yes", "no")
    this.country <- subset(this.year, country==input$country)
    a <- aes_string(x=input$x, y=input$y, size=input$size, color=input$color,
                    alpha="hilite")
    gg <- ggplot()+
      geom_point(a, data=this.year)+
      scale_alpha_manual(values=c(yes=1,no=1/2), guide=FALSE)
    size.range <- ranges[[input$size]]
    if(!is.null(size.range)){
      gg <- gg+continuous_scale("size","area",palette=function(x){
        scales:::rescale(sqrt(abs(x)), c(2,10), c(0,1))
      },breaks=breaks[[input$size]], limits=size.range)
    }
    for(xy in c("x", "y")){
      gg <- ggupdate(gg, xy)
    }
    ok <- !is.na(this.country[,c(input$x, input$y)])
    if(all(ok)){
      a <- aes_string(x=input$x, y=input$y, label=input$label)
      gg <- gg+geom_text(a, data=this.country)
    }
    print(gg)
  })
  output$ts <- renderPlot({
    this.year <- years[[as.character(input$year)]]
    WorldBank$hilite <- ifelse(WorldBank$country == input$country, "yes", "no")
    a <- aes_string(x="year", y=input$tsy, color=input$color,
                    group="country", alpha="hilite")
    gg <- ggplot()+
      geom_vline(aes(xintercept=year), data=this.year[1,])+
      scale_alpha_manual(values=c(yes=1,no=1/10), guide=FALSE)+
      geom_line(a, data=WorldBank)
    gg <- ggupdate(gg, "y", "tsy")
    print(gg)
  })
})

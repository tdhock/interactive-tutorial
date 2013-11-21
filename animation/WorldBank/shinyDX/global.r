data(WorldBank, package="animint")
WorldBank <- data.frame(WorldBank)#so all colnames start with a letter.
for(num.var in c("longitude", "latitude")){
  WorldBank[[num.var]] <- as.numeric(as.character(WorldBank[[num.var]]))
}

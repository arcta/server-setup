
library(shiny)

shinyUI(fluidPage(

  tags$head(
    tags$style(HTML("
      @import url(//fonts.googleapis.com/css?family=Orbitron);

      h1, h2, h3 {
        font-family: Orbitron, sans-seif;
        color: #abc;
      }

    "))
  ),

  titlePanel("Rstudio:"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    mainPanel(
      plotOutput("distPlot")
    )
  )
))

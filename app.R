#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(ggplot2)
data(mtcars)

ui <- fluidPage(titlePanel("Simple Linear Regression"),
                
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "DepVar",
                      label = "Dependent Variables",
                      multiple = FALSE,
                      choices = list(
                        "mpg",
                        "cyl",
                        "disp",
                        "hp",
                        "drat",
                        "wt" ,
                        "qsec" ,
                        "vs" ,
                        "am" ,
                        "gear",
                        "carb"
                      )
                    ),
                    selectInput(
                      inputId = "IndVar",
                      label = "Independent Variables",
                      multiple = FALSE,
                      choices = list(
                        "mpg",
                        "cyl",
                        "disp",
                        "hp",
                        "drat",
                        "wt" ,
                        "qsec" ,
                        "vs" ,
                        "am" ,
                        "gear",
                        "carb"
                      )
                    )
                  ),
                  
                  mainPanel(
                    verbatimTextOutput(outputId = "RegSum"),
                    verbatimTextOutput(outputId = "IndPrint"),
                    verbatimTextOutput(outputId = "DepPrint"),
                    plotOutput(outputId = "distPlot")
                  )
                ))










server <- function(input, output) {
  lm1 <-
    reactive({
      lm(reformulate(input$IndVar, input$DepVar), data = mtcars)
    })
  
  output$DepPrint <- renderPrint({
    input$DepVar
  })
  output$IndPrint <- renderPrint({
    input$IndVar
  })
  output$RegSum <- renderPrint({
    summary(lm1())
  })
  
  
  
  output$distPlot <- renderPlot({
    if (typeof(mpg[[input$IndVar]]) == "character" | typeof(mpg[[input$DepVar]]) == "character")      #mpg[[input$var1]]
    {
      print("Error")
    }
    else
    {
      ggplot(geom_point(mtcars, input$IndVar, input$DepVar)) +
        xlab(input$IndVar) +
        ylab(input$DepVar) +
        ggtitle(paste("Plot", input$IndVar, "vs", input$DepVar))
    }
   
    
    
  })
}
shinyApp(ui = ui, server = server)
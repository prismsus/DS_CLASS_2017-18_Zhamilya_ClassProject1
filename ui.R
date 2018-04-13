library(shiny)
library(plotly)
library(DT)
library(markdown)

shinyUI(navbarPage(
  "RNA editing  exploration",
  
  tabPanel(
    "Introduction",
    titlePanel("The distribution of one type of amino acid changes in cephalopod species and humans"),
    includeMarkdown("classproject_into.Rmd")
  ),
  
  
  tabPanel(
    "Description of the data",
    #  includeMarkdown("TitlePage.Rmd"),
    includeMarkdown("classproject_Data.Rmd"),
    img(src = 'gene.png', align = "left", width = "60%")
  ),
  
  
  
  tabPanel(
    "Plots",
   # includeText("text1"),
    plotlyOutput("plot_data_3"),
   # includeText("text2"),
    plotlyOutput("plot_data_2"),
  #  includeText("text3"),
    plotlyOutput("plot_data_1"),
    
    includeMarkdown("classproject_Exploration.Rmd")
    
  ),
  
  tabPanel(
    "Data Table",
    DT::dataTableOutput("table"),
    #    textOutput("text"),
    DT::dataTableOutput("table1")
  )
  
 
))
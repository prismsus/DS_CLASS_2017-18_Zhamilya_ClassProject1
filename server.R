library(shiny)
library(ggplot2)
library(readxl)
library(readr)
library(dplyr)
library(plotly)
library(DT)



shinyServer(function(input, output) {
 
  # Filter data based on selections
  
  ds_r <- reactive({
    
    withProgress(message = "reading gene data", {
      oct_bim <-
        read_csv("Data/oct_bim.csv",
                 col_names = c("gene name", "distance", "diff_in_editing_level"))
      oct_vul <-
        read_csv("Data/oct_vul.csv",
                 col_names = c("gene name", "distance", "diff_in_editing_level"))
      sepia <-
        read_csv("Data/sepia.csv",
                 col_names = c("gene name", "distance", "diff_in_editing_level"))
      squid <-
        read_csv("Data/squid.csv",
                 col_names = c("gene name", "distance", "diff_in_editing_level"))
      
      oct_bim <-
        mutate(oct_bim, species = 'oct_bim', ID = rownames(oct_bim))
      oct_vul <-
        mutate(oct_vul, species = 'oct_vul', ID = rownames(oct_vul))
      sepia <- mutate(sepia, species = 'sepia', ID = rownames(sepia))
      squid <- mutate(squid, species = 'squid', ID = rownames(squid))
      ds <- rbind(oct_bim, oct_vul, sepia, squid)
      
    })
    ds
  })
  
  
  df_r <- reactive({
    
    withProgress(message = "reading amino acid data", {
      file_names <-
        excel_sheets("Data/editing%20codon%20simplified-2.xlsx")
    })
    df_list <- list()
    #browser()
    for (i in 1:length(file_names)) {
      df_temp <- read_excel("Data/editingcodonsimplified.xlsx",
                            sheet = file_names[i])
      df_temp <- df_temp %>%
        
        mutate(sp_name = file_names[i])
      
      df_list[[i]] <- df_temp
    }
    
    df <- bind_rows(df_list)
    df <-
      df %>% mutate(Type = ifelse(
        Change %in% c("NS", "HR", "IV", "MV", "TA", "IM", "SG", "KR", "syn"),
        "CONSERVED",
        "RADICAL"
      ))
    df
  })
  
  
  
  output$table <- DT::renderDataTable({
    #browser()
    data <- df_r()
    data 
  }, options = list(scrollX = TRUE))
  
  
  output$table1 <-
    DT::renderDataTable({
      ds_r() %>% dplyr::sample_n(1000, replace = F) 
    }, options = list(scrollX = TRUE))
  
  output$plot_data_1 <- renderPlotly({
    ggplot(data = df_r()) +
      geom_point(mapping = aes(x = Expected_frequency, y = frequency, color = Change)) +
      facet_grid( ~ sp_name) +
      xlim(0, 0.125)
    ggplotly()
    
  })
  
 # output$text1 <- renderText("The comparison of amount of changes in humans and cephalopod species")
  #output$text2 <- renderText("The comparison of frequencies of changes in humans and cephalopod species")
  #output$text3 <- renderText("Frequencies in different species")
  
  output$plot_data_2 <- renderPlotly({
    ggplot(data = df_r()) +
      geom_point(mapping = aes(x = frequency, y = Change, color = sp_name))
    ggplotly()
  })
  output$plot_data_3 <- renderPlotly({
    ggplot(data = df_r()) +
      geom_point(mapping = aes(x = edits, y = Change, color = sp_name))
    ggplotly()
  })
})

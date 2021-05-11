## app.R ##
library(shinydashboard)
options(digits=3)
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(gtsummary)
library(apastats)
library(hrbrthemes)
dataset <- read_rds(here::here("data", "final_data.rds"))

ggplot2::theme_set(hrbrthemes::theme_ipsum_rc())

varnames <- c("age", "gender", "education")
varnames2 <- c("nationality", "awareness", "facebook")
names(dataset)

ui <- dashboardPage(
    dashboardHeader(title = "Data Explorer"),
    dashboardSidebar(),
    dashboardBody(
        # Boxes need to be put in a row (or column)
        fluidRow(
            box(width = 12, 
                gt::gt_output("table")),
            box(width = 12, 
                plotOutput("plot")),
            box(width = 12,
                withMathJax(uiOutput("statistics"))),
            box(
                title = "Controls",
                selectInput("mainvar", "Main variable", choices = varnames, selected = varnames[1]),
                selectInput("secondvar", "Second Varialbe", choices = varnames2, selected = varnames2[1])
            )
        )
    )
)

server <- function(input, output) {
    

    selected_data <- reactive({
        dataset %>% select(input$mainvar, input$secondvar)
    })
    
    
  output$table <- gt::render_gt({
      selected_data() %>% gtsummary::tbl_summary(by = input$secondvar) %>% as_gt()
  })
  
  
  output$plot <- renderPlot({
      selected_data() %>% 
          ggplot() +
          aes_string(x = input$mainvar, fill = input$secondvar) +
          geom_bar(position = "dodge", colour = "black") +
          scale_fill_brewer()
  }) 
  
  output$statistics <- renderText({
      tst <- selected_data() %>% table() %>% chisq.test()
      HTML(apastats::describe.chi(tst$observed))
  })
  
  
}

shinyApp(ui, server)
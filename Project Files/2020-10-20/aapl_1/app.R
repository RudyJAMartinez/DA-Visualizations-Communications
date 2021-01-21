library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)

aapl <- readRDS(here::here("Data", "aapl.rds"))

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(),
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Sales", plotOutput("p1")),
                        tabPanel("Cash", plotOutput("p2")))
        )
    )
)

server <- function(input, output){
    output$p1 <- renderPlot({
        ggplot(aapl, aes(datadate, SALEQ)) +
            geom_line() +
            labs(x = "Quarter", y = "Sales in million USD") +
            theme_minimal() +
            scale_y_continuous(labels = scales::comma)
    })
        
    output$p2 <- renderPlot({
            ggplot(aapl, aes(datadate, CHEQ)) +
                geom_line() +
                labs(x = "Quarter", y = "Cash in million USD") +
                theme_minimal() +
                scale_y_continuous(labels = scales::comma)
            
    }) 
}


shinyApp(ui = ui, server = server)

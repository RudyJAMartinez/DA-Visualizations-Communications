library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)

aapl <- readRDS(here::here("Data", "aapl.rds"))

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput("finvar",
                        "Select the financial variable",
                        choices = c("Sales", "Cash"))
        ),
        mainPanel(plotOutput("plot"))
    )
)

server <- function(input, output){
    
    output$plot <- renderPlot({
        if (input$finvar == "Sales") {
            ggplot(aapl, aes(datadate, SALEQ)) +
                geom_line() +
                labs(x = "Quarter", y = "Sales in million USD") +
                theme_minimal() +
                scale_y_continuous(labels = scales::comma)
        } else {
            ggplot(aapl, aes(datadate, CHEQ)) +
                geom_line() +
                labs(x = "Quarter", y = "Cash in million USD") +
                theme_minimal() +
                scale_y_continuous(labels = scales::comma)
        }
    })
}


shinyApp(ui = ui, server = server)

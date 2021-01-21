library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)

aapl <- readRDS(here::here("Data", "aapl.rds"))


ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            width = 3,
            selectInput("finvar",
                        "Select the financial variable",
                        choices = c("Sales", 
                                    "Cash",
                                    "Operating Profit",
                                    "Total Assets",
                                    "Cost of Goods Sold"))
        ),
        mainPanel(plotOutput("plot"))
    )
)

server <- function(input, output){
    
    output$plot <- renderPlot({
        
        yvar <- switch(input$finvar,
                       "Sales" = "SALEQ",
                        "Cash" = "CHEQ",
                        "Operating Profit" = "OIADPQ",
                        "Total Assets" = "ATQ",
                        "Cost of Goods Sold" = "COGSQ")
        
        ytitle <- switch(input$finvar,
                         "Sales" = "Sales in mil USD",
                         "Cash" = "Cash in mil USD",
                         "Operating Profit" = "Profits in mil USD",
                         "Total Assets" = "Assets in mil USD",
                         "Cost of Goods Sold" = "Cost in mil USD")
        
            ggplot(aapl, aes_string("datadate", yvar)) +
                geom_line() +
                labs(x = "Quarter", y = ytitle) +
                theme_minimal() +
                scale_y_continuous(labels = scales::comma)
    })
}


shinyApp(ui = ui, server = server)

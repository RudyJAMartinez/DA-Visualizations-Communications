library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(haven)

ui <- fluidPage(

    # Application title
    titlePanel("Apple Financials"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            width = 3,
            fileInput("dt", "Upload SAS Data:"),
            selectInput("x_finvar",
                        "X-Axis Variable:",
                        choices = c("Sales", 
                                    "Cash",
                                    "Assets",
                                    "Profits",
                                    "R&D",
                                    "SG&A"),
                        selected = "Sales"),
            selectInput("y_finvar",
                        "Y-Axis Variable:",
                        choices = c("Sales", 
                                    "Cash",
                                    "Assets",
                                    "Profits",
                                    "R&D",
                                    "SG&A"),
                        selected = "R&D"),
            selectInput("scale",
                        "Choose the Scale:",
                        choices = c("Levels",
                                    "Log 10"),
                        selected = "Levels"),
            radioButtons("model",
                         "Choose the Model:",
                         choices = c("Linear Model" = "lm",
                                     "LOESS" = "loess",
                                     "None" = "none"),
                         selected = "loess"),
            checkboxInput("ribbon",
                          "Standard Error Ribbon",
                          value = TRUE)
        ),
        mainPanel(plotOutput("plot"))
    )
)

# Define server logic 
server = function(input, output){

    output$plot = renderPlot({
        
        validate(
            need(input$dt != "", "Please upload a SAS data file (sas7bdat extension).
Make sure that it has the following variables:
SALEQ, CHEQ, ATQ, OIADPQ, XRDQ, XSGAQ")
        )
        
        aapl = read_sas(input$dt$datapath)
        
        xvar = switch(input$x_finvar,
                      "Sales" = "SALEQ",
                      "Cash" = "CHEQ",
                      "Assets" = "ATQ",
                      "Profits" = "OIADPQ",
                      "R&D" = "XRDQ",
                      "SG&A" = "XSGAQ")
        
        xtitle = switch(input$x_finvar,
                        "Sales" = "Sales (million $)",
                        "Cash" = "Cash (million $)",
                        "Assets" = "Assets (million $)",
                        "Profits" = "Profits (million $)",
                        "R&D" = "R&D (million $)",
                        "SG&A" = "SG&A (million $)")                        
        
        yvar = switch(input$y_finvar,
                      "Sales" = "SALEQ",
                      "Cash" = "CHEQ",
                      "Assets" = "ATQ",
                      "Profits" = "OIADPQ",
                      "R&D" = "XRDQ",
                      "SG&A" = "XSGAQ")
        
        ytitle = switch(input$y_finvar,
                        "Sales" = "Sales (million $)",
                        "Cash" = "Cash (million $)",
                        "Assets" = "Assets (million $)",
                        "Profits" = "Profits (million $)",
                        "R&D" = "R&D (million $)",
                        "SG&A" = "SG&A (million $)")
        
        if(input$scale == "Levels") {
            ggplot(aapl, aes_string(xvar, yvar)) +
                geom_point() +
                geom_smooth(method = input$model, color = "white", alpha = 0.5, se = input$ribbon) +
                labs(x = xtitle , y = ytitle) +
                scale_x_continuous() +
                scale_y_continuous() +
                ggthemes::theme_economist_white() +
                theme(legend.position = "none")}
        
        else if(input$scale == "Log 10") {
            ggplot(aapl, aes_string(xvar, yvar)) +
                geom_point() +
                geom_smooth(method = input$model, color = "white", alpha = 0.5, se = input$ribbon) +
                labs(x = xtitle , y = ytitle) +
                scale_x_log10() +
                scale_y_log10() +
                ggthemes::theme_economist_white() +
                theme(legend.position = "none")}
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

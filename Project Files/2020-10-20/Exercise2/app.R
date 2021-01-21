
library(shiny)
library(ggplot2)


ui <- fluidPage(
    #shinythemes::themeSelector(),
    sidebarLayout(
        sidebarPanel(
            sliderInput("n_obs", "Number of Observations",
                        min = 10, max = 500, step = 10, value = 100),
            numericInput("n_bins", "Number of Bins",
                         min = 10, max = 60, step = 1,
                         value = 20)
        ),
        mainPanel(
            plotOutput("hist")
        )
    )
)

server <- function(input, output){
    
    output$hist <- renderPlot({
        d1 <- data.frame(x = rnorm(input$n_obs))
        ggplot(d1, aes(x = x)) +
            geom_histogram(bins = input$n_bins, color = "white") +
            theme_minimal()
    })
        
}

# Run the application 
shinyApp(ui = ui, server = server)

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)


ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "state",
                        label = "Select a State",
                        choices = list(
                            `East Coast` = c("NY", "NJ", "CT"),
                            `West Coast` = c("WA", "OR", "CA"),
                            Midwest = c("MN", "WI", "IA")
                        ))
        ),
        mainPanel(
            textOutput("text1")
        )
    )
)


server <- function(input, output){
    
    output$text1 <- renderText(
        paste("Your selected state is", input$state)
    )
}

shiny::shinyApp(ui = ui, server = server)













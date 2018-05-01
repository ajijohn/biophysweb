#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RColorBrewer)
library(dplyr)

od<- read.csv(file = "../data/jan1981To.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {


  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, od$To_Lizard)
  })


  filtered <- reactive({
    od %>% filter(hr==12)
  })

  output$map <- renderLeaflet({

    leaflet(filtered()) %>%
      addProviderTiles(providers$Stamen.Terrain)  %>%
      addHeatmap(lng = ~lon, lat = ~lat, intensity = ~To_Lizard,
                 blur = 20, max = 0.05, radius = 15)
  })


  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("map", data = filtered())


  })

})

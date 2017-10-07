require(shiny)
require(leaflet)
library(RColorBrewer)
library(leaflet.extras)
library(magrittr)
library(dplyr)

od<- read.csv("./data/jan1981To.csv")

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("myMap", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("month", "Month", 1, 1,
                            value = range(1)),
                sliderInput("day", "Day", 1, 31,
                            value = c(1,31)),
                sliderInput("hour", "Hour", 1, 24,
                            value = c(1,24)),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE)
  ),

  absolutePanel(
    bottom = 10,
    left = 10,
    HTML('<a href="https://trenchproject.github.io" target="_new"><span style="color:#CC0000">The TrEnCh Project</span>
         <span style="color:#009933">by Huckley Lab</span></a>
         </span></span>')
    )
)



server <- function(input, output, session) {

  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, od$To_Lizard)
  })


  filtered <- reactive({
   od %>% filter(day == input$day,month==input$month,hr==input$hour)
  })



  output$myMap <- renderLeaflet({

    leaflet(filtered()) %>%
        addProviderTiles(providers$Stamen.Terrain)  %>%
      addHeatmap(lng = ~lon, lat = ~lat, intensity = ~To_Lizard,
                 blur = 20, max = 0.05, radius = 15)
  })


  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("myMap", data = filtered())

    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
      pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                          pal = pal, values = ~To_Lizard
      )
    }
  })

}

shinyApp(ui = ui, server = server)

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
library(leaflet.extras)

od<- NULL
outline <- NULL



compute_data <- function(updateProgress = NULL) {
  # Create 0-row data frame which will be used to store data
  # If we were passed a progress update function, call it
  if (is.function(updateProgress)) {

    updateProgress(detail = text)
  }

}



# Define server logic required to draw a histogram
shinyServer(function(input, output) {



  # Create a Progress object
  progress <- shiny::Progress$new()
  progress$set(message = "Loading data", value = 0)
  # Close the progress when this reactive exits (even if there's an error)
  on.exit(progress$close())

  # Create a callback function to update progress.
  # Each time this is called:
  # - If `value` is NULL, it will move the progress bar 1/5 of the remaining
  #   distance. If non-NULL, it will set the progress to that value.
  # - It also accepts optional detail text.
  updateProgress <- function(value = NULL, detail = NULL) {
    if (is.null(value)) {
      value <- progress$getValue()
      value <- value + (progress$getMax() - value) / 5
    }
    progress$set(value = value, detail = detail)
  }

  od <- read.csv(file = "../data/jan1981To.csv")
  specieas <- read.csv('../data/occurence.csv')

  outline <- specieas[chull(specieas$longitude, specieas$latitude),]

  # Compute the new data, and pass in the updateProgress function so
  # that it can update the progress indicator.
  compute_data(updateProgress)

  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, od$To_Lizard)
  })


  filtered <- reactive({
    od %>% filter(hr==12)
  })

  # Set value for the minZoom and maxZoom settings.
  ##leaflet()

  output$map <- renderLeaflet({

    leaflet(filtered(),options = leafletOptions(zoom=0.1)) %>%
      #addProviderTiles(providers$Stamen.Terrain)  %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addDrawToolbar(targetGroup = "controls",
                     rectangleOptions = T,
                     polylineOptions = T,
                     markerOptions = T,
                     editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()),
                     circleOptions = drawCircleOptions(shapeOptions = drawShapeOptions(clickable = T))) %>%

      # Layers control
      addLayersControl(
        overlayGroups = c("Body Temperature", "Thermal Stress", "Distribution"),
        options = layersControlOptions(collapsed = FALSE,position='bottomleft')
      )   %>%
      addHeatmap(lng = ~lon, lat = ~lat, intensity = ~To_Lizard, group = "Body Temperature",
                 blur = 20,  radius = 15) %>%
      addPolygons(data = outline, lng = ~longitude, lat = ~latitude,
                  fill = '#FFFFCC', weight = 2, color = "#FFFFCC", group = "Distribution") %>%
      setView(lat = 39.76, lng = -105, zoom = 5)
  })

  # Return the UI for a modal dialog with data selection input. If 'failed' is
  # TRUE, then display a message that the previous value was invalid.
  dataModal <- function(failed = FALSE) {
    modalDialog(title = "Download",fade = TRUE,
      dateRangeInput("daterangeexport", "Date range:"),
      sliderInput("exporthour", "Hour", min = 0, max = 24, value = 0),
      selectInput("aggm", label = "Aggregation",
                  choices = list("Min" = 1, "Max" = 2, "Mean" = 3),
                  selected = 1),
      if (failed)
        div(tags$b("Invalid date range", style = "color: red;")),

      footer = tagList(
        modalButton("Cancel"),
        # Download Button
        downloadButton("downloadData", "Download")
      )
    )
  }

  # When download button is pressed, attempt to load the data set. If successful,
  # remove the modal. If not show another modal, but this time with a failure
  # message.
  observeEvent(input$ok, {
    # Check that email id is valid.
    if (!is.null(input$daterangeexport)) {

      removeModal()
    } else {
      showModal(dataModal(failed = TRUE))
    }
  })


  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$organism, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(od, file, row.names = FALSE)
    }
  )

  observeEvent(input$goDownload, {
    showNotification("Download invoked.")
  })

  # Display information about selected data
  output$dataInfo <- renderPrint({

  })

  # Use a separate observer to recreate the legend as needed.
  observe({
    proxy <- leafletProxy("map", data = filtered())


  })

  # Feature when added.
  observeEvent(input$map_draw_new_feature, {
    print(input$map_draw_new_feature)
    #Populate bounding box ??
  })

  observeEvent(input$goDownload, {
    showModal(dataModal())
  })

  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
    proxy <- leafletProxy("map")
    print("shape clicked")
  })





})

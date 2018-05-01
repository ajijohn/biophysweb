library(leaflet)

# Choices for drop-downs
vars <- c(
  "Generic" = "generic",
  "Lizard" = "lizard",
  "Butterfly" = "butterfly",
  "Grasshopper" = "grasshopper"
)


navbarPage("BioPhyz", id="nav",

           tabPanel("Visualize Stress",
                    div(class="outer",

                        tags$head(
                          # Include our custom CSS
                          includeCSS("../styles.css"),
                          includeScript("../gomap.js")
                        ),

                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),

                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",

                                      h2("Filter"),

                                      selectInput("organism", "Organism", vars),
                                      numericInput("height", "Height(cm)", 5),
                                      radioButtons("suns", "Shading:",
                                                   c("Sun" = "sun",
                                                     "Shade" = "shade")),

                                      conditionalPanel("input.organism == 'lizard'",
                                                       # Only prompt for svl when chosen Lizard
                                                       numericInput("svl", "Snout Vent Length(cm)", 5)
                                      ),
                                      conditionalPanel("input.organism == 'generic'",
                                                       # Prompt diameter and length
                                                       numericInput("diameter", "Diameter(cm)", 5),
                                                       numericInput("length", "Length(cm)", 5)

                                      )

                                      #plotOutput("histCentile", height = 200),
                                      #plotOutput("scatterCollegeIncome", height = 250)
                        ),

                        tags$div(id="cite",
                                 'Huckley Lab ', tags$em('The TrEnCh Project'), ' by Aji John'
                        )
                    )
           ),

           conditionalPanel("false", icon("crosshair"))
)

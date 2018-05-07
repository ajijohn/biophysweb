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
                                      radioButtons("suns", "Shading:",inline = TRUE,
                                                   c("Sun" = "sun",
                                                     "Shade" = "shade")),
                                      numericInput("sac", "% SA in contact with ground", 5),
                                      HTML("<div class='input-group'>
                                        <input type='number' class='form-control' id='osab' placeholder='Organism solar absorptivity'/>
                                        <span class='input-group-addon'>-</span>
                                        <input type='number' class='form-control' id='gsab' placeholder='Ground solar absorptivity'/>
                                        </div>"),
                                      conditionalPanel("input.organism == 'lizard'",
                                                       # Only prompt for svl when chosen Lizard
                                                   numericInput("svl", "Snout Vent Length(cm)", 5)
                                      ),
                                      conditionalPanel("input.organism == 'butterfly'",
                                                       # Only prompt thorax specific inputs when chosen butterfly
                                                       numericInput("td", "Thorax diameter(cm)", 5),
                                                       numericInput("tt", "Thorax fur thickness(cm)", 5),
                                                       numericInput("wsa", "Wing solar absorptivity", 5)

                                      ),
                                      conditionalPanel("input.organism == 'grasshopper'",
                                                       # Only prompt for length when chosen grasshopper
                                                       numericInput("glength", "Length(cm)", 5)
                                      ),
                                      conditionalPanel("input.organism == 'generic'",
                                                       radioButtons("shape", "Shape",
                                                                    list("Cylinder","Sphere"), inline = TRUE, selected = "Cylinder"),
                                                       # Prompt diameter and length
                                                       numericInput("diameter", "Diameter(cm)", 5),
                                                       numericInput("length", "Length(cm)", 5)

                                      ),
                                      radioButtons("orientation", "Orientation",inline = TRUE,
                                                   c("Parallel" = "parallel",
                                                     "Transverse" = "tverse")),

                                      HTML("<div class='input-group'>
                                           <input type='text' class='form-control' id='Nlat' placeholder='N Lat'/>
                                           <span class='input-group-addon'>-</span>
                                           <input type='text' class='form-control' id='Slat' placeholder='S Lat'/>
                                           </div>"),
                                      HTML("<div class='input-group'>
                                           <input type='text' class='form-control' id='Wlon' placeholder='W Lon'/>
                                           <span class='input-group-addon'>-</span>
                                           <input type='text' class='form-control' id='Elon' placeholder='E Lon'/>
                                           </div>"),
                                      radioButtons("tf", "Timeframe:",inline = TRUE,
                                                   c("Past" = "past",
                                                     "Future" = "future")),
                                      br(),
                                      tags$head(
                                        tags$style(HTML('#goDownload{color: #fff;background-color:orange; border-color: #2e6da4}'))
                                      ),
                                      actionButton("goDownload", "Download", icon = icon("area-chart"))

                        ),

                        tags$div(id="cite",
                                 'Huckley Lab ', tags$em('The TrEnCh Project'), ' by Aji John'
                        )
                    )
           ),

           conditionalPanel("false", icon("crosshair"))
)

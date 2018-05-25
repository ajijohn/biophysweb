library(leaflet)

# Choices for drop-downs
vars <- c(
  "Generic" = "generic",
  "Lizard" = "lizard",
  "Butterfly" = "butterfly",
  "Grasshopper" = "grasshopper"
)

jscode <- '
Shiny.addCustomMessageHandler("mymessage", function(message) {
alert(message);
});
'

navbarPage("BioPhyz", id="nav",

           tabPanel("Visualize Stress",
                    div(class="outer",

                        tags$head(
                          # Include our custom CSS
                          includeCSS("../styles.css"),
                          includeScript("../gomap.js")

                        ),
                        tags$head(tags$script(HTML(jscode))),
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),

                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 400, height = "auto",
                                      h2("Filter"),
                                     HTML("<div class='panel-group' id='accordion'>"),

                                      HTML("<div class='panel panel-default' id='panel0'>
                                           <div class='panel-heading'>
                                           <h4 class='panel-title'>
                                           <a data-toggle='collapse' data-target='#collapseZero'
                                           href='#collapseZero'>
                                           Map
                                           </a>
                                           </h4>

                                           </div>
                                           <div id='collapseZero' class='panel-collapse collapse'>
                                           <div class='panel-body'>"),

                                      selectInput("organism", "Organism", vars),
                                      numericInput("height", "Height(cm)", 5),
                                       br(),
                                      radioButtons("suns", "Shading:",inline = TRUE,
                                                   c("Sun" = "sun",
                                                     "Shade" = "shade")),
                                      numericInput("sac", "% SA in contact with ground", 5),
                                     HTML('<div class="input-group mb-3">
                                          <div class="input-group-prepend">
                                          <span class="input-group-text" id="basic-addon3">Solar Absorptivity</span>
                                          </div>
                                          </div>'),
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


                                      HTML("</div>


                                           </div>
                                           </div>"),

                                      HTML("<div class='panel panel-default' id='panel1'>
                                           <div class='panel-heading'>
                                           <h4 class='panel-title'>
                                           <a data-toggle='collapse' data-target='#collapseOne'
                                           href='#collapseOne'>
                                           Location
                                           </a>
                                           </h4>

                                           </div>
                                           <div id='collapseOne' class='panel-collapse collapse'>
                                           <div class='panel-body'>"),

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


                                            HTML("</div>


                                           </div>
                                           </div>"),

                                            HTML("<div class='panel panel-default' id='panel2'>
                                           <div class='panel-heading'>
                                           <h4 class='panel-title'>
                                           <a data-toggle='collapse' data-target='#collapseTwo'
                                           href='#collapseTwo'>
                                             Output
                                           </a>
                                             </h4>

                                             </div>
                                             <div id='collapseTwo' class='panel-collapse collapse'>
                                             <div class='panel-body'>"),

                                              radioButtons("tf", "Timeframe:",inline = TRUE,
                                                   c("Past" = "past", "Present" = "pre",
                                                 "Future" = "future")),

                                      dateInput("inDate", "Date",width="100%",value = "1981-01-01",min = "1981-01-01",max = "1981-01-31"),
                                      sliderInput("hour", "Hour", min = 0, max = 23, value = 13),

                                            HTML("</div>
                                           </div>
                                           </div>
                                       </div>"),

                                      br(),
                                      tags$head(
                                        tags$style(HTML('#goDownload{color: #fff;background-color:orange; border-color: #2e6da4}'))
                                      ),

                                      actionButton("goDownload", "Download", icon = icon("area-chart")),

                                     checkboxInput("legend", "Show legend", TRUE)


                        ),

                        tags$div(id="cite",
                                 'Huckley Lab ', tags$em('The TrEnCh Project'), ' by Aji John'
                        )
                    )
           ),

           conditionalPanel("false", icon("crosshair"))
)

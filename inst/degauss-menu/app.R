# TODO make these suggested or check and ask user to install?
library(shiny)
library(bs4Dash)
library(waiter)


ui <- dashboardPage(
  title = "DeGAUSS Menu",
  header = dashboardHeader(htmltools::h3("DeGAUSS Menu"), compact = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  preloader = list(
    html = tagList(spin_refresh(), h3("Loading DeGAUSS Menu...")),
    color = dht::degauss_colors(5)
  ),
  body = dashboardBody(
    box(
      checkboxInput("geocode", "Geocode addresses?", FALSE),
      textInput("address_filename", "Address filename", value = "my_address_file.csv"),
      htmltools::h6("DeGAUSS geocoding command:"),
      verbatimTextOutput("degauss_geocoding_cmd", placeholder = TRUE),
      title = "Geocoding",
      width = 12,
      collapsed = TRUE
    ),
    box(
      textInput("input_filename", "Geocoded filename", value = "my_address_file_geocoded.csv"),
      checkboxGroupInput(
        "selected_images",
        label = "Select which DeGAUSS images to use:",
        choices = dht:::core_lib_images(geocoder = FALSE)
      ),
      htmltools::h6("DeGAUSS command(s):"),
      verbatimTextOutput("degauss_cmd", placeholder = TRUE),
      title = "Geomarker Assessment",
      width = 12
    )
  )
)

# TODO add checkbox option that will derive geocoded filename from the output of the degauss geocoding command
# TODO better way to have output DeGAUSS commands; html widget with a copy button like on gh?
# TODO fix the default argument for narr; make it "" for a blank or non-use of the optional flag
# TODO can we leave the default of "none" for drivetime, or let it error with an empty value?
# TODO add function in package to run this app, suggest and check for shiny installation first

server <- function(input, output, session) {
  d <- dht::create_degauss_menu_data()
  output$degauss_cmd <- renderText({
      d %>%
        dplyr::filter(name %in% input$selected_images) %>%
        dplyr::pull(degauss_cmd) %>%
        gsub("my_address_file_geocoded.csv", input$input_filename, ., fixed = TRUE)
    },
    sep = "\n"
  )
  output$degauss_geocoding_cmd <- renderText({
    if (input$geocode) {
      d %>%
        dplyr::filter(name == "geocoder") %>%
        dplyr::pull(degauss_cmd) %>%
        gsub("my_address_file_geocoded.csv", input$address_filename, ., fixed = TRUE)
    }
  })
}

shinyApp(ui, server)

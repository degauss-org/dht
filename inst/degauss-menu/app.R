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
      title = "Input File",
      textInput("input_filename", "Geocoded filename", value = "my_address_file_geocoded.csv"),
      bookmarkButton("Copy URL to save app state"),
      width = 6
    ),
    box(DT::dataTableOutput("core_lib_images_table"),
        title = "DeGAUSS Core Library",
        width = 12
        ),
    box(
      verbatimTextOutput("degauss_cmd", placeholder = TRUE),
      title = "DeGAUSS command(s)",
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

  d <-
    get_degauss_core_lib_env(geocoder = FALSE) %>%
    dht::create_degauss_menu_data()

  output$core_lib_images_table <-
    DT::renderDataTable(
      dplyr::select(d, -degauss_cmd),
      escape = FALSE,
      options = list(autoWidth = TRUE)
    )

  output$degauss_cmd <- renderText({
    .r <- input$core_lib_images_table_rows_selected
    if (length(.r)) {
      d %>%
        ## dplyr::filter(name %in% input$selected_images) %>%
        dplyr::slice(input$core_lib_images_table_rows_selected) %>%
        dplyr::pull(degauss_cmd) %>%
        gsub("my_address_file_geocoded.csv",
             input$input_filename,
             .,
             fixed = TRUE)
    }
    },
    sep = "\n"
  )
}

shinyApp(ui, server)

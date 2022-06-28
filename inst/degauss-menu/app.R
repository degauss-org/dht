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
    color = degauss_colors(5)#dht::degauss_colors(5)
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
    ),
    
    tags$head(tags$style(HTML("#core_lib_images_table {cursor:pointer;}")))
  )
)

server <- function(input, output, session) {

  d <-
    get_degauss_core_lib_env(geocoder = FALSE) %>%
    create_degauss_menu_data()#dht::create_degauss_menu_data()

  output$core_lib_images_table <-
    DT::renderDataTable(
      dplyr::select(d, -degauss_cmd) %>%
        transform(url = paste0("<a href='", url, "'>", url, "</a>")),
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

# TODO make these suggested or check and ask user to install?
library(shiny)
library(bs4Dash)
library(waiter)


ui <- function(request) {
  bs4Dash::dashboardPage(
    
  title = "DeGAUSS Menu",
  header = dashboardHeader(htmltools::h3("DeGAUSS Menu"), compact = TRUE),
  sidebar = dashboardSidebar(
    
    checkboxGroupInput(inputId = "want", label = "What do you want?",
                       choices = c("Census geography" = "census", "Area material deprivation" = "depind",
                                   "Traffic/driving information" = "traffic", "Landcover makeup" = "land",
                                   "Weather data" = "weather", "Air pollution" = "pollute")),
    
    
    radioButtons(inputId = "temporal", inline = FALSE, label = "Do you have temporal data?",
                       choices = c("Yes", "No", "Not Sure"), selected = "Not Sure")
    
  ),
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
    rclipboard::rclipboardSetup(),
    fluidRow(
      box(
        verbatimTextOutput("degauss_cmd", placeholder = TRUE),
        title = "DeGAUSS command(s)",
        width = 10
      ),
      uiOutput("clip", width = 2)
      ),
    tags$head(tags$style(HTML("#core_lib_images_table {cursor:pointer;}")))
  )
)
}

server <- function(input, output, session) {

  d <-
    get_degauss_core_lib_env(geocoder = FALSE) %>%
    create_degauss_menu_data()  #dht::create_degauss_menu_data()
  
  d <- d %>%
    mutate(category = case_when(
      name %in% c("census_block_group", "st_census_tract") ~ "census",
      name %in% "dep_index" ~ "depind",
      name %in% c("roads", "aadt", "drivetime") ~ "traffic",
      name %in% c("greenspace", "nlcd") ~ "land",
      name %in% "narr" ~ "weather",
      name %in% "pm" ~ "pollute"
    ),
    temporal = case_when(
      name %in% c('st_census_tract', 'aadt', 'narr', 'pm') ~ 'Yes',
      name %in% c('census_block_group', 'dep_index', 'roads', 'drivetime', 'greenspace', 'nlcd') ~ 'No'
      ))
  
  d_obj <- reactive({
    d <- dplyr::select(d, -degauss_cmd) %>%
      transform(url = paste0("<a href='", url, "'>", url, "</a>")) 
    
    d <- ifelse(is.null(input$want) & input$temporal == "Not Sure",
                d,
                filter(d, category %in% input$want & temporal %in% input$temporal)
    )
  })

  output$core_lib_images_table <-
    DT::renderDataTable(
      d_obj(),
      escape = FALSE,
      options = list(autoWidth = TRUE),
      selection = "single"
    )

  selected_cmd <- reactive({
    ifelse(length(input$core_lib_images_table_rows_selected),
           d %>%
             ## dplyr::filter(name %in% input$selected_images) %>%
             dplyr::slice(input$core_lib_images_table_rows_selected) %>%
             dplyr::pull(degauss_cmd) %>%
             gsub("my_address_file_geocoded.csv",
                  input$input_filename,
                  .,
                  fixed = TRUE), 
           "")
    })
  
  output$degauss_cmd <- renderText({
    selected_cmd()
  })
  
  output$clip <- renderUI({
    rclipboard::rclipButton(
      inputId = "clipbtn",
      label = "Copy Docker Command",
      clipText = selected_cmd(),
      icon = icon("clipboard")
    )
  })
  
}

shinyApp(ui, server, enableBookmarking = "server")

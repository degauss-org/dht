# TODO make these suggested or check and ask user to install?
library(shiny)
library(bs4Dash)
library(waiter)
library(fresh)

theme <- create_theme(
  bs4dash_vars(
    navbar_light_color = degauss_colors(2),
    navbar_light_active_color = "#FFF",
    navbar_light_hover_color = "#FFF",
    card_bg = "#FFF"
  ),
  bs4dash_yiq(
    contrasted_threshold = 1,
    text_dark = "#FFF",
    text_light = "black"
  ),
  bs4dash_layout(
    main_bg = degauss_colors(6)
  ),
  bs4dash_sidebar_light(
    bg = degauss_colors(2),
    header_color = degauss_colors(1)
  ),
  bs4dash_status(
    primary = degauss_colors(1),
    success = degauss_colors(3)
  ),
  bs4dash_color(
    gray_900 = degauss_colors(1), white = degauss_colors(4)
  )
)


ui <- function(request) {
  bs4Dash::dashboardPage(
    
    freshTheme = theme,
    
    dark = NULL,
    
    title = "DeGAUSS Menu",
    
    header = dashboardHeader(htmltools::h3("DeGAUSS Menu"), compact = TRUE),
  
  sidebar = dashboardSidebar(
    
    minified = FALSE,
    
    skin = "light",
    
    sidebarHeader("Selections"),
    
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
    
    rclipboard::rclipboardSetup(),
    
    box(
      title = "Input File",
      textInput("input_filename", "Geocoded filename", value = "my_address_file_geocoded.csv"),
      bookmarkButton("Copy URL to save app state"),
      width = 6,
      status = 'primary',
      solidHeader = TRUE,
      color = 'white'
    ),
    box(DT::dataTableOutput("core_lib_images_table"),
      title = "DeGAUSS Core Library",
      width = 12,
      status = 'primary',
      solidHeader = TRUE,
      color = "white"
    ),
    box(title = "DeGAUSS command(s)",
        verbatimTextOutput("degauss_cmd", placeholder = TRUE),
        uiOutput("clip"),
        width = 12,
        status = 'primary',
        solidHeader = TRUE,
        color = "white"
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
    
    if (is.null(input$want) & input$temporal == "Not Sure"){
      d
    } else {
    d <- d %>%
      filter(category %in% input$want & temporal %in% input$temporal)
    }
   
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
      icon = icon("clipboard"),
      
    )
  })
  
}

shinyApp(ui, server, enableBookmarking = "server")

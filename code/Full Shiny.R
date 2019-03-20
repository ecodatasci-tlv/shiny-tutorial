##Load packges
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(readr)
library(dplyr)
library(tidyr)
library(leaflet)
library(lubridate)
library(ggplot2)
library(here)

##Import data
trawl_data_clean  <- read_csv(here::here("data/trawl_data_clean2.csv"), 
                              col_types = cols(CruiseDate = col_date(format = "%m/%d/%Y")))

##Load user functions (use function 'source' and the path to the .R file)
source(here::here("code/shiny_functions_clean.R"))

####Shiny UI
ui <- dashboardPage(
  dashboardHeader(title = "Trawl catch survey"),#This is the title of the shiny dashboard
  
  dashboardSidebar(#Side bar where we will put the selection widgets
    
    ###The first widget which will allow the user to select which survey depths to include
    pickerInput(#This is the type of the widget - a multi-selection widget
      inputId = "Depth", #The 'inputId' is used to refer shiny to the values selected by the user (in this case which depths to include)
      label = "Select survey depths:",#The 'label' is the text which the user will see above the widget
      choices = sort(unique(trawl_data_clean$Depth)),#The choices included in the select widget. NOTICE: here we use the data we uploaded
      selected = sort(unique(trawl_data_clean$Depth)),#What is selected as default when the app opens
      options = list(#Some aesthetics for the widget
        `actions-box` = TRUE, 
        size = 10,
        `selected-text-format` = "count > 10"
      ), 
      multiple = TRUE#Allow multiple choices
    ),
    
    ###The second widget which will allow the user to select which survey dates to include
    dateRangeInput(inputId = 'dateRange',#The 'inputId' is used to refer shiny to the values selected by the user
                   label = 'Select survey dates:',#The 'label' is the text which the user will see above the widget
                   start = min(trawl_data_clean$CruiseDate) , end = max(trawl_data_clean$CruiseDate)#Range of dates. NOTICE: here we use the data we uploaded
    ),
    
    ###The third widget which will allow the user to select the column used for the coloring and ggplot's x-axis
    selectInput(#'selectInput' is a simple widget which allows single value selection
      inputId = "plot_by",#The 'inputId' is used to refer shiny to the values selected by the user
      label = "Plot by:",#The 'label' is the text which the user will see above the widget
      choices = c("Depth","Year","Season"),#Which choices can the user pick
      selected = "Depth")#What is selected as default  when the app opens
    
  ),
  ##Here we move to the body of the shiny app where we want to place the leaflet map and the ggplot
  dashboardBody(
    fluidRow(
      
      ##First we place the map on the top of the panel
      box(width=20,#Box is used to define the size of the map
          leafletOutput("mymap",height = 350)#'leafletOutput' is called to plot the leaflet map. NOTICE: "mymap" is an element defined in the server side
      ),
      
      ##Second box for the ggplot
      box(width=20,#Box is used to define the size of the map
          plotOutput("myplot",height = 250))##'plotOutput' is called to plot the ggplot. NOTICE: "myplot" is an element defined in the server side
    )
  )
)

server <- function(input, output,session) {
  ##In the server side we will do all the data manipulations based user's selection from the input widgets 
  
  
  output$mymap <- renderLeaflet({#Here we create the leaflet map. NOTICE: 1. The map output name will be 'mymap' as defined by "output$mymap" 2. renderLeaflet - is a shiny 'function' which output is a leaflet map
    
    ##Here we will observe the user inputs from the UI side
    depth=input$Depth#We observe the value selected by the user in the 'Depth' widget
    dateRange=input$dateRange#We observe the value selected by the user in the 'dateRange' widget
    color_by=input$plot_by#We observe the value selected by the user in the 'plot_by' widget
    
    ##Next we use the selected values to subset the complete data frame 
    subseted_data=trawl_data_clean%>%
      filter(Depth %in% depth)%>%
      filter(CruiseDate>dateRange[1] & CruiseDate<dateRange[2])
    
    ##Next we call our user defined function to create leaflet map according to the subseted data and the column selected for coloring
    leaflet_plot(data_in=subseted_data,color_by=color_by)
  })
  
  output$myplot <- renderPlot({#Here we create the ggplot. NOTICE: 1. The map output name will be 'myplot' as defined by "output$myplot" 2. renderPlot - is a shiny 'function' which output is a plot
    
    ##Here we will observe the user inputs from the UI side
    depth=input$Depth#We observe the value selected by the user in the 'Depth' widget
    dateRange=input$dateRange#We observe the value selected by the user in the 'dateRange' widget
    plot_by=input$plot_by#We observe the value selected by the user in the 'plot_by' widget
    
    ##Next we use the selected values to subset the complete data frame 
    subseted_data=trawl_data_clean%>%
      filter(Depth %in% depth)%>%
      filter(CruiseDate>dateRange[1] & CruiseDate<dateRange[2])
    
    ##Next we call our user defined function to create ggplot according to the subseted data and the column selected for x-axis
    ggplot_plot(subseted_data,group_by=plot_by)
  })
  
  
}

shinyApp(ui, server)##Lastly we use this line to indicate RStudio this is a Shiny file with both the ui and server sides



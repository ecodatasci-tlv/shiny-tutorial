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

### READ THE SOURCE DATA TABLE ### 

##Load user functions (use function 'source' and the path to the .R file)

### LOAD FUNCTION SCRIPT ### 


####Shiny UI
ui <- dashboardPage(
  dashboardHeader(title = "Trawl catch survey"),#This is the title of the shiny dashboard
  
  dashboardSidebar(#Side bar where we will put the selection widgets
    
    ###The first widget which will allow the user to select which survey depths to include
   
    ########PLACE INPUT WIDGET HERE#########
    
    ###The second widget which will allow the user to select which survey dates to include

    ########PLACE INPUT WIDGET HERE#########
    
    ###The third widget which will allow the user to select the column used for the coloring and ggplot's x-axis
 
    ########PLACE INPUT WIDGET HERE#########
    
  ##Here we move to the body of the shiny app where we want to place the leaflet map and the ggplot
  dashboardBody(
    fluidRow(
      
      ##First we place the map on the top of the panel
      box(width=20,#Box is used to define the size of the map
          ########PLACE LEAFLET OUTPUT HERE#########)  #'leafletOutput' is called to plot the leaflet map. NOTICE: "mymap" is an element defined in the server side
      ),
      
      ##Second box for the ggplot
      box(width=20,#Box is used to define the size of the map
          ########PLACE GGPLOT OUTPUT HERE#########)##'plotOutput' is called to plot the ggplot. NOTICE: "myplot" is an element defined in the server side
    )
  )
)

server <- function(input, output,session) {
  ##In the server side we will do all the data manipulations based user's selection from the input widgets 
  
  
  output$mymap <- renderLeaflet({#Here we create the leaflet map. NOTICE: 1. The map output name will be 'mymap' as defined by "output$mymap" 2. renderLeaflet - is a shiny 'function' which output is a leaflet map
    
    ##Here we will observe the user inputs from the UI side
    depth <- #### REFER TO THE USER SELCTION ### #Here we observe the value selected by the user in the 'Depth' widget 
    dateRange <- input$dateRange#### REFER TO THE USER SELCTION ### #We observe the value selected by the user in the 'dateRange' widget
    color_by <- #### REFER TO THE USER SELCTION #### #Here we observe the value selected by the user in the 'plot_by' widget
    
    ##Next we use the selected values to subset the complete data frame 
    subseted_data <- trawl_data_clean%>%
      filter(Depth %in% depth)%>%
      filter(CruiseDate>dateRange[1] & CruiseDate<dateRange[2])
    
    ##Next we call our user defined function to create leaflet map according to the subseted data and the column selected for coloring
    
    ### CALL THE USER DEFINED FUNCTION FOR LEAFLET MAP ###
  })
  
  output$myplot <- renderPlot({#Here we create the ggplot. NOTICE: 1. The map output name will be 'myplot' as defined by "output$myplot" 2. renderPlot - is a shiny 'function' which output is a plot
    
    ##Here we will observe the user inputs from the UI side
    depth= #### REFER TO THE USER SELCTION ### #Here we observe the value selected by the user in the 'Depth' widget
    dateRange <- input$dateRange#### REFER TO THE USER SELCTION ### #We observe the value selected by the user in the 'dateRange' widget
    plot_by <- #### REFER TO THE USER SELCTION #### #Here we observe the value selected by the user in the 'plot_by' widget
      
    ##Next we use the selected values to subset the complete data frame 
    subseted_data <- trawl_data_clean%>%
      filter(Depth %in% depth)%>%
      filter(CruiseDate>dateRange[1] & CruiseDate<dateRange[2])
    
    ##Next we call our user defined function to create ggplot according to the subseted data and the column selected for x-axis
   
    ### CALL THE USER DEFINED FUNCTION FOR LEAFLET MAP ###
    
  })
  
  
}

shinyApp(ui, server)##Lastly we use this line to indicate RStudio this is a Shiny file with both the ui and server sides



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

}

shinyApp(ui, server)##Lastly we use this line to indicate RStudio this is a Shiny file with both the ui and server sides



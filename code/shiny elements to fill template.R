##Here you will find all the needed elements to turn the shiny template into working web app!

###Read data and upload functions

##Read data
trawl_data_clean  <- read_csv(here::here("data/trawl_data_clean2.csv"), 
                              col_types = cols(CruiseDate = col_date(format = "%m/%d/%Y")))

##Load functions
source(here::here("code/shiny_functions_clean.R"))


###UI elements

##Depth selection widget

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
)

##Date selection widget

dateRangeInput(inputId = 'dateRange',#The 'inputId' is used to refer shiny to the values selected by the user
               label = 'Select survey dates:',#The 'label' is the text which the user will see above the widget
               start = min(trawl_data_clean$CruiseDate) , end = max(trawl_data_clean$CruiseDate)#Range of dates. NOTICE: here we use the data we uploaded
)

##Column selection for plotting

selectInput(#'selectInput' is a simple widget which allows single value selection
  inputId = "plot_by",#The 'inputId' is used to refer shiny to the values selected by the user
  label = "Plot by:",#The 'label' is the text which the user will see above the widget
  choices = c("Depth","Year","Season"),#Which choices can the user pick
  selected = "Depth")#What is selected as default  when the app opens


###SERVER elements

###Observing the user's inputs from the UI

##Get the user depth selection
input$Depth

##Get the user date selection
input$dateRange

##Get the user input on the column to color/plot by
input$plot_by

###Calling the leaflet and plot functions

##Leaflet function
leaflet_plot(data_in=subseted_data,color_by=color_by)

##ggplot function
ggplot_plot(subseted_data,group_by=plot_by)




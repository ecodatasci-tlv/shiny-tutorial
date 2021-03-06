## Script with two functions which will be used foe the Shiny app

#### 1. Function 'leaflet_plot'

## Objective: plot sampling points on interactive map (leaflet)

## Inputs:
# data_in - data frame with data on locations, dates and catch
# color_by - the name of the data column used to color the points

leaflet_plot <- function(data_in, color_by) {
  # This is the data after the subseting
  input_data_raw <- data_in
  # These are unique locations
  location_unique <- input_data_raw[!duplicated(input_data_raw[, c("Lat", "Lon")]), c("CruiseDate", "Season", "Depth", "Lat", "Lon")]
  # Sum weight for all combinations of locations ("Lat","Lon") and Commercial and non-Commercial species ("Commercial")
  input_data <- input_data_raw %>%
    group_by(Lat, Lon, Commercial) %>%
    summarise(Sumweight = sum(TotalWeight)) %>%
    left_join(location_unique, by = c("Lat", "Lon"))
  # Transform to wide format
  input_data_wide <- spread(input_data, Commercial, Sumweight)
  colnames(input_data_wide) <- c("Lat", "Lon", "CruiseDate", "Season", "Depth", "NonCommercial", "Commercial")
  # Create labels for leaflet
  input_data_wide$label <- paste(paste("Depth:", input_data_wide$Depth),
    paste("Date:", input_data_wide$CruiseDate),
    paste("Commercial:", round(input_data_wide$com / 1000, digits = 0), "Kg"),
    paste("Non-Commercial:", round(input_data_wide$noncom / 1000, digits = 0), "Kg"),
    sep = "  "
  )
  input_data_wide <- data.frame(input_data_wide)
  input_data_wide$Year <- year(input_data_wide$CruiseDate)
  # Plot using leaflet
  # set colors
  factpal <- colorFactor(topo.colors(4), as.factor(input_data_wide[, color_by]))
  # plot
  leaflet() %>%
    addTiles() %>%
    addProviderTiles("CartoDB.DarkMatter", group = "Dark map") %>%
    fitBounds(min(input_data_wide$Lon) - 0.01, min(input_data_wide$Lat) - 0.01, max(input_data_wide$Lon) + 0.01, max(input_data_wide$Lat) + 0.01) %>%
    addCircles(lng = input_data_wide$Lon, lat = input_data_wide$Lat, label = input_data_wide$label, color = factpal(as.factor(input_data_wide[, color_by])), radius = 100) %>%
    addLegend(pal = factpal, values = as.factor(input_data_wide[, color_by]), opacity = 1)
}

data_in <- trawl_data_clean
color_by <- ""
leaflet_data(trawl_data_clean, color_by = "Season")


#### 1. Function 'ggplot_plot'

## Objective: bar plot of catch traits

## Inputs:
# data_in - data frame with data on locations, dates and catch
# group_by - categories on the x-axis


ggplot_plot <- function(data_in, group_by) {
  # This is the data after the subseting
  input_data_raw <- data_in
  input_data_raw$Year <- year(data_in$CruiseDate)
  if (group_by == "Depth") {
    input_data_ggplot <- input_data_raw %>%
      group_by(Depth, Commercial) %>%
      summarise(Sumweight = sum(TotalWeight) / 1000)
    # turn depth to factor
    input_data_ggplot$Depth <- as.factor(input_data_ggplot$Depth)
  } else if (group_by == "Year") {
    input_data_ggplot <- input_data_raw %>%
      group_by(Year, Commercial) %>%
      summarise(Sumweight = sum(TotalWeight) / 1000)
    # turn depth to factor
    input_data_ggplot$Year <- as.factor(input_data_ggplot$Year)
  } else if (group_by == "Season") {
    input_data_ggplot <- input_data_raw %>%
      group_by(Season, Commercial) %>%
      summarise(Sumweight = sum(TotalWeight) / 1000)
    # turn depth to factor
    input_data_ggplot$Year <- as.factor(input_data_ggplot$Season)
  }


  ## Plot using ggplot
  cbbPalette <- c("green", "red")
  input_data_ggplot <- data.frame(input_data_ggplot)
  ggplot_catch <- ggplot(data = input_data_ggplot, aes(x = input_data_ggplot[, group_by], y = Sumweight, fill = Commercial)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    xlab(group_by) + ylab("Total catch (Kg)") + theme_grey(base_size = 22) +
    theme(legend.title = element_blank()) +
    scale_fill_manual(values = cbbPalette)


  return(ggplot_catch)
}

# shiny tutorial

Open this repository in your local RStudio by running the following code:

```r
# install.packages("usethis")
usethis::use_course("https://github.com/ecodatasci-tlv/shiny-tutorial/archive/master.zip")
```

For this tutorial, you will need the following packages:

```r
# install packages if you don't already have them
if(!require(shiny)) install.packages("shiny")
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(shinyWidgets)) install.packages("shinyWidgets")
if(!require(leaflet)) install.packages("leaflet")
if(!require(here)) install.packages("here")
if(!require(tidyverse)) install.packages("tidyverse")

# download course materials
if(!require(usethis)) install.packages("usethis")
use_course("https://github.com/ecodatasci-tlv/shiny-tutorial/archive/master.zip")
```

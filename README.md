# shiny tutorial

Open this repository in your local RStudio by running the following code:

```r
# install.packages("usethis")
usethis::use_course("https://github.com/ecodatasci-tlv/shiny-tutorial/archive/master.zip")
```

For this tutorial, you will need the following packages:

```r
if(!require(shiny)) install.packages("shiny")
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(shinyWidgets)) install.packages("shinyWidgets")
if(!require(leaflet)) install.packages("leaflet")
if(!require(here)) install.packages("here")
if(!require(tidyverse)) install.packages("tidyverse")
```

Useful resources:

- [another Shiny intro](http://benbestphd.com/shiny-intro/) by Ben Best
- [example with code highlighting](https://shiny.rstudio.com/gallery/telephones-by-region.html) - see what part of the code is affected when you interact with the Shiny app!
- [Apps and dashboards with Shiny](https://rstudio-education.github.io/shiny-wsds18/) course materials

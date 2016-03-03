#My Travel Map server.R - JHDS 09 - Developing Data Products
#The UI code has widgets in the side bar panel to control
#  Location type select group: Home, Project, Meeting (business trip) and Travel - to begin all four are selected
#  Start year slider
#  End year Slider
#  A drop-down box to select the color palette for the map markets - these are 4 palettes from rColorBrewer - Dark2 is the default 

library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  # shiny theme
  theme = shinytheme("readable"),    
  # Application title
  titlePanel("My Travel Map"),

    # Group check box for the types of lications to be included as points on the map
    # Sidebar with a slider input for the start year and end year
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("ityp", "Select Location Types",
                         choices = list("Home" = "Home",
                         "Project" = "Project",
                         "Meeting" = "Meeting", 
                         "Travel"  = "Travel"),
                         selected = c("Home", "Project", "Meeting", "Travel")),

      sliderInput("yearRange", label = "Years to include", 
                  min = 1974, max = 2015, 
                  value = c(1974, 2015), sep = ""),
      
      selectInput("palet", "Select a color palette for the markers:",
                  c("Set3"  = "Set3",
                    "Dark2" = "Dark2",
                    "Set1"  = "Set1")),
      
      helpText("The application selects locations based on the type of locations",
               "and the range of years to include, calculates the map", 
               "coordinates based on the remaining points and plots the", 
               "locations using different colored markers for the different",
               "location types.")
      
      
      ),
    # Show the generated map
    mainPanel(
        uiOutput('newMap')
    )
  )
))

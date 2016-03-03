#My Travel Map server.R - JHDS 09 - Developing Data Products
#The server side code uses input of filters
#  Location type: Home, Project, Travel, Meeting
#  Start Year
#  End Year
#  and a color palette selection to display a map of the locations

#To start an input file of locations is read once - file columns are
#  Town (e.g., "London, UK")
#  LocType - values are "Home", "Project", "Travel", "Meeting"
#  Year (4-digit year)
#  Long - longitude of the Town
#  Lat - latitude of the Town

require(plotGoogleMaps); require(ggmap); require(sp); require(RColorBrewer)

#Read the data file of locations
inp <- gzfile("myLocs.RDS")
myLocs <- readRDS(inp)
close(inp)

shinyServer(function(input, output) {
    
    output$newMap <- renderUI({
        Locs <- myLocs                                      #Make a request-specific copy of the table to filter
        Locs <- Locs[ (Locs$LocType %in% input$ityp), ]     #Filter location types selected
        Locs <- Locs[ (Locs$Year >= input$yearRange[1]), ]  #Filter year range
        Locs <- Locs[ (Locs$Year <= input$yearRange[2]), ]

        if (nrow(Locs) > 0) {                               #Create a plot if the table is not empty
            myPalette <- input$palet
            coordinates(Locs) = ~ Long + Lat                #Create map coordinates from latitude & longitude
            proj4string(Locs) = CRS("+proj=longlat +datum=WGS84")
            Locs2 <- SpatialPointsDataFrame(Locs, data = data.frame( ID = row.names(Locs) ) ) 
                                                            #Build the location markers
            ic <- iconlabels(Locs$LocType,height=10,icon=TRUE,colPalette = brewer.pal(4,myPalette))
        
            m <- plotGoogleMaps(Locs, zcol="LocType", filename = 'myMap1.html', iconMarker = ic, openMap = FALSE,
                            colPalette=brewer.pal(4,myPalette), legend = FALSE)
            #The map plot is written to an html file then it's brought into the page with this iframe
            #For more into see https://gist.github.com/ramnathv/275fe2a088e539f6b1ca
            tags$iframe(
                srcdoc = paste(readLines('myMap1.html'), collapse = '\n'),
                width = "100%",
                height = "600px"
                
             )
        }
    })

})

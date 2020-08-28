install.packages('leaflet')

library(raster)
library(leaflet)


# Get USA polygon data
USA <- getData("GADM", country = "usa", level = 2)

# Prepare data
mydata <- data.frame(state = c("Iowa", "Oklahoma", "Iowa"),
                     county = "Adair",
                     value = c(20, 100, 30),
                     class = c("A", "A", "B"),
                     date = c("Sept 2008", "Dec 2005", "Jan 2020"),
                     stringsAsFactors = FALSE)

# I do not know how your actual data is like. In this demonstration,
# I have data points for Adair in Iowa and Oklahoma. So 

temp <- merge(USA, mydata,
              by.x = c("NAME_1", "NAME_2"), by.y = c("state", "county"),
              all.x = TRUE, extent = T)

myCounties <- data.frame(long = rep(NA, nrow(mydata)), lat = rep(NA, nrow(mydata)))

for (i in 1:nrow(mydata)){
  
  # Store average latitude and longitude for county. 
  myCounties[i, ] <- temp[(temp$NAME_1 == mydata$state[i] & temp$NAME_2 == mydata$county[i]), ] %>% coordinates() %>% apply(2, mean)
   
}

myCounties <- cbind(myCounties, mydata)

leaflet(myCounties) %>% 
  jitter() %>%
  addTiles() %>% 
  addCircleMarkers(popup = paste("Class: ", myCounties$class, "<br>",
                                   "Value: ", myCounties$date, "<br>"))


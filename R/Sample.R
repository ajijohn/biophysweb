require(leaflet)
library(RColorBrewer)
library(leaflet.extras)
library(magrittr)
library(dplyr)
library(sp)
library(rgdal)


od<- read.csv(paste(strsplit(getwd(), "/R")[[1]],"/data/jan1981To.csv",sep=""))

# Filter for a day at a certain hour
# 20 hrs
odf <- od %>% filter(day == 1,month==1,hr==20)

pal <- colorNumeric(
  palette = "YlGnBu",
  domain = odf$To_Lizard
)

#example using leaflet
#leaflet(odf) %>%
#  addProviderTiles(providers$Stamen.Terrain)  %>%
#  addHeatmap(lng = ~lon, lat = ~lat, intensity = ~To_Lizard,
#             blur = 20, max = 0.05, radius = 15) %>%
#   addLegend("bottomright", pal = pal, values = ~To_Lizard,
#          title = "To (Lizard)",
#          labFormat = labelFormat(prefix = "degC-"),
#          opacity = 1
#)


# create spatial dataframe
xy_df <- data.frame(lon=odf$lon,lat=odf$lat)
coordinates(xy_df)= ~lon + lat
to_df <- data.frame(to = as.vector(odf$To_Lizard))
to_sp_fw <- SpatialPointsDataFrame(coordinates(xy_df), data =to_df
                                    , proj4string = CRS("+proj=longlat +ellps=WGS84"))

#plot it
library(ggmap)

to_df_final <- as.data.frame(to_sp_fw)
#us_map<-get_map(location='united states', zoom=5, maptype = "terrain",
#                source='google',color='color')

us_map <- get_map(location = bbox(xy_df), zoom = 6,
               maptype = "satellite", source = "google")

ggmap(us_map) + geom_point(
  aes(x=lon, y=lat, colour=to),
  data=to_df_final, alpha=.8, na.rm = T) +
  scale_colour_gradientn(colours = terrain.colors(10))


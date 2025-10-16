
# How to download a shapefile that can be used as boundaries for elevation data download

install.packages(c("tigris", "sf", "terra", "elevatr", "rayshader"))

library(tigris)
library(sf)
library(terra)
library(elevatr)
library(rayshader)
library(dplyr)


# Download NY boundary as a simple features object
ny_sf <- states(cb = TRUE, year = 2023) %>% 
  filter(NAME == "New York")


#  Reproject to WGS84 (required by elevatr) 
ny_wgs84 <- st_transform(ny_sf, 4326)

# Download elevation data from elevatr
# Use z = 8–10 for state-level resolution
ny_elev_rast <- get_elev_raster(locations = ny_wgs84, z = 8, clip = "location")  %>% 
  terra::rast()

# convert to matrix 
ny_matrix <- raster_to_matrix(ny_elev_rast)

# Visualize with rayshader - 
# big file-  wait a minute for it to load!
ny_matrix %>%
  sphere_shade(texture = "imhof4", zscale = 15) %>%
  plot_3d(
    ny_matrix,
    zscale = 15,
    windowsize = c(1200, 900),
    solid = TRUE,
    shadow = TRUE,
    water = FALSE
  )

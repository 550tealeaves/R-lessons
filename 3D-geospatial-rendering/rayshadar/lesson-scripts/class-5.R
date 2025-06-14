# install/load libraries
install.packages("sf")
install.packages("terra")
install.packages(("elevatr"))
install.packages("maptiles")
install.packages("rayshader")
install.packages("magick")

library(sf)
library(terra)
library(elevatr)
library(maptiles)
library(rayshader)
library(magick)


# Coordinates match up vertically
# KEY: bbox list coords in this order: 
-107.003030,39.034246,-106.647347,39.268537
# West,    South,     East,     North
# xmin,    ymin,      xmax,     ymax



# Define bounding box
bbox <- st_bbox(c(
  xmin = -107.003030,
  ymin = 39.034246,
  xmax = -106.647347,
  ymax = 39.268537
), crs = st_crs(4326)) %>%  
  st_as_sfc() %>%  
  st_sf() # turns it into simple features object


# Download the elevation raster & convert it to a format terra can use
# Rast function converts from raster layer to a spatial raster - newer file format used by terra for eg. resampling
# Final resolution of render depends on resolution fo the "z" arguments ex: (z=11). z=14 is highest
elev_spat <- get_elev_raster(bbox, z = 11, clip = "bbox",) %>% rast 


# Download satellite data
# get_tiles = maptiles function to retrieve maptiles from remote server - doesn't always show progress bar, must waitfor the object to appear in the environment (tiles)
# zoom and z are not the same, but keep them the same level resolution

# update this line when you want to change the map provider
tiles <- get_tiles(bbox, provider = "Esri.WorldImagery", zoom = 11) 

tiles2 <- get_tiles(bbox, provider = "Stadia.StamenTerrainBackground", apikey = "b0aa393e-2588-49b9-b517-afe7f775b1f9", zoom = 10)

View(tiles)


# Check the download
terra::plotRGB(tiles)


# Align, crop and resample using Terra


# Align tiles w/ elevation (gluing maptile onto the elev data)
tiles_aligned <-  tiles %>% 
  project(crs(elev_spat))

# Crop elevation to match the tiile extent exactly
elev_spat <-  crop(elev_spat, tiles_aligned)


# Resample the tiles ot cropped elevation raster
# Make sure the elevation data & map tiles have same # rows/col
tiles_aligned <- resample(tiles_aligned, elev_spat, method = "bilinear")


# Convert tile image to RGB
img_array <-  as.array(tiles_aligned) / 255
# converting from raster to a 3-band array
# rescale into values b/w 0 & 1, which Rayshader expects

#Turn elev raster into a matrix
elev_matrix <- raster_to_matrix(elev_spat)


# Make a hillshade using Rayshader

hillshade <- sphere_shade(elev_matrix, texture = "desert")

# different textures
hillshade <- sphere_shade(elev_matrix, texture = "bw")



overlay <- add_overlay(hillshade, img_array, alphalayer = 0.9)


# plot 3D
plot_3d(overlay, heightmap = elev_matrix, zscale = 10, windowsize = 1200)



# Experimenting w/ diff tile providers
# Check the list under
maptiles::get_providers()

# You can type in the name of the provider on line 45


# A good shortlist
# Esri.WorldImagery # photographic
# Stadia.StamenWatercolor # water (needs API)
# OpenTopoMap # like a paper map with labels
# OpenStreetMap # same as openstreetmap.org


tiles <- get_tiles(bbox, provider = "Stadia.StamenTerrainBackground", apikey = "b0aa393e-2588-49b9-b517-afe7f775b1f9", zoom = 10)




# OWN WORK - Stadia.StamenTerrainBackground ##

# Define bounding box
bbox <- st_bbox(c(
  xmin = -107.003030,
  ymin = 39.034246,
  xmax = -106.647347,
  ymax = 39.268537
), crs = st_crs(4326)) %>%  
  st_as_sfc() %>%  
  st_sf() # turns it into simple features object


# Download the elevation raster & convert it to a format terra can use
# Rast function converts from raster layer to a spatial raster - newer file format used by terra for eg. resampling
# Final resolution of render depends on resolution fo the "z" arguments ex: (z=11). z=14 is highest
elev_spat <- get_elev_raster(bbox, z = 11, clip = "bbox",) %>% rast 



# update this line when you want to change the map provider
tiles <- get_tiles(bbox, provider = "Stadia.StamenTerrainBackground", apikey = "b0aa393e-2588-49b9-b517-afe7f775b1f9", zoom = 10)

View(tiles)


# Check the download
terra::plotRGB(tiles)


# Align, crop and resample using Terra


# Align tiles w/ elevation (gluing maptile onto the elev data)
tiles_aligned <-  tiles %>% 
  project(crs(elev_spat))

# Crop elevation to match the tile extent exactly
elev_spat <-  crop(elev_spat, tiles_aligned)


# Resample the tiles ot cropped elevation raster
# Make sure the elevation data & map tiles have same # rows/col
tiles_aligned <- resample(tiles_aligned, elev_spat, method = "bilinear")


# Convert tile image to RGB
img_array <-  as.array(tiles_aligned) / 255
# converting from raster to a 3-band array
# rescale into values b/w 0 & 1, which Rayshader expects

#Turn elev raster into a matrix
elev_matrix <- raster_to_matrix(elev_spat)


# Make a hillshade using Rayshader

hillshade <- sphere_shade(elev_matrix, texture = "desert")

# different textures
hillshade <- sphere_shade(elev_matrix, texture = "bw")



overlay <- add_overlay(hillshade, img_array, alphalayer = 0.9)


# plot 3D
plot_3d(overlay, heightmap = elev_matrix, zscale = 10, windowsize = 1200)






# OWN WORK -  OpenTopoMap ##

# Define bounding box
bbox <- st_bbox(c(
  xmin = -107.003030,
  ymin = 39.034246,
  xmax = -106.647347,
  ymax = 39.268537
), crs = st_crs(4326)) %>%  
  st_as_sfc() %>%  
  st_sf() # turns it into simple features object


# Download the elevation raster & convert it to a format terra can use
# Rast function converts from raster layer to a spatial raster - newer file format used by terra for eg. resampling
# Final resolution of render depends on resolution fo the "z" arguments ex: (z=11). z=14 is highest
elev_spat <- get_elev_raster(bbox, z = 11, clip = "bbox",) %>% rast 



# update this line when you want to change the map provider
tiles <- get_tiles(bbox, provider = "OpenTopoMap", apikey = "b0aa393e-2588-49b9-b517-afe7f775b1f9", zoom = 10)

View(tiles)


# Check the download
terra::plotRGB(tiles)


# Align, crop and resample using Terra


# Align tiles w/ elevation (gluing maptile onto the elev data)
tiles_aligned <-  tiles %>% 
  project(crs(elev_spat))

# Crop elevation to match the tile extent exactly
elev_spat <-  crop(elev_spat, tiles_aligned)


# Resample the tiles ot cropped elevation raster
# Make sure the elevation data & map tiles have same # rows/col
tiles_aligned <- resample(tiles_aligned, elev_spat, method = "bilinear")


# Convert tile image to RGB
img_array <-  as.array(tiles_aligned) / 255
# converting from raster to a 3-band array
# rescale into values b/w 0 & 1, which Rayshader expects

#Turn elev raster into a matrix
elev_matrix <- raster_to_matrix(elev_spat)


# Make a hillshade using Rayshader

hillshade <- sphere_shade(elev_matrix, texture = "desert")

# different textures
hillshade <- sphere_shade(elev_matrix, texture = "bw")



overlay <- add_overlay(hillshade, img_array, alphalayer = 0.9)


# plot 3D
plot_3d(overlay, heightmap = elev_matrix, zscale = 10, windowsize = 1200)

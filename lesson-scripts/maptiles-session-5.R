# load libraries
library(sf)
library(terra)
library(elevatr)
library(maptiles)
library(rayshader)
library(magick)

install.packages("maptiles")
install.packages("magick")



# define bounding box (as usual)

bbox <- st_bbox(c(
  xmin = -107.003030,
  ymin = 39.034246,
  xmax = -106.647347,
  ymax = 39.268537
), crs = st_crs(4326)) %>%  
  st_as_sfc() %>%  
  st_sf()


# KEY: bbox list coords in this order: 
-107.003030,39.034246,-106.647347,39.268537
# West,    South,     East,     North
# xmin,    ymin,      xmax,     ymax                            


# download the elevation raster AND convert it to a format that terra can read

elev_spat <- get_elev_raster(bbox, z = 11, clip = "bbox",) %>%  rast
# the "rast" function converts from raster layer to a *spatial raster*
# newer format used by terra for eg. resampling
# final resolution of the render depends on the resolution of the "z" argument here
# z = 14 appears to be the upper limit

# Download satellite data
 
tiles <- get_tiles(bbox, provider = "Esri.WorldImagery", zoom = 11)
# "get_tiles" is a maptiles function to retrieve maptiles from a remote server
# doesn't always show progress bar - wait for the object to appear in the environment
# we'll use these tiles instead of any textures eg "desert"
# details for most providers appears to go up to about 17
# limited by the resolution of the elevation data

# check the download
terra::plotRGB(tiles)

# Align, crop and resample using Terra

# Align tiles with the elevation (gluing the maptile onto the elev data)
tiles_aligned <- tiles %>% 
  project(crs(elev_spat))

# Crop elevation to match the tile extent exactly
elev_spat <- crop(elev_spat, tiles_aligned)

# Resample the tiles to cropped elevation raster 
tiles_aligned <- resample(tiles_aligned, elev_spat, method ="bilinear")
# making sure the elev data and the maptiles have the same number of rows and columns

# Convert tile image to an RGB
img_array <- as.array(tiles_aligned) / 255
# converting from raster to a 3-band array
# rescale into values between 0 and 1, which Rayshader expects

# turn elev raster into a matrix

elev_matrix <- raster_to_matrix(elev_spat)

# make a hillshade using Rayshader

hillshade <- sphere_shade(elev_matrix, texture = "desert")

overlay <- add_overlay(hillshade, img_array, alphalayer = 0.9)

# plot_3d

plot_3d(overlay, heightmap = elev_matrix, zscale = 10, windowsize = 1200)



# Experimenting with different tile providers

# check the list under
maptiles::get_providers()

# A good shortlist
Esri.WorldImagery # photographic
Stadia.StamenWatercolor #water (needs API)
OpenTopoMap # like a paper map with labels
OpenStreetMap # same as openstreetmap.org

tiles <- get_tiles(bbox, provider = "Stadia.StamenTerrainBackground", apikey = "b0aa393e-2588-49b9-b517-afe7f775b1f9", zoom = 9)










library(sf)
library(terra)
library(maptiles)
library(elevatr)
library(rayshader)
library(dplyr)
install.packages("viridis")
library(viridis)  # for color()
install.packages("scales")
library(scales) # for rescaling

# Bbox
bbox <- st_bbox(c(
  xmin = 114.071533, ymin = 22.137743,
  xmax = 114.428589, ymax = 22.434453
), crs = st_crs(4326))  %>%  
  st_as_sfc()  %>%  
  st_sf()

# Get elevation raster
elev_spat <- get_elev_raster(bbox, z = 12, clip = "bbox") %>%  rast()

# Get map tiles
tiles <- get_tiles(bbox, provider = "Esri.WorldImagery", zoom = 11)

# Prepare the maptiles for Rayshader
tiles_aligned <- tiles %>%  project(crs(elev_spat))  %>%  resample(elev_spat)
elev_spat <- crop(elev_spat, tiles_aligned)
img_array <- as.array(tiles_aligned) / 255 # prep for Rayshader


# Turn maptiles into matrix
elev_matrix <- raster_to_matrix(elev_spat)

# Creat shaded elevation overlay
overlay <- add_overlay(sphere_shade(elev_matrix, texture = "desert"), img_array, alphalayer = 0.9)

### POPULATION DATA SECTION ###

# load a pop dataset from https://hub.worldpop.org/

pop_rast <- rast("tiff/HK_pop_2020.tif")

# Project, crop and resample the pop data (same process as with maptiles)
pop_resampled <- pop_rast %>% project(elev_spat) %>% crop(elev_spat) %>% resample(elev_spat)


# Turn pop data from raster to dataframe (ie. a table)
pop_df <- as.data.frame(pop_resampled, xy = TRUE)
# xy=TRUE formats the dataframe as if they were coordinates

# rename 3rd column of data frame to "pop"
names(pop_df)[3] <- "pop"
# remove rows where values are zero or missing
pop_df <- pop_df %>% filter(pop > 0)
# this is for processing speed and to only plot positive values

# Add elevation data to the table by extracting from the original raster
pop_df$elev <- terra::extract(elev_spat, pop_df[, c("x", "y")])[,1]
# terra::extract "rips" data out of a raster for numeric use and places it into a new object

# assign colors to pop values (viridis is color blind friendly)
pop_df$color <- viridis(n = nrow(pop_df))[
  as.integer(rescale(log1p(pop_df$pop), to = c(1, nrow(pop_df))))
]
# each row (or square on the map) in the dataset gets its own color
# the rescale maps colors onto values
# the log transform smooths the data

# plot the elev data & maptiles first- and keep RGL window open! 
plot_3d(
  overlay, heightmap = elev_matrix, zscale = 10,
  windowsize = c(1200, 1200), fov = 0, theta = 135, phi = 45
)

# then render the points in real time with the window open
render_points(
  extent = terra::ext(elev_spat),
  heightmap = elev_matrix,
  lat = pop_df$y,
  long = pop_df$x,
  altitude = NULL,      # sits directly on elevation
  color = pop_df$color,
  size = 4,
  zscale = 10
)



















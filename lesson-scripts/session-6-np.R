#Session 6

# Download new dataset, convert it to right format, and then superimpose it onto a map

#install packages
install.packages("sf")
install.packages("terra")
install.packages("maptiles")
install.packages("elevatr")
install.packages("rayshader")
install.packages("dplyr")
install.packages("viridis")
install.packages("scales")
install.packages("rgl")

library(sf)
library(terra)
library(maptiles)
library(elevatr)
library(rayshader)
library(dplyr)
library(viridis)
library(scales)
library(rgl)



# Bbox
bbox <- st_bbox(c(
  xmin = -74.462507, ymin = 17.972549,
  xmax = -71.710221, ymax = 19.968479
), crs = st_crs(4326))  %>%  
  st_as_sfc()  %>%  
  st_sf()


# Get elevation raster
elev_spat <- get_elev_raster(bbox, z = 10, clip = "bbox") %>%  rast()

# Get map tiles
tiles <-  get_tiles(bbox, provider = "Esri.WorldImagery", zoom = 11)

# Prepare the maptiles for Rayshader
tiles_aligned <-  tiles %>% project(crs(elev_spat)) %>%  resample(elev_spat)  # tiles are being projected on top of each other
elev_spat <-  crop(elev_spat, tiles_aligned)
img_array <-  as.array(tiles_aligned) / 255  # prep for Rayshader

# Turn maptiles into matrix
elev_matrix <-  raster_to_matrix(elev_spat)
View(elev_matrix)

# Create shaded elevation overlay
overlay <- add_overlay(sphere_shade(elev_matrix, texture = "desert"), img_array, alphalayer = 0.9)



### POPULATION DATA SECTION ###

# load a pop daatset from https://hub.worldpop.org/

pop_rast <- rast("tiff/hti_ppp_2020.tif")
View(pop_rast)


# Project, crop and resample the pop data (same process as with maptiles)
pop_resampled <- pop_rast %>% project(elev_spat) %>% crop(elev_spat) %>% resample(elev_spat)


# Turn pop data from raster to dataframe (i.e table)
# xy=TRUE formats dataframe as if they were coordinates
pop_df <-  as.data.frame(pop_resampled, xy = TRUE)
View(pop_df) # X/y columns became coords - so at this coord, there is this # of ppl


# Rename 3rd col of dataframe to "pop"
names(pop_df)[3] <- "People-per-grid 2020"

# Remove rows where values are zero or missing
# THIS CODE DOES NOT WORK - SAYS POP DOES NOT EXIST
pop_df <- pop_df %>% filter(pop > 0)
# this is for processing speed and to only plot positive values


# Add elevation data to the table by extracting from the original raster
# terra::extract "rips data out of a raster for numeric use and places it into a new object
# Creates new column in pop_df called elev - elev means how high that particular coord is
pop_df$elev <-  terra::extract(elev_spat, pop_df[, c("x", "y")])[,1]


# Assign colors to pop values (viridis is color blind friendly) - THIS DOES NOT WORK
pop_df$color <- viridis(n = nrow(pop_df))[
  as.integer(rescale(log1p(pop_df$pop), to = c(1, nrow(pop_df))))
]
# each row (or square on the map) in the dataset gets its own color
# the rescale maps colors onto values
# the log transform smooths the data


# Plot the elev data & maptiles first- and keep RGL window open! 
# Big file, lower orig z in the code so that it runs faster
plot_3d(
  overlay, heightmap = elev_matrix, zscale = 10,
  windowsize = c(1200, 1200), fov = 0, theta = 135, phi = 45
)


# Then render the points in real time w/ window open
# Map rendered w/ show pop density based on color
render_points(
  extent = terra::ext(elev_spat),
  heightmap = elev_matrix,
  lat = pop_df$y,
  long = pop_df$x,
  altitude = NULL,      # sits directly on elevation
  color = viridis(3),
  size = 4,
  zscale = 10
)

render_snapshot(filename = "3d_map_haiti.png", clear = FALSE)

render_snapshot(title_text = "Haiti", 
                title_color = "white", title_bar_color = "lightgreen", title_bar_alpha = 0.2,
                vignette = TRUE, title_offset=c(150,20),
                title_font = "Arial", title_position = "north", webshot = TRUE)



render_movie(
  filename = "3d_map_haiti.gif",
  type = "orbit",
  frames = 90,          # Fewer frames (e.g., 90 vs. 180)
  fps = 20,             # Lower FPS (e.g., 20 vs. 30)
  phi = 45,
  zoom = 0.6,
  width = 600,          # Lower width
  height = 600, 
  title_text = "3D Map with Overlay and Points"
)



# png("render_with_points.png", width = 9000, height = 9000, res = 800)
# Save the render as PNG
# render_snapshot(filename = "render_with_points.png", clear = FALSE)


render_movie("haiti-pop.gif")

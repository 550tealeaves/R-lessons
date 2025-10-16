# Detailed resolution: use Bbox finder: www.bboxfinder.com
# for this script, all elevation is in meters 

#-74.462507,17.972549,-71.710221,19.968479  (W, S, E, N)

install.packages("elevatr")
install.packages("sf")
install.packages("rayshader")

library(rayshader)
library(elevatr)
library(sf)

#crs is argument for defining coordinate reference system. There are several 
# CRS - EPSG: 4326 - has equator and prime meridian

# st_bbox returns a simple bounding box defined by coordinates
# st_as_sfc converts bbox to simple features geometry  
#st_sf help converts it into a data-frame-like object
bbox <- st_bbox(c(xmin = -74.462507, xmax =-71.710221, ymin = 17.972549, ymax = 19.968479), crs = st_crs(4326)) %>%
  st_as_sfc() %>% 
  st_sf()


# xmin = West
# xmax = East
# ymin = South
# ymax = North



# Download the raster data within the bbox
# get_elev_raster - elevatr function that retrieves rster data from AWS & Open data?
# z - level of detail to download - can start it at 1 or 2 to make sure you are seeing the right thing
# clip - clips elevation level at the bbox 

haiti_raster <- get_elev_raster(bbox, z = 8, clip = "bbox")

# Convert raster to matrix
haiti_matrix <-  raster_to_matrix(haiti_raster)

dim(haiti_matrix)

# Args helps troubleshoot - tell you what arguments you need
args(geom_line)


# PLOT W/ WATER & CREATE AS AN OBJECT
haiti_shade <- (
  haiti_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10))



# PLOT MAP
plot_map(haiti_shade)


# DEFINE THE WATER
water_level <- 470
water_mask <- haiti_matrix < water_level
water_mask <- apply(water_mask, 2, rev) # do the reverse


haiti_water <- (
  haiti_matrix %>% 
    sphere_shade(texture = "desert", zscale = 12) %>% 
    add_water(water_mask, color="desert"))

plot_map(haiti_water)


# If you change the z level (resolution) then only re-run the processing lines (don't have to rerun the haiti_matrix assigned line)


# PLOT 3D
plot_3d(
  heightmap = haiti_matrix,
  hillshade = haiti_water,
  zscale = 12,
  water = TRUE,
  watercolor = "royalblue",
  solid = TRUE
)

# Title chart - this gives error message
render_label(heightmap = haiti_matrix, text = "Haiti", dashed = TRUE)

render_compass()

# add scalebar - might not need
render_scalebar(limits=c(
  round(dim(haiti_matrix)[2]*attr(haiti_matrix, 'resolution')/1000,1)),
  label_unit = 'km')

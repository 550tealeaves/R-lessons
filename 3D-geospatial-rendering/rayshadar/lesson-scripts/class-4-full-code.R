# For detailed resolution, use Bbox: https://bboxfinder.com
# for Bbox, since the elevation units are in meters, zscale = 1 is accurate

# HIGH RES  
library(rayshader)
library(elevatr)
library(sf)

# st_bbox returns a simple bounding box defined by coordinates
bbox <- st_bbox(c(xmin = 2.3, xmax = 3.7, ymin = 39.1, ymax = 40.2), crs = st_crs(4326)) %>% st_as_sfc() %>%  st_sf()
# crs=st_crs(4326) sets the coordinate reference system to EPSG:4326 - origin is the equator and prime meridian
# st_as_sfc converts the bounding box to simple features geometry (a polygon)
# st_sf() converts it into a "data-frame-like" object


# xmin = West
# xmax = East
# ymin = South
# ymax = North

#bbox list coords in this order: West, South, East, North

# Download raster data within the bbox
mallorca_raster <- get_elev_raster(bbox, z = 8, clip = "bbox")
# get_elev_raster is an elevatr function that retrieves raster data from AWS terrain tiles or Open Topography


# Convert raster data to matrix
hi_mallorca_matrix <- raster_to_matrix(mallorca_raster)

# Check size of matrix as needed
dim(hi_mallorca_matrix)

# Plot with water and create as object
  # max_darken = lower limit darkening. 0= black, 1= no effect
hi_final_shade <- (
  hi_mallorca_matrix %>%
    sphere_shade(texture = "desert", zscale = 10) %>%
    add_shadow(ray_shade(hi_mallorca_matrix, zscale = 10), max_darken =  0.5) %>%
    add_shadow(ambient_shade(hi_mallorca_matrix, zscale = 10), max_darken = 0.3) 
)

# render the map
plot_map(hi_final_shade)



# WATER 


# Define the water level in meters
water_level <- 1

# Define where presence of water will be "true"
water_mask <- hi_mallorca_matrix < water_level

# Flip horizontally
water_mask <- apply(water_mask, 2, rev)  # flip for rayshader

mall_water <- (
hi_mallorca_matrix %>%
  sphere_shade(texture = "imhof4", zscale = 10) %>%
  add_water(water_mask, color = "imhof3") 
 )



# plot the map with water
plot_map(mall_water)

# Add more layers of shading

hi_water_final_shade <- (
  hi_mallorca_matrix %>%
    sphere_shade(texture = "desert", zscale = 10) %>%
    add_shadow(ray_shade(hi_mallorca_matrix, zscale = 10, lambert = TRUE), 0.4) %>%
    add_shadow(ambient_shade(hi_mallorca_matrix, zscale = 10), 0.3) %>%
    add_water(water_mask, color = "imhof3") %>%
    add_overlay(
      sphere_shade(hi_mallorca_matrix, texture = "desert", zscale = 10, sunangle = 90),
      alphalayer = 0.2
    )
)

# plot the map with more shading

plot_map(hi_water_final_shade)


# EXPORT AS HIGH RES 

png("hi_water_mallorca_2d_highres.png", width = 9000, height = 9000, res = 800)
plot_map(hi_water_final_shade)
dev.off()



# 3D PLOT of final high-resolution shaded terrain
plot_3d(
  heightmap = hi_mallorca_matrix,
  hillshade = hi_water_final_shade,
  zscale = 40,
  water = TRUE,
  watercolor = "lightblue",
  wateralpha = 0.75,
  waterdepth = 0,
  solid = TRUE,
  soliddepth = -50,
  shadow = TRUE
)




# Quick snapshot (lower quality, fast)
render_snapshot("hi_mallorca_3d_preview.png", clear = TRUE)

render_highquality(
  filename = "hi_mallorca_3d_highquality.png",
  samples = 400,
  width = 3000,
  height = 3000,
  lightdirection = 315,
  lightaltitude = 45,
  interactive = FALSE
)



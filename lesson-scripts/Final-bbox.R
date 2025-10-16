# Detailed resolution: use Bbox finder: www.bboxfinder.com
# for this script, all elevation is in meters 

#-74.462507,17.972549,-71.710221,19.968479  (W, S, E, N)

install.packages("elevatr")
install.packages("sf")
install.packages("rayshader")
install.packages("gifski")


library(rayshader)
library(elevatr)
library(sf)
library(gifski)

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

# Args helps troubleshoot - tell you what arguments you need - this code does not work
args(geom_line)


# PLOT W/ WATER & CREATE AS AN OBJECT
haiti_shade <- (
  haiti_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10))



# PLOT MAP
plot_map(haiti_shade)


# DEFINE THE WATER
# In original water level of 0, top right corner of map is pixelated - can increase the water level a few meters
water_level <- 1
water_mask <- haiti_matrix < water_level
water_mask <- apply(water_mask, 2, rev) # do the reverse


haiti_water <- (
  haiti_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10) %>% 
    add_water(water_mask, color="desert"))

plot_map(haiti_water)


# EXPORT AS HIGH RES

png("haiti.png", width = 9000, height = 9000, res = 800)
save_png(hillshade = haiti_water, filename = "haiti.png")




# If you change the z level (resolution) then only re-run the processing lines (don't have to rerun the haiti_matrix assigned line)


# PLOT 3D
plot_3d(
  heightmap = haiti_matrix,
  hillshade = haiti_water,
  zscale = 12,
  water = TRUE,
  watercolor = "royalblue",
  solid = TRUE,
  # waterlinecolor = "black",
  # waterlinealpha = 0.5,
  # linewidth = 3
)

render_compass()

# render scalebar - use the distance of the land as the limits (included a middle limit)
render_scalebar(limits=c(0,227,455), label_unit = "km", position = "N",
                color_first = "violet", color_second = "gold")


# Render camera and snapshot
render_camera(zoom=0.7)
render_snapshot(title_text = "Haiti", 
                title_color = "white", title_bar_color = "lightgreen", title_bar_alpha = 0.2,
                vignette = TRUE, title_offset=c(150,20),
                title_font = "Arial", title_position = "north", webshot = TRUE)


# Create a gif
render_movie("haiti.gif")




# Render high quality - reduce the w/h to 1200 b/c 3000 makes the reder very slow

render_highquality(width = 1600,
                   height = 1600,lightaltitude = 45, lightdirection = 100)









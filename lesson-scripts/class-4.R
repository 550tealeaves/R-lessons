# Detailed resolution: use Bbox finder: www.bboxfinder.com
# for this script, all elevation is in meters 

#2.028847,38.936853,3.685036,40.146214  (W, S, E, N)

install.packages("elevatr")
install.packages("sf")

library(rayshader)
library(elevatr)
library(sf)

#crs is argument for defining coordinate reference system. There are several 
# CRS - EPSG: 4326 - has equator and prime meridian

# st_bbox returns a simple bounding box defined by coordinates
# st_as_sfc converts bbox to simple features geometry  
#st_sf help converts it into a data-frame-like object
bbox <- st_bbox(c(xmin = 2.028847, xmax =3.685036, ymin = 38.936853, ymax = 40.146214), crs = st_crs(4326)) %>%
  st_as_sfc() %>% 
  st_sf()


# xmin = West
# xmax = East
# ymin = South
# ymax = North

# bbox lists coordinates in this order: West, South, East, North
#2.028847,38.936853,3.685036,40.146214


# Download the raster data within the bbox
# get_elev_raster - elevatr function that retrieves rster data from AWS & Open data?
# z - level of detail to download - can start it at 1 or 2 to make sure you are seeing the right thing
# clip - clips elevation level at the bbox 

mallorca_raster <- get_elev_raster(bbox, z = 8, clip = "bbox")

# Convert raster to matrix
mallorca_matrix <-  raster_to_matrix(mallorca_raster)

dim(mallorca_matrix)

# Args helps troubleshoot - tell you what arguments you need
args(geom_line)


# PLOT W/ WATER & CREATE AS AN OBJECT
mallorca_shade <- (
  mallorca_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10))



# PLOT MAP
plot_map(mallorca_shade)


# DEFINE THE WATER
water_level <- 0
water_mask <- mallorca_matrix < water_level
water_mask <- apply(water_mask, 2, rev) # do the reverse


mallorca_water <- (
  mallorca_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10) %>% 
    add_water(water_mask, color="desert"))

plot_map(mallorca_water)


# If you change the z level (resolution) then only re-run the processing lines (don't have to rerun the mallorca_matrix assigned line)


# PLOT 3D
plot_3d(
  heightmap = mallorca_matrix,
  hillshade = mallorca_water,
  zscale = 10,
  water = TRUE,
  watercolor = "pink",
  solid = TRUE
)



# OWN PLOT - Mount Everest
86.824127,27.639284,87.705780,28.244500


bbox2 <- st_bbox(c(xmin = 86.824127, xmax =87.705780, ymin = 27.639284, ymax = 28.244500), crs = st_crs(4326)) %>%
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

nepal_raster <- get_elev_raster(bbox2, z = 8, clip = "bbox")

nepal_matrix <- raster_to_matrix(nepal_raster)

dim(nepal_matrix)


# PLOT W/ WATER & CREATE AS AN OBJECT
nepal_shade <- (
  nepal_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10))


# PLOT MAP
plot_map(nepal_shade)


# DEFINE THE WATER - this is for water that is **at sea level**
water_level <- 0
water_mask <- nepal_matrix < water_level
water_mask <- apply(water_mask, 2, rev) # do the reverse


nepal_water <- (
  nepal_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10) %>% 
    add_water(water_mask, color="desert"))

plot_map(nepal_water)


# PLOT 3D
plot_3d(
  heightmap = nepal_matrix,
  hillshade = nepal_water,
  zscale = 10,
  water = TRUE,
  watercolor = "lightgreen",
  solid = TRUE
)






# OWN MAP - MANAUS
-60.139160,-3.329065,-59.779358,-2.987729 #(W, S, E, N)

bbox3 <- st_bbox(c(xmin = -60.139160, xmax = -59.779358, ymin = -3.329065, ymax = -2.987729), crs = st_crs(4326)) %>%
  st_as_sfc() %>% 
  st_sf()


# xmin = West
# xmax = East
# ymin = South
# ymax = North


manaus_raster <- get_elev_raster(bbox3, z = 8, clip = "bbox")

manaus_matrix <- raster_to_matrix(manaus_raster)

dim(manaus_matrix)


# PLOT W/ WATER & CREATE AS AN OBJECT
manaus_shade <- (
  manaus_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10))


# PLOT MAP
plot_map(manaus_shade)


# DEFINE THE WATER **at sea level - default is 0, but if the river is NOT at sea level, then you have to Google the name of the body of water and its level and set either a min or a max 
water_level <- 17.59
water_mask <- manaus_matrix < water_level
water_mask <- apply(water_mask, 2, rev) # do the reverse


manaus_water <- (
  manaus_matrix %>% 
    sphere_shade(texture = "desert", zscale = 10) %>% 
    add_water(water_mask, color="desert"))

plot_map(manaus_water)


# PLOT 3D
plot_3d(
  heightmap = manaus_matrix,
  hillshade = manaus_water,
  zscale = 10,
  water = TRUE,
  watercolor = "lightblue",
  solid = TRUE
)


library(dplyr)


##### GG PLOT #####

pop_size <- read.csv("data/jp_pop.csv")
pop_size <-  pop_size %>% 
  mutate(
    Year = as.integer(gsub("[^0-"))
  )
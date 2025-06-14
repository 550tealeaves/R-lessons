# Rayshadar Intro

# Install packages
install.packages("devtools")
install.packages("tidyverse")
install.packages("rgl")
install.packages("rayshader")
install.packages("terra")


# Activate the packages to be used in R w/ library() function
library(devtools)
library(tidyverse)
library(rgl)
library(rayshader)
library(terra)

# upload the raster elevation data (tif) file using terra package - store in working directory (folder), which is called the tiff folder
# Use function rast to upload the data
elev_raster <- terra::rast("tiff/dem_01.tif")

# plot the rasta
plot(elev_raster)


# Create matrix from raster image using a Rayshader function, raster_to_matrix
# produces a numeric representation for a a piece of terrain (gives the dimensions)
elmat <- raster_to_matrix(elev_raster) #dimensions are 505 rows by 500 col or vice versa

# dim() will provide the dimensions
dim(elmat)

head(elmat)
tail(elmat)


# VISULIZATIONS
# Mapping - use tidyverse pipe (%>%) - shortcut is ctrl + shift + m

# this code
elmat %>% 
  plot_map()

# is the same as this code
plot_map(elmat)


# Visualization using sphere shading

# you have to define the texture and what colors will be in rendering

# take elevation matrix, then shading using color palette desert & then plotting it
elmat %>% 
  sphere_shade(texture = "desert") %>% 
  plot_map()

# different textures for rayshader: imhof1, imhof2, imhof3, imhof4, bw, desert, and unicorn
# add the textures to the texture = "" 
# Named after Eduard Imhoff, geographer that invented relief shading

elmat %>% 
  sphere_shade(texture = "imhof1") %>% 
  plot_map()


# Shift the sun direction - use argument sunangle & put in anything from 0-360
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  plot_map()


# Add water using "detect_water" argument w/in the add_water() function - scans data for uniform values
# Water appears as flat 
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  plot_map()


# different code for water - can add color 
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "purple") %>% 
  plot_map()


# different code for water - can add different texture
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "imhof2") %>% 
  plot_map()

# different code for water - can add different texture
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "unicorn") %>% 
  plot_map()


# Raytraced layer from the same direction as the sun
# Raytracing simulates:reflection, refraction, and soft shadows - use add_shadow() function & ray_shade argument
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  add_shadow(ray_shade(elmat), 0.1) %>% 
  plot_map()


# Ambient occlusion layer - atmospheric scattering - use the ambient_shade argument w/in the add_shadow()
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  add_shadow(ray_shade(elmat), 0.3) %>% 
  add_shadow(ambient_shade(elmat), 0.4) %>% 
  plot_map()


# Open an rgl window using open3d() function
# will open a little box to see 3D rendering
open3d()


# plot 3D - change the plot_map() function to plot_3d() & add arguments like the 
## zscale - which tell you how flat or exaggerated the elevation will be
## theta - rotational view - turns model
## zoom - how close do you start in
## phi - viewing angle
## fov - field of view
## windowsize - screensize
## baseshape - certain shape (circle, hex, rectangle)
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  add_shadow(ray_shade(elmat), 0.7) %>% 
  add_shadow(ambient_shade(elmat), 0.4) %>% 
  plot_3d(elmat, zscale = 10, fov = 0, theta = 1, zoom = 0.75, phi = 45, windowsize = c(1000, 800), baseshape = "circle")


## baseshape - of hex
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  add_shadow(ray_shade(elmat), 0.7) %>% 
  add_shadow(ambient_shade(elmat), 0.4) %>% 
  plot_3d(elmat, zscale = 10, fov = 0, theta = 1, zoom = 0.75, phi = 45, windowsize = c(1000, 800), baseshape = "hex")


## baseshape - of rectangle
elmat %>% 
  sphere_shade(texture = "desert", sunangle = 90) %>% 
  add_water(detect_water(elmat), color = "desert") %>% 
  add_shadow(ray_shade(elmat), 0.7) %>% 
  add_shadow(ambient_shade(elmat), 0.4) %>% 
  plot_3d(elmat, zscale = 10, fov = 0, theta = 1, zoom = 0.75, phi = 45, windowsize = c(1000, 800), baseshape = "rectangle")




# Turn it into a GIF of mp4

#GIFs
#install package
install.packages("gifski")
library(gifski)

# Use render_movie() function and give the file a name & .gif
render_movie("elmat.gif")



# mp4
install.packages("av")
library(av)

# Use render_movie() function and name file & give it .mp4
render_movie("elmat.mp4")


# Save as 3D stereolithography file or .stl - use save_3dprint() function with maxwidth & unit as arguments
# For windows, download a separate 3D viewer to open stl files - https://apps.microsoft.com/detail/9nblggh42ths?hl=en-US&gl=US
save_3dprint("elmat.stl", maxwidth = 150, unit = "mm")

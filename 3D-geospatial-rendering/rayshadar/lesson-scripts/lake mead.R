# the elevation data is in meters! 

# Low to medium resolution terrain (or large landmasses)

install.packages("rgl")
install.packages("rayshader")


library(rgl)
library(rayshader)

#a new version of Rayshader includes an argument called “water_attenuation”.

# To access this argument, you need to update Rayshader from version 0.37.3 hosted on the CRAN Repository to version 0.38.11 hosted on Tyler Morgan Wall’s Github.
# Run below 3 lines and then enter 3 (none) in the console when prompted. Console will run and then stop at DONE when complete. 

install.packages("devtools")
library(devtools) 
install_github("tylermorganwall/rayshader", force= TRUE) #force=TRUE tells R to get latest version


mead <- raster_to_matrix("tiff/mead.tiff")

dim(mead)

#185 x 103

# Plot with the land only

# different textures for rayshader: imhof1, imhof2, imhof3, imhof4, bw, desert, and unicorn

mead %>% 
  sphere_shade(texture = "imhof4") %>% 
  plot_map()

# Add water using the conventional method

mead %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(detect_water(mead), color = "desert") %>% 
  plot_map()

# problem is that the topography is too detailed! 
# it shows some of the bathymetry!

# define the height of Lake Mead water
water_level <- 413

# define according to the height
water_mask <- mead < water_level
# reverse so that it fits with the map
water_level <- apply(water_mask, 2, rev)


mead %>% 
  sphere_shade(texture="bw") %>% 
  add_water(water_level, color= "desert") %>% 
  plot_map()

# notice that the water height is arbitrary- it's up to us to define and clarify
# if there are changes



# plot 3d with water and create as an object

#CODE BELOW NOT WORKING
final_shade <- (
  mead %>% 
    sphere_shade(texture = "desert") %>% 
    add_shadow(ray_shade(mead, zscale = 10), max_darken = 0.4) %>% 
    add_water(water_level, color= "desert") 
)

final_shade %>% 
  plot_3d(heightmap = mead, zscale= 70)


# change the water to be transluscent(?) 

mead %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = mead, zscale = 70,
          water= TRUE,
          waterdepth = water_level,
          watercolor = "lightblue",
          windowsize = 1000)

# render the 3d window as a 2d image
render_snapshot()

# render highquality

render_highquality(lightaltitude = 5, lightdirection = 100)
















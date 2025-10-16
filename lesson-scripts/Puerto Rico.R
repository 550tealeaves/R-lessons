# Puerto Rico!

pr <- raster_to_matrix("tiff/pr.tiff")


pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_map()

# # different textures for rayshader: imhof1, imhof2, imhof3, imhof4, bw, desert, and unicorn

pr %>% 
  sphere_shade(texture = "imhof1") %>% 
  plot_map()

pr %>% 
  sphere_shade(texture = "imhof2") %>% 
  plot_map()

pr %>% 
  sphere_shade(texture = "imhof3") %>% 
  plot_map()

pr %>% 
  sphere_shade(texture = "imhof4") %>% 
  plot_map()

pr %>% 
  sphere_shade(texture = "bw") %>% 
  plot_map()

pr %>% 
  sphere_shade(texture = "unicorn") %>% 
  plot_map()






# add water? will it work?

pr %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(detect_water(pr)) %>% 
  plot_map()


water_pr <- 0
water_mask_pr <- pr < water_pr
water_mask_pr <- apply(water_mask_pr, 2,rev)

pr %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(water_mask_pr, color = "lightblue") %>%
  plot_map()


# try different color for water and diff texture for land
pr %>% 
  sphere_shade(texture = "imhof2") %>% 
  add_water(water_mask_pr, color = "violet") %>%
  plot_map()

# plot 3d first without water
# increase zscale, then the more it narrows and raises (elevation)

pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = pr,
          zscale = 80)

# add water with a arbitrarily defined water level


pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "lightblue",
          windowsize = 1200)

# add lines to show the extent of the water


# increase walteralpha = increases opaqueness
# increase linewidth = increase line thickness around render
pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "lightblue",
          windowsize = 1200,
          waterlinecolor = "black",
          wateralpha = 0.5,
          linewidth = 1)

pr %>% 
  sphere_shade(texture = "bw") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "unicorn",
          windowsize = 1200,
          waterlinecolor = "black",
          wateralpha = 0.5,
          linewidth = 1)

# change the color of the base or remove it entirely!

# solid=FALSE is giving error message
# solidcolor = "black"       solid = FALSE

pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "lightblue",
          windowsize = 1200,
          waterlinecolor = "black",
          wateralpha = 0.5,
          linewidth = 1,
          solidcolor = "black"
          )

# To remove the line, I set waterlinecolor=FALSE

pr %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "lightblue",
          windowsize = 1200,
          waterlinecolor = FALSE,
          wateralpha = 0.5,
          linewidth = 1, 
          solidcolor = "black"
          )


pr %>% 
  sphere_shade(texture = "imhof1") %>% 
  plot_3d(heightmap = pr,
          zscale = 80,
          water= TRUE,
          waterdepth = water_pr,
          watercolor = "darkred",
          windowsize = 1200,
          waterlinecolor = FALSE,
          wateralpha = 0.7,
          linewidth = 1,
          solidcolor = "black")




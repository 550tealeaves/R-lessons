# Create chloropleth map using SHPs and plot_gg

install.packages("tigris")
library(tigris)   # Official tidy Census shapefile package
install.packages("sf")
library(sf)

# Get all counties in NY state
ny <- tigris::counties(state = "NY", cb = TRUE, year = 2022)

# test out data
plot(ny["NAME"])

# plot data using "ALAND" variable (ie. area of the land)
gg_NY = ggplot(ny) +
  geom_sf(aes(fill = ALAND), color = NA) +
  geom_sf(data = ny, fill = NA, color = "black",  size =10) +
  scale_fill_viridis("ALAND") +
  ggtitle("Area of counties in NY") +
  theme_bw()

# plot 2d
plot(gg_NY)


#plot 3d - wait a minute for it to render and display! 
plot_gg(gg_NY, multicore = TRUE, width = 6 ,height=6, fov = 70)



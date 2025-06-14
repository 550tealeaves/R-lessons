library(rayshader)
library(devtools)

# Press 1 in the console for "All"
install_github("h-a-graham/rayvista", dependencies = TRUE, force = TRUE)

library(rayvista)


# Define lat/long as objects
.lat <- 39.880307
.long <- 3.011939


# Create object (pollenca) and use plot_3d_vista function
pollenca <- plot_3d_vista(lat = .lat, long = .long, phi=30, outlier_filter=0.001)

# LIMITATION - bbox is FIXED b/c you are only using 1 point (in center of the render)

# Add a label
render_label(heightmap= pollenca, text='Pollenca, Mallorca', lat = .lat,
             long=.long, extent = attr(pollenca, 'extent'),altitude=600,
             clear_previous = T, zscale = 2)


# Add a compass
render_compass()


# Add a scalebar
render_scalebar(limits=c(
  round(dim(pollenca)[2]*attr(pollenca, 'resolution')/1000,1)),
  label_unit = 'km')


# Will create a small file that doesn't slow down computer
# Use as last resort b/c it is not as much customization

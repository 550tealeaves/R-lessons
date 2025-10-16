library(rayshader)
install.packages("devtools")
devtools::install_github("h-a-graham/rayvista", dependencies=TRUE)
library(rayvista)

.lat <- 39.880307
.long <- 3.011939


# plot and render
pollenca <- plot_3d_vista(lat = .lat, long = .long, phi=30, outlier_filter=0.001)

# add label
render_label(heightmap= pollenca, text='Pollenca, Mallorca', lat = .lat,
             long=.long, extent = attr(pollenca, 'extent'),altitude=600,
             clear_previous = T, zscale = 2)

# add compass
render_compass() 

# add scalebar
render_scalebar(limits=c(
  round(dim(pollenca)[2]*attr(pollenca, 'resolution')/1000,1)),
  label_unit = 'km')

# take snapshot
render_snapshot(clear=TRUE)


# render depth of focus (blur)
render_depth(focus=0.4, focallength = 16, clear=TRUE)

#render highquality
render_highquality(lightdirection = 220, clear=TRUE)





# add labels
library(magick)

#access an image saved in your local directory

poll_hi <- image_read("pollenca_hi.png")


# annotate
title <-  poll_hi %>% 
  image_annotate(
  text = "Pollença, Islas Baleares",
  gravity = "north",    # Top center
  location = "+0+10",   # Adjust up/down
  size = 60,            # Font size
  color = "gray33",      # Text color
  weight = 500,         # Bold text- may not work for all
  font = "Montserrat"        # Choose a nice font- # you can use any font installed on your computer! # google fonts- a "dynamic" font you may need to install the static equivalents
)%>% 
  image_annotate(
    text = "Coordinates:  39.880307 N, 3.011939 E",
    gravity = "north",    # Top center
    location = "+0+120",   # Adjust up/down
    size = 35,            # Font size
    color = "gray33",      # Text color
    weight = 300,         # Bold text- may not work for all
    font = "Montserrat"        # Choose a nice font- # you can use any font installed on your computer! # google fonts- a "dynamic" font you may need to install the static equivalents
  )%>% 
  image_annotate(
    text = "• Population: 17,300",
    gravity = "South",    # Bottom
    location = "-300+100",   # Adjust up/down
    size = 35,            # Font size
    color = "gray33",      # Text color
    weight = 300,         # Bold text- may not work for all
    font = "Montserrat"        # Choose a nice font- # you can use any font installed on your computer! # google fonts- a "dynamic" font you may need to install the static equivalents
  ) %>% 
  image_annotate(
    text = "• Founded: 1229 AD",
    gravity = "South",    # Bottom
    location = "-300+150",   # Adjust up/down
    size = 35,            # Font size
    color = "gray33",      # Text color
    weight = 300,         # Bold text- may not work for all
    font = "Montserrat"        # Choose a nice font- # you can use any font installed on your computer! # google fonts- a "dynamic" font you may need to install the static equivalents
  )%>% 
  print()
                          
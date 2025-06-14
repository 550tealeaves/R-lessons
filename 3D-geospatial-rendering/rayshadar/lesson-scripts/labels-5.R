# Labels for 3d Renderings

# quick preview
render_snapshot()

# save the preview as a PNG
render_snapshot(filename = "Aspen_example.png",
                software_render = TRUE, # doesn't constrain the resolution
                title_text = "Aspen, Colorado", # title
                title_size = 40,
                title_font = "Arial", #font
                title_bar_alpha = 1,
                title_offset = c(60,40),
                vignette = 0.5)

# "blank" rendering
render_snapshot("magick_aspen.png")


library(magick)

img <- image_read("magick_aspen.png")

plot(img)

# annotate

img_w_label <- image_annotate(
  img,
  text = "Aspen, Colorado",
  gravity = "north",
  location = "+0+10",
  size = 60,
  color = "darkgray",
  weight = 300,
  font = "Arial"
)

# "print" the image in the plot window
img_w_label

# add subtitles

Aspen_final <- img_w_label %>% 
    image_annotate(text= "Created with Rayshader and Maptiles",
                   gravity = "north",
                   location = "+0+90",
                   size= 35,
                   color = "darkgray",
                   weight = 300,
                   font = "Arial") %>% 
    image_annotate(text = "Created by Sam", gravity= "south",
                   location = "+0+10", size = 25,
                   weight = 300,
                   font = "Arial",
                   color = "darkgray")


# print final 
Aspen_final





# If error returned on working directory, do Session > Set working directory > Choose directory


pop_size <- read.csv("data/US_pop.csv")

# data is already in "long" format, so no need to convert as TMW did in his tutorial



# clean the data (1959 has "-" and 1960 has "-")

library(dplyr)

pop_size <- pop_size %>%
  mutate(
    Year = as.integer(gsub("[^0-9]", "", Year)),
    Age = ifelse(Age == "110+", 110, Age),
    Age = as.integer(Age)
  ) %>%
  filter(!is.na(Year), !is.na(Age))

# scrap the 110+ lines
pop_size <- pop_size %>%
  filter(Age < 110)


library(ggplot2)
library(scales)

pop_size_final <- ggplot(pop_size, aes(x = Year, y = Age, fill = Total)) + # plug in the 3 vars here
  geom_tile() +
  scale_fill_viridis_c(
    option = "magma", # sets color palette
    trans = "log10", # applies a log scale! 
    labels = label_comma()  # replaces scientific notation
  ) +
  scale_x_continuous(
    breaks = seq(min(pop_size$Year), max(pop_size$Year), by = 10),
    expand = c(0, 0) # this deletes ggplot's padding
  ) +
  scale_y_continuous(
    breaks = seq(0, max(pop_size$Age), by = 10),
    expand = c(0, 0)
  ) +
labs(
    title = "US Population 1947 to Present",
    x = "Year",
    y = "Age",
    fill = "Population"
  )






# plot 2d
plot(pop_size_final)

library(rayshader)

plot_gg(
  pop_size_final,
  multicore = TRUE,
  width = 6,
  height = 6,
  scale = 300,           # adjust to exaggerate or flatten verticals
  sunangle = 90,         # lighting angle
  solid = TRUE,
  shadowcolor = "black",
  windowsize = c(1000, 800)
)

# make the scale more dramatic! 
plot_gg(pop_size_final, scale = 200)  # higher number = more dramatic



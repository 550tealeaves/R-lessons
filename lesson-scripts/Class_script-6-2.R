#zoom in and out using command/ctrl and "+" or "-"


# set working directory

setwd("~/My Drive/🧵 PhD CUNY/🥾Advising Fellow/Good to Great Workshop")


# install packages 

install.packages("ggplot2")
library(ggplot2)

# might be useful- may not use here

install.packages("tidyverse")

library(tidyverse)


# open a comma separated value file

read.csv("lx.csv")

full_dataset <- read.csv("lx.csv")

# sample data

head(full_dataset)

tail(full_dataset)

print(full_dataset)


# set up a plot using ggplot2 - remember to install the package!

ggplot(full_dataset, aes(x= Year))

# add data points to the ggplot - "+" must go on the original line!

ggplot(full_dataset, aes(x= Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) 

# Correct the y axis and add title using "labs"

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
labs(title="Male and Female Life Expectancy in the US, 1933-2023", y = "Life Expectancy" ) 

# Adjust color & add lines

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy" )

# add line 

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy" )


# add percentages on y and finer breaks on x

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  scale_x_continuous(breaks = seq(1930, 2023, 10)) +
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy" )

# add a subtitle, and a shaded area with a caption 

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  scale_x_continuous(breaks = seq(1930, 2023, 10)) +
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, 
           alpha = 0.2, fill = "gray60") +
  
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy", subtitle = "Data Retrieved from the Human Mortality Database", caption = "Shaded area shows the COVID-19 pandemic period")


# adjust text position


ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  scale_x_continuous(breaks = seq(1930, 2023, 10)) +
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, 
           alpha = 0.2, fill = "gray60") +
  
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5, margin = margin(b = 10)),
    plot.subtitle = element_text(margin = margin(b = 10), size = 10, face = "italic", hjust = 0.5),
    plot.caption = element_text(color = "gray40", size = 8),
    axis.text = element_text(color = "gray20"),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) +
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy", subtitle = "Data Retrieved from the Human Mortality Database", caption = "Shaded area shows the COVID-19 pandemic period")


# final tweaks: theme minimal [notice the *order* of theme_minimal and custom theming]

ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  scale_x_continuous(breaks = seq(1930, 2023, 10)) +
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, 
           alpha = 0.2, fill = "gray60") +
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy", subtitle = "Data Retrieved from the Human Mortality Database", 
       caption = "Shaded area shows the COVID-19 pandemic period")+
  
  theme_minimal() +

theme(
  plot.title = element_text(face = "bold", size = 14, hjust = 0.5, margin = margin(b = 10)),
  plot.subtitle = element_text(margin = margin(b = 10), size = 10, face = "italic", hjust = 0.5),
  plot.caption = element_text(color = "gray40", size = 8),
  axis.text = element_text(color = "gray20"),
  plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
) 
  
# BONUS: google fonts

install.packages("showtext")
install.packages("sysfonts")

library(showtext) # Allows you to use custom fonts
library(sysfonts) # Helps you load system fonts or download Google Fonts into R

# list fonts available
sysfonts::font_families()

sysfonts::font_add_google(name = "Montserrat", family = "montserrat") # only need to run this once

# list fonts available
sysfonts::font_families()

showtext::showtext_auto() # tells R to automatically use showtext for all future plots.

# FINAL PLOT: montserrat font, clearer legend, best typeface

lx_plot_final <- ggplot(full_dataset, aes(Year)) +
  geom_point(aes(y = Female, color = "Female"), size = 1) +
  geom_point(aes(y = Male, color = "Male"), size = 1) +
  scale_color_manual(values = c("Female" = "salmon", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color = "Female"), linewidth = 0.5, alpha = 0.5)+
  geom_line(aes(y=Male, color = "Male"), linewidth = 0.5, alpha = 0.5)+
  
  scale_x_continuous(breaks = seq(1930, 2023, 10)) +
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, 
           alpha = 0.2, fill = "gray60") +
  
  labs(title="Male and Female Life Expectancy in the US, 1933-2023",
       y = "Life Expectancy", subtitle = "Data Retrieved from the Human Mortality Database", 
       caption = "Shaded area shows the COVID-19 pandemic period", color = NULL)+
  
  theme_minimal(base_size = 11, base_family = "montserrat") +
  
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5, margin = margin(b = 10)),
    plot.subtitle = element_text(margin = margin(b = 10), size = 10, face = "italic", hjust = 0.5),
    plot.caption = element_text(color = "gray40", size = 8, vjust = -2, hjust = 0.5),
    axis.text = element_text(color = "gray20"),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) 

# plot the final plot
plot(lx_plot_final)








# plot with rayshader - need to change theme to "classic" first!

library(rayshader)

plot_gg(lx_plot_final, width = 5, height = 4, 
        multicore = TRUE, scale = 250, 
        raytrace = FALSE,
        windowsize= c(1000,800))






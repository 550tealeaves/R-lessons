# Another way to set working directory is via code
setwd("~/Documents/folderName")

#install packages
install.packages("ggplot2")
install.packages("tidyverse")

# to attach packages to your working environment, use library(packageName)
# Check the packages section and you will see the check mark next to them
library(ggplot2)
library(tidyverse)

# open a datafile - dataset is on US life expectancy
read.csv("lx.csv")

# save the data as an object in the working environment
full_data <- read.csv("lx.csv")

#  little messy in the console, so use view to create a separate tab of tabular data
view(full_data)

rm(datalx)

# Use head function to get the first 6 rows
head(full_data)

# Use tail function to get the last 6 rows
tail(full_data)

# Use print function to print out full dataset in the console
# NOTE: Not great if this is a very big dataset - better to use head or tail so you don't crash the computer
print(full_data)


# Set up plot w/ ggplot2
# call ggplot - include dataset in the argument first, then aesthetics
ggplot(full_data, aes(x=Year))  #this will show the extent of the data

# Add data pts to the plot
# "+" used to add more things to the ggplot code
# Add the y-axis
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1)


# Add the x-axis
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1)


# Add label to chart 
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy")


# Adjust the color and add the lines
# Use the scale_color_manual to set the color of the values

ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy") +
  scale_color_manual(values=c("Female" = "lightgreen", "Male" = "navy"))


# Add lines 
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy") +
  scale_color_manual(values=c("Female" = "lightgreen", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color="Female"), linewidth=0.5, alpha=0.5) +
  geom_line(aes(y=Male, color="Male"), linewidth=0.5, alpha=0.5)



# Add finer breaks on the axes
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy") +
  scale_color_manual(values=c("Female" = "lightgreen", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color="Female"), linewidth=0.5, alpha=0.5) +
  geom_line(aes(y=Male, color="Male"), linewidth=0.5, alpha=0.5) + 
  
  scale_x_continuous((breaks = seq(1930, 2023, 10))+
  scale_y_continuous(breaks = seq(50, 100, 2)))


# Add a subtitle and a shaded area with a caption
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy", subtitle="Data Retrieved from the Human Mortality Database", caption="Shaded area shows the Covid-19 pandemic") +
  scale_color_manual(values=c("Female" = "lightgreen", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color="Female"), linewidth=0.5, alpha=0.5) +
  geom_line(aes(y=Male, color="Male"), linewidth=0.5, alpha=0.5) + 
  
  scale_x_continuous(breaks = seq(1930, 2023, 10))+
                       scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, alpha=0.5, fill="gray60")


# Add a theme
ggplot(full_data, aes(x=Year)) +
  geom_point(aes(y=Female, color="Female"), size=1) +
  geom_point(aes(y=Male, color="Male"), size=1) + 
  labs (title = "Male & Female US Life Expectancy, 1933-2023", y="Life Expectancy", subtitle="Data Retrieved from the Human Mortality Database", caption="Shaded area shows the Covid-19 pandemic") +
  scale_color_manual(values=c("Female" = "lightgreen", "Male" = "navy")) +
  
  geom_line(aes(y=Female, color="Female"), linewidth=0.5, alpha=0.5) +
  geom_line(aes(y=Male, color="Male"), linewidth=0.5, alpha=0.5) + 
  
  scale_x_continuous(breaks = seq(1930, 2023, 10))+
  scale_y_continuous(breaks = seq(50, 100, 2)) +
  
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, alpha=0.5, fill="gray60") + 
  
  theme_minimal() #removes the gray areas

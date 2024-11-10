# install.packages("remotes")
# remotes::install_github("natalieoshea/workr", build_vignettes = TRUE)
# after you install the packages, comment out the code
library(workr)
run_data_wrangling() #this will open the Data wrangling in R pop-up

# will use spotify data
# R-data frame tibble - tells you how many rows/cols

### TIBBLE ###
# creates opinionated data frames that make working in the tidyverse a little easier
# never changes the type of the inputs (e.g. it never converts strings to factors!), it never changes the names of variables, and it never creates row names.


example_data <- data.frame(a = 1:3, b = letters[1:3], c = Sys.Date() - 1:3)
example_data

# a b          c
# 1 1 a 2024-11-08
# 2 2 b 2024-11-07
# 3 3 c 2024-11-06

as_tibble(example_data)

# # A tibble: 3 × 3
# a b     c         
# <int> <chr> <date>    
#   1     1 a     2024-11-08
# 2     2 b     2024-11-07
# 3     3 c     2024-11-06



# https://r4ds.had.co.nz/tibbles.html - how to use tibbles
# Create new tibble from individual vectors
tibble(x = 1:5, # X-col will run from 1-5 
       y = 1,   # y-col will only have 1's
       z = x^2 + y ) #z-col will have value of x^2 + 1


# # A tibble: 5 × 3
# x     y     z
# <int> <dbl> <dbl>
#   1     1     1     2
# 2     2     1     5
# 3     3     1    10
# 4     4     1    17
# 5     5     1    26



# Tibble can have col names that are not valid R variable names aka non-syntactic names (ex: don't begin w/ letter or have spaces)
# Use backticks on these names to reference the variables

tb <- tibble










as_tibble(iris)

# A tibble: 150 × 5
# Sepal.Length Sepal.Width Petal.Length Petal.Width Species
# <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#   1          5.1         3.5          1.4         0.2 setosa 
# 2          4.9         3            1.4         0.2 setosa 
# 3          4.7         3.2          1.3         0.2 setosa 
# 4          4.6         3.1          1.5         0.2 setosa 
# 5          5           3.6          1.4         0.2 setosa 
# 6          5.4         3.9          1.7         0.4 setosa 
# 7          4.6         3.4          1.4         0.3 setosa 
# 8          5           3.4          1.5         0.2 setosa 
# 9          4.4         2.9          1.4         0.2 setosa 
# 10          4.9         3.1          1.5         0.1 setosa 
# # ℹ 140 more rows
# # ℹ Use `print(n = ...)` to see more rows







# use view to get a good look of the data
# We don't need to use all the rows
# What is your favorite genre of music?
# Even if you plot everything as scatterplot, it doesn't give enough information on the musical preferences
# Data wrangling lets you isolate certain parts of the data 
# select() extracts COLUMNS of a data frame and returns the columns as a new data frame.
### Takes 2 arguments - data frame and the columns we are selecting
select(spotify, genre, energy)
select(spotify, c(genre, energy))
select(spotify, -danceability) #deletes only the col danceability - leaves everything else

# regex = regular expression

# filter() extracts ROWS from a data frame and returns them as a new data frame.
### Combine filter() with logical tests - =, >, <, >=, <=,==, is.na(), !is.na()

# arrange() returns all of the rows of a data frame reordered by the values of a column.
arrange(spotify, energy) #descending value

# summarise() takes a data frame and uses it to calculate a new data frame of summary statistics.
spotify %>% 
  filter(genre == "Rock") %>% 
  summarise(avg_energy = mean(energy))
## # A tibble: 1 × 1
##   avg_energy
##        <dbl>
## 1      0.682

spotify %>% 
  filter(genre == "Rock") %>% 
  summarise(avg_energy = mean(energy), max_energy = max(energy), total_energy = sum(energy))
## # A tibble: 1 × 3
##   avg_energy max_energy total_energy
##        <dbl>      <dbl>        <dbl>
## 1      0.682      0.995         682.


#group_by() takes a data frame and then the names of one or more columns in the data frame. 



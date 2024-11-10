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

tb <- tibble(
  `:)` = "smile",
  ` ` = "space", 
  `2000` = "number"
)

tb  #call the tibble 

# # A tibble: 1 × 3
# `:)`  ` `   `2000`
# <chr> <chr> <chr> 
#   1 smile space number


## TRIBBLE - transposed tibble - customized for data entry in code
# Column headings are defined by formulas **(start w/ ~)** & commas separate entries 
# makes small amount data easily readable 

tribble(
  ~x, ~y, ~z,  #col headings that start w/ ~
  #--|--|----
  "a", 2, 3.6,  #x-col=a, y-col=2, z-col=3.6
  "b", 1, 8.5,  #x-col=b, y-col=1, z-col=8.5
  "c", 7, -9.2  #x-col=c, y-col=7, z-col=-9.2 
)

# A tibble: 3 × 3
# x         y     z
# <chr> <dbl> <dbl>
#   1 a         2   3.6
# 2 b         1   8.5
# 3 c         7  -9.2


#### PRINTING TIBBLE ####
# print function shows 1st 10 rows & all columns that fit on screen
# prints each col type
# much easier to work w/ large data

tibble( # variables are col names
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30, 
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# A tibble: 1,000 × 5
# a                   b              c      d e    
# <dttm>              <date>     <int>  <dbl> <chr> #COLUMN DATA TYPES
#   1 2024-11-10 09:27:20 2024-11-15     1 0.295  f    
# 2 2024-11-10 21:19:00 2024-11-18     2 0.176  k    
# 3 2024-11-10 08:07:31 2024-11-09     3 0.623  x    
# 4 2024-11-10 13:50:38 2024-11-15     4 0.294  b    
# 5 2024-11-09 23:10:29 2024-11-14     5 0.826  x    
# 6 2024-11-10 17:19:21 2024-11-11     6 0.816  j    
# 7 2024-11-10 09:19:21 2024-11-28     7 0.956  j    
# 8 2024-11-10 16:33:50 2024-11-27     8 0.708  j    
# 9 2024-11-10 22:18:15 2024-12-08     9 0.753  z    
# 10 2024-11-10 19:00:10 2024-12-08    10 0.0849 s    
# ℹ 990 more rows
# ℹ Use `print(n = ...)` to see more rows




# Can control # of rows of data printed out so you don't break console
# nycflights13::flights %>% 
#   print(n = 10, width = Inf)  #will print out first 10 rows

options(tibble.print_max = n, tibble.print_min = m)

# Use this to print ALL rows
options(tibble.print_min = Inf)

# Use this to print ALL columns
options(tibble.width = Inf)



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


options(iris.print_max = 5, iris.print_min = 4) # doesn't work
options(as_tibble.print_max = 5, as_tibble.print_min = 4) # doesn't work


# Subsetting - If you want to pull out a single variable, you need some new tools, $ and [[. [[ can extract by name or position; $ only extracts by name but is a little less typing.

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x # 1st way using $
# [1] 0.4937181 0.6419219 0.2283004 0.8165819 0.3421326


df[["x"]]  # 2nd way using [[]]
# [1] 0.4937181 0.6419219 0.2283004 0.8165819 0.3421326


# Extract by position
df[[1]]
# [1] 0.4937181 0.6419219 0.2283004 0.8165819 0.3421326

# To use these in a pipe, you’ll need to use the special placeholder .:
df %>% .$x
# [1] 0.4937181 0.6419219 0.2283004 0.8165819 0.3421326
df %>% .[["x"]]
# [1] 0.4937181 0.6419219 0.2283004 0.8165819 0.3421326




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



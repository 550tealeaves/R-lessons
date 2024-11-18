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

#R has a set of datasets that you can use to demo with

# data() will show the list of built-in datasets for testing
data()

#load datasets - and view the first few rows
data(Titanic) #seems optional
head(Titanic)
View(Titanic)

head(rivers)
summary(rivers)

head(occupationalStatus, 3)
head(occupationalStatus)
View(occupationalStatus)
head(occupationalStatus, 8)
summary(occupationalStatus)

data(HairEyeColor)
head(HairEyeColor, 9)
View(HairEyeColor)



summary(iris)
head(iris)
View(iris)

summary(beaver1)
head(beaver1)
View(beaver1)
View(beaver2)
summary(beaver2)
print(beaver2) #prints entire dataset
# use dim() to get dimension of dataset
cat("\nDimension:" , dim(beaver2)) # 100 4 (100 rows, 4 cols)
# use nrow() to get number of rows
cat("\nRow:" ,nrow(beaver2)) #100
# use ncol() to get number of columns
cat("\nColumn:" ,ncol(beaver2)) #4
# use names() to get name of variable of dataset
cat("\nName of variables:" ,names((beaver2))) # day, time, temp, activ


# *USE $ TO ISOLATE VARIABLES FOR FURTHER ANALYSIS OR MANIPULATION - (dataset$varname)*
# Display all values of specific variable, use $ operator & var name
print(beaver2$temp)
#   [1] 36.58 36.73 36.93 37.15 37.23 37.24 37.24 36.90 36.95 36.89 36.95 37.00
#  [13] 36.90 36.99 36.99 37.01 37.04 37.04 37.14 37.07 36.98 37.01 36.97 36.97
#  [25] 37.12 37.13 37.14 37.15 37.17 37.12 37.12 37.17 37.28 37.28 37.44 37.51
#  [37] 37.64 37.5 96 38.03 38.17 38.19 38.18 38.15 38.04 37.96 37.84 37.83 37.84
#  [61] 37.74 37.76 37.76 37.64 37.63 38.06 38.19 38.35 38.25 37.86 37.95 37.95
#  [73] 37.76 37.60 37.89 37.86 37.71 37.78 37.82 37.76 37.81 37.84 38.01 38.10
#  [85] 38.15 37.92 37.64 37.70 37.46 37.41 37.46 37.56 37.55 37.75 37.76 37.73
#  [97] 37.77 38.01 38.04 38.07

# Sorts values in temp variable in ascending order
sort(beaver2$temp)
#   [1] 36.58 36.73 36.89 36.90 36.90 36.93 36.95 36.95 36.97 36.97 36.98 36.99
#  [13] 36.99 37.00 37.01 37.01 37.04 37.04 37.07 37.12 37.12 37.12 37.13 37.14
#  [25] 37.14 37.15 37.15 37.17 37.17 37.23 37.24 37.24 37.28 37.28 37.41 37.44
#  [37] 37.46 37.46 37.51 37.51 37.55 37.56 37.60 37.63 37.64 37.64 37.64 37.70
#  [49] 37.71 37.73 37.74 37.75 37.76 37.76 37.76 37.76 37.76 37.77 37.78 37.81
#  [61] 37.82 37.83 37.84 37.84 37.84 37.86 37.86 37.89 37.91 37.92 37.95 37.95
#  [73] 37.96 37.96 37.98 38.00 38.01 38.01 38.01 38.02 38.02 38.03 38.04 38.04
#  [85] 38.06 38.07 38.10 38.10 38.11 38.11 38.15 38.15 38.17 38.18 38.19 38.19
#  [97] 38.24 38.24 38.25 38.35




# arrange() orders the rows of a data frame by the values of selected columns.
# 
# Unlike other dplyr verbs, arrange() largely ignores grouping

arrange(mtcars, cyl, disp)

# mpg cyl  disp  hp drat    wt  qsec vs am gear carb
# Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
# Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
# Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
# Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
# Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
# Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
# Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
# Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
# Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
# Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
# Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
# Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
# Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
# Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
# Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
# Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
# Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
# Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
# Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
# Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
# Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
# AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
# Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
# Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
# Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
# Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
# Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
# Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
# Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
# Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
# Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4




iris %>% arrange(pick(starts_with("Sepal")))

# Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
# 1            4.3         3.0          1.1         0.1     setosa
# 2            4.4         2.9          1.4         0.2     setosa
# 3            4.4         3.0          1.3         0.2     setosa
# 4            4.4         3.2          1.3         0.2     setosa
# 5            4.5         2.3          1.3         0.3     setosa
# 6            4.6         3.1          1.5         0.2     setosa
# 7            4.6         3.2          1.4         0.2     setosa
# 8            4.6         3.4          1.4         0.3     setosa
# 9            4.6         3.6          1.0         0.2     setosa
# 10           4.7         3.2          1.3         0.2     setosa
# 11           4.7         3.2          1.6         0.2     setosa
# 12           4.8         3.0          1.4         0.1     setosa
# 13           4.8         3.0          1.4         0.3     setosa
# 14           4.8         3.1          1.6         0.2     setosa
# 15           4.8         3.4          1.6         0.2     setosa
# 16           4.8         3.4          1.9         0.2     setosa
# 17           4.9         2.4          3.3         1.0 versicolor
# 18           4.9         2.5          4.5         1.7  virginica
# 19           4.9         3.0          1.4         0.2     setosa
# 20           4.9         3.1          1.5         0.1     setosa
# 21           4.9         3.1          1.5         0.2     setosa
# 22           4.9         3.6          1.4         0.1     setosa
# 23           5.0         2.0          3.5         1.0 versicolor
# 24           5.0         2.3          3.3         1.0 versicolor
# 25           5.0         3.0          1.6         0.2     setosa
# 26           5.0         3.2          1.2         0.2     setosa
# 27           5.0         3.3          1.4         0.2     setosa
# 28           5.0         3.4          1.5         0.2     setosa
# 29           5.0         3.4          1.6         0.4     setosa
# 30           5.0         3.5          1.3         0.3     setosa
# 31           5.0         3.5          1.6         0.6     setosa
# 32           5.0         3.6          1.4         0.2     setosa
# 33           5.1         2.5          3.0         1.1 versicolor
# 34           5.1         3.3          1.7         0.5     setosa
# 35           5.1         3.4          1.5         0.2     setosa
# 36           5.1         3.5          1.4         0.2     setosa
# 37           5.1         3.5          1.4         0.3     setosa
# 38           5.1         3.7          1.5         0.4     setosa
# 39           5.1         3.8          1.5         0.3     setosa
# 40           5.1         3.8          1.9         0.4     setosa
# 41           5.1         3.8          1.6         0.2     setosa
# 42           5.2         2.7          3.9         1.4 versicolor
# 43           5.2         3.4          1.4         0.2     setosa
# 44           5.2         3.5          1.5         0.2     setosa
# 45           5.2         4.1          1.5         0.1     setosa
# 46           5.3         3.7          1.5         0.2     setosa
# 47           5.4         3.0          4.5         1.5 versicolor
# 48           5.4         3.4          1.7         0.2     setosa
# 49           5.4         3.4          1.5         0.4     setosa
# 50           5.4         3.7          1.5         0.2     setosa
# 51           5.4         3.9          1.7         0.4     setosa
# 52           5.4         3.9          1.3         0.4     setosa
# 53           5.5         2.3          4.0         1.3 versicolor
# 54           5.5         2.4          3.8         1.1 versicolor
# 55           5.5         2.4          3.7         1.0 versicolor
# 56           5.5         2.5          4.0         1.3 versicolor
# 57           5.5         2.6          4.4         1.2 versicolor
# 58           5.5         3.5          1.3         0.2     setosa
# 59           5.5         4.2          1.4         0.2     setosa
# 60           5.6         2.5          3.9         1.1 versicolor
# 61           5.6         2.7          4.2         1.3 versicolor
# 62           5.6         2.8          4.9         2.0  virginica
# 63           5.6         2.9          3.6         1.3 versicolor
# 64           5.6         3.0          4.5         1.5 versicolor
# 65           5.6         3.0          4.1         1.3 versicolor
# 66           5.7         2.5          5.0         2.0  virginica
# 67           5.7         2.6          3.5         1.0 versicolor
# 68           5.7         2.8          4.5         1.3 versicolor
# 69           5.7         2.8          4.1         1.3 versicolor
# 70           5.7         2.9          4.2         1.3 versicolor
# 71           5.7         3.0          4.2         1.2 versicolor
# 72           5.7         3.8          1.7         0.3     setosa
# 73           5.7         4.4          1.5         0.4     setosa
# 74           5.8         2.6          4.0         1.2 versicolor
# 75           5.8         2.7          4.1         1.0 versicolor
# 76           5.8         2.7          3.9         1.2 versicolor
# 77           5.8         2.7          5.1         1.9  virginica
# 78           5.8         2.7          5.1         1.9  virginica
# 79           5.8         2.8          5.1         2.4  virginica
# 80           5.8         4.0          1.2         0.2     setosa
# 81           5.9         3.0          4.2         1.5 versicolor
# 82           5.9         3.0          5.1         1.8  virginica
# 83           5.9         3.2          4.8         1.8 versicolor
# 84           6.0         2.2          4.0         1.0 versicolor
# 85           6.0         2.2          5.0         1.5  virginica
# 86           6.0         2.7          5.1         1.6 versicolor
# 87           6.0         2.9          4.5         1.5 versicolor
# 88           6.0         3.0          4.8         1.8  virginica
# 89           6.0         3.4          4.5         1.6 versicolor
# 90           6.1         2.6          5.6         1.4  virginica
# 91           6.1         2.8          4.0         1.3 versicolor
# 92           6.1         2.8          4.7         1.2 versicolor
# 93           6.1         2.9          4.7         1.4 versicolor
# 94           6.1         3.0          4.6         1.4 versicolor
# 95           6.1         3.0          4.9         1.8  virginica
# 96           6.2         2.2          4.5         1.5 versicolor
# 97           6.2         2.8          4.8         1.8  virginica
# 98           6.2         2.9          4.3         1.3 versicolor
# 99           6.2         3.4          5.4         2.3  virginica
# 100          6.3         2.3          4.4         1.3 versicolor
# 101          6.3         2.5          4.9         1.5 versicolor
# 102          6.3         2.5          5.0         1.9  virginica
# 103          6.3         2.7          4.9         1.8  virginica
# 104          6.3         2.8          5.1         1.5  virginica
# 105          6.3         2.9          5.6         1.8  virginica
# 106          6.3         3.3          4.7         1.6 versicolor
# 107          6.3         3.3          6.0         2.5  virginica
# 108          6.3         3.4          5.6         2.4  virginica
# 109          6.4         2.7          5.3         1.9  virginica
# 110          6.4         2.8          5.6         2.1  virginica
# 111          6.4         2.8          5.6         2.2  virginica
# 112          6.4         2.9          4.3         1.3 versicolor
# 113          6.4         3.1          5.5         1.8  virginica
# 114          6.4         3.2          4.5         1.5 versicolor
# 115          6.4         3.2          5.3         2.3  virginica
# 116          6.5         2.8          4.6         1.5 versicolor
# 117          6.5         3.0          5.8         2.2  virginica
# 118          6.5         3.0          5.5         1.8  virginica
# 119          6.5         3.0          5.2         2.0  virginica
# 120          6.5         3.2          5.1         2.0  virginica
# 121          6.6         2.9          4.6         1.3 versicolor
# 122          6.6         3.0          4.4         1.4 versicolor
# 123          6.7         2.5          5.8         1.8  virginica
# 124          6.7         3.0          5.0         1.7 versicolor
# 125          6.7         3.0          5.2         2.3  virginica
# 126          6.7         3.1          4.4         1.4 versicolor
# 127          6.7         3.1          4.7         1.5 versicolor
# 128          6.7         3.1          5.6         2.4  virginica
# 129          6.7         3.3          5.7         2.1  virginica
# 130          6.7         3.3          5.7         2.5  virginica
# 131          6.8         2.8          4.8         1.4 versicolor
# 132          6.8         3.0          5.5         2.1  virginica
# 133          6.8         3.2          5.9         2.3  virginica
# 134          6.9         3.1          4.9         1.5 versicolor
# 135          6.9         3.1          5.4         2.1  virginica
# 136          6.9         3.1          5.1         2.3  virginica
# 137          6.9         3.2          5.7         2.3  virginica
# 138          7.0         3.2          4.7         1.4 versicolor
# 139          7.1         3.0          5.9         2.1  virginica
# 140          7.2         3.0          5.8         1.6  virginica
# 141          7.2         3.2          6.0         1.8  virginica
# 142          7.2         3.6          6.1         2.5  virginica
# 143          7.3         2.9          6.3         1.8  virginica
# 144          7.4         2.8          6.1         1.9  virginica
# 145          7.6         3.0          6.6         2.1  virginica
# 146          7.7         2.6          6.9         2.3  virginica
# 147          7.7         2.8          6.7         2.0  virginica
# 148          7.7         3.0          6.1         2.3  virginica
# 149          7.7         3.8          6.7         2.2  virginica
# 150          7.9         3.8          6.4         2.0  virginica



# Can get summary stats for specific variables using $
summary(beaver2$temp)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#   36.58   37.15   37.73   37.60   37.98   38.35


head(beaver2)
#   day time  temp activ
# 1 307  930 36.58     0
# 2 307  940 36.73     0
# 3 307  950 36.93     0
# 4 307 1000 37.15     0
# 5 307 1010 37.23     0
# 6 307 1020 37.24     0

summary(mdeaths)
head(mdeaths)
View(mdeaths)

#Monthly Deaths from Lung Diseases in the UK
summary(fdeaths)
head(fdeaths)
View(fdeaths)
summary(ldeaths)
head(ldeaths)
View(ldeaths)

#Plot
require(stats); require(graphics) # for time
plot(ldeaths)
plot(mdeaths, fdeaths)
## Better labels:
yr <- floor(tt <- time(mdeaths))
#mdeaths on X-axis, fdeaths on Y-axis
plot(mdeaths, fdeaths,
     xy.labels = paste(month.abb[12*(tt - yr)], yr-1900, sep = "'"))


#Creates an examples log plots
example("plot")
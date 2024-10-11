### Modified from Thomas Mock- A Gentle Introduction to Tidy Statistics in R ###
### https://rstudio.com/resources/webinars/a-gentle-introduction-to-tidy-statistics-in-r/ ###

# object types in R
# numbers, characters, vectors... 
# And we can do a lot about them

# Shortcut to add comment - shift + ctrl + c

# Mathematical function
3 + 3
3 - 1
4 / 2
4 * 4

# Logic (boolean expressions)
3 == 4 #== means exactly equal to
3 != 3 # != means not equal to 
3 != 4
4 > 3
4 < 3

# VECTOR: a list of items, all of the same type
# items can be numeric
# assign vector to a variable
y <- c(1, 2, 3, 4, 5) # shortcut to create assignment key is alt/option + - (alt + hyphen)
y
# and can be characters
y <- c("Lily", "Micheal", "Steven", "Bill", "Sam")
y
# and can be booleans
y <- c(TRUE, TRUE, FALSE, TRUE, FALSE)
y
# Objects + Functions
# output value of x as the sum of 3+5
x <- 3 + 5
x

# use R built-in functions
y <- c(1, 2, 3, 4, 5)
mean(y) # native R function
?mean() # defines the function - it's a help
?min()
min(y)
max(y)

# Functions under the hood - create own functions
add_pi <- function(x){
  x + 3.14
}
add_pi(104) #104 + 3.14 = 107.14

### Exercise 1 ###
# (1) create a vector variable z, and assigns a numeric value to it
z <- 109
z

# (2) Use boolean expressions to check 
# whether 321 * 345 is larger than 123 * 543
a <- 321*345
b <-  123*543
a > b

#ALTERNATIVE way - little longer
e <- 321
f <-  345
g <- 123
h <-543

e*f > g*h

## ALTERNATIVE way - more concise
321*345 > 123 * 543

# (3) run the add_pi function, and apply this function to variable z
# tip: shortcut key for commnent/uncomment: shift + ctrl/cmd + c
add_pi <- function(x){
  x + 3.14
}

add_pi(z)


# (4) create a vector variable that contains five students' maths scores:
# 78, 93, 84, 99, 62
# the name of this variable is math_scores
math_scores <- c(78, 93, 84, 99, 62)

# (5) compute the mean of these five scores
mean(math_scores)

# (6) create a vector variables that contains five students' physics scores
# 60, 72, 80, 94, 91
# the name of this variable is physics_scores
physics_scores <- c(60, 72, 80, 94, 91)

# (7) compute the total scores for five students
# (physics scores + maths scores)
physics_scores + math_scores

#ALTERNATIVE
total_scores <- physics_scores + math_scores  
total_scores

# (8) check what the following functions do
# and apply these functions to the vector maths_scores
# sort(), length(), sd()
?sort()
?length()
?sd()

sort(math_scores)
length(math_scores)
sd(math_scores)

#ALTERNATIVE - use print function
print(sort(math_scores))
print(length(math_scores))
print(sd(math_scores))



# (9) create a vector of five student names
# Lily, Steven, Sam, Bill, Sarah
# name the vector as names
names <- c("Lily", "Steven", "Sam", "Bill", "Sarah")
names



# more completed object
# data frames: R built-in - most commonly used object in R - like a spreadsheet
View(mtcars) # will show the spreadsheet in new tab
?mtcars # can get more info about this dataframe 

# Libraries
#install.packages("tidyverse")
# remember to comment the install.packages code
# after you install the packages
library(tidyverse) #does data cleaning, visualization etc
?tidyverse

# dplyr - data cleaning and transformation
# The "%>%" (aka the pipe) - passes an argument as an input of the following function
# **shortcut key: shift + ctrl/cmd + m**
# use pull function to illustrate the pipe
#Only wants to get the data from the mpg column
mpg_col <- pull(mtcars, mpg) # pull function extracts data - 2 arguments - extract 1 vector from dataframe
mean(mpg_col)

# When you use the pipe %_%, pull function only needs 1 argument, not 2
# don't need a new variable name for extracting mpg column but you still can
mtcars %>% 
  pull(mpg) %>% 
  mean() # get the same output as lines 148-149

### Exercise 2 ###
# use pull() and pipe to get the maximum value of
# hp column in mtcars
# tip: the function for getting the maximum value is max()

# PULL FUNCTION - 2 ARGUMENTS
hp_col <- pull(mtcars, hp)
max(hp_col)

# PIPE - PULL FUNC ONLY NEEDS 1 ARGUMENT
mtcars %>% 
  pull(hp) %>% 
  max()


# Now let's create a data frame for ourselves!
# use data.frame function
# each line corresponds to a column/vector
student_scores <- data.frame(
  Student_ID = 1:11, #rows 1-11 for dataframe
  English = c(85, 78, 92, 67, 88, 76, 95, 80, 72, 90, 100),
  Maths = c(90, 82, 85, 74, 89, 91, 88, 77, 84, 92, 100),
  Physics = c(78, 85, 89, 80, 90, 76, 83, 91, 87, 79, 100),
  Gender = c("f", "f", "m", "m", "f", "m", "m", "f", "m", "m", "non-binary")
)

# get a preview of what the data set looks like
view(student_scores) # see entire dataframe
head(student_scores) # shows 1st 6 rows of df - default
head(student_scores, 8) # shows 8 rows
summary(student_scores) # summary function provides summary statistics

# we can do the same thing with what we do to mtcars
# e.g. select the English scores and compute the mean
student_scores %>% 
  pull(English) %>% 
  mean()

# MUTATE function lets you add, modify, delete a column
# add a column named biology
# and the Biology scores are five points
# higher than maths scores
?mutate()
student_scores <- student_scores %>% #have to assign the new col as var - can be the same name as the orig var of dataframe
  mutate(Biology = Maths + 5) # Biology scores will be 5 pts greater than math scores
student_scores

print(student_scores) # will see the biology column

# RELOCATE func - changes col order
# relocate the biology column to the front
?relocate()
student_scores <- student_scores %>% 
  relocate(Biology, .after = English)
student_scores

print(student_scores) # will see Bio col after Eng col

# write our data frame into a csv file!
# will save the data as CSV into your directory
?write_csv()
write_csv(student_scores, "student_scores.csv")

# read our csv file
df <- read_csv("student_scores.csv")
head(df)

### Exercise 3 ###
# (1) run the following code
# install.packages("tidyverse")
# remember to comment out the install.packages() code so it doesn't keep re-running
# after you installed the package
# load the library
library(tidyverse)

# create data frame with with student ID, English, 
# Biology, Maths, and Physics scores
# as well as their gender info
student_scores_two <- data.frame(
  Student_ID = 1:11,
  English = c(85, 78, 92, 67, 88, 76, 95, 80, 72, 90, 100),
  Biology = c(95, 87, 90, 79, 94, 96, 93, 82, 89, 97, 105),
  Maths = c(90, 82, 85, 74, 89, 91, 88, 77, 84, 92, 100),
  Physics = c(78, 85, 89, 80, 90, 76, 83, 91, 87, 79, 100),
  Gender = c("f", "f", "m", "m", "f", "m", "m", "f", "m", "m", "non-binary")
)

# (2) write this data frame as a csv file named scores.csv
write_csv(student_scores_two, "scores.csv")

# (3) load the scores.csv file, name the data frame variable df
# and print out part of the df
df_two <- read_csv(("scores.csv"))
head(df_two)

# (4) compute the standard deviation of students' physics scores
student_scores_two %>% 
  pull(Physics) %>% 
sd()

# (5) add a column named Chemistry, 
# and the Chemistry scores are 10 points less than English scores
student_scores_two <- student_scores_two %>% 
  mutate(Chemistry = English - 10)
student_scores_two

print(student_scores_two) #now includes the chemistry col w/ scores
  

# A little bit of more complex data wrangling
# the mean of female students and male students
# for their maths scores
mean_math <- student_scores %>% 
  group_by(Gender) %>% 
  summarize(mean_score = mean(Maths))
mean_math

# filter and select
# what if I only want to see female students' scores?
student_f <- student_scores %>% 
  filter(Gender == "f")
student_f

### Exercise 4 ### 
# get the student scores for male student AND the non-binary student
# tip: check the logic expression we mentioned before


### filter cont.
# what if I want to get a spreadsheet of students
# whose English scores are above 78?
student_above78 <- student_scores %>% 
  filter(English > 78)
student_above78

print(student_above78)

# how about getting the spreadsheet of students
# whose English scores are above 78 AND maths scores are above 88?
student_above <- student_scores %>% 
  filter(English > 78 & Maths > 88)

print(student_above)

### Exercise 5 ###
# get a spreadsheet of students whose
# biology scores and maths scores combined are above 180


# select columns
view(student_scores)
student_part <- student_scores %>% 
  select(Student_ID:Maths)
student_part

# another way:
student_part <- student_scores %>% 
  select(-c("Physics", "Gender"))
student_part

### Exercise 6 ###
# select column Student_ID, English, Maths, and Gender
# use two ways to do so


# Bonus! 
# index dataframe
# student_scores[row_num1 : row_num3, col_num1 : col_num5]
student_scores[1:3,]
student_scores[,3:5]
student_scores[1:3, 3:5]


### Bonus exercise ###
# compute the mean scores for each student
# and add this mean score as a column in the data frame
# tip2: use function rowMeans() to do so
# you may want to use index to get the columns 
# that you want to compute the mean values for


# answer key here
# student_update <- student_scores %>% 
#   mutate(mean_score = rowMeans(student_scores[, 2:5]))
# head(student_update)

### Bonus 2 ###
# Basic data visualization
# plot the boxplot of female, male and non-binary students' maths scores
# ggplot to the rescue!
ggplot(student_scores, aes(x = Gender, y = Maths, color = Gender)) +
  geom_boxplot()

### Bonus exercise 2 ###
# draw a boxplot of female, male students' physics scores



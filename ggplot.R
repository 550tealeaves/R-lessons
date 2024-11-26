library(tidyverse)

# dataset
student_scores <- data.frame( 
  Student_ID = 1:11, 
  English = c(85, 78, 92, 67, 88, 76, 95, 80, 72, 90, 100), 
  Biology = c(95, 87, 90, 79, 94, 96, 93, 82, 89, 97, 105), 
  Maths = c(90, 82, 58, 74, 89, 91, 88, 77, 84, 92, 100), 
  Physics = c(78, 85, 89, 80, 90, 76, 83, 91, 87, 79, 100), 
  Gender = c("f", "f", "m", "m", "f", "m", 
             "m", "f", "m", "m", "non-binary"))
view(student_scores)

# Exercise 1: Try creating a dataset that includes only students with ID numbers from 1 to 5
tmp <- student_scores %>% 
  filter(Student_ID %in% 1:5) # include any values w/ student IDs 1-5

tmp <- student_scores %>% 
  filter(Gender %in% c("f", "m")) #filters out the non-binary (leaves m, f in)
view(tmp)

tmp <- student_scores %>% 
  filter(Gender != "non-binary") #filters out the gender that does NOT equal non-binary (leaves m, f in)
view(tmp)


# Exercise 2:Create a dataset that includes only students with a passing Maths score.

# mutate dataset using ifelse - creates new col that says fail_in_maths
# labels 0 -for scores >= 60, 1 = scores <= 60
# ifelse (condition (Maths) < score we are basing this off (60), condition if true (1), condition if false(0))
tmp <- student_scores %>% 
  mutate(fail_in_maths = ifelse(Maths < 60, 1, 0)) 
view(tmp)


# Filter out students who failed in math
tmp <- student_scores %>% 
  mutate(fail_in_maths = ifelse(Maths < 60, 1, 0)) %>% 
  filter(fail_in_maths == 0)
view(tmp)

# prepare the dataset for plotting
# In order to plot, must pivot the data
# pivot_longer function collects all the scores and reshapes them into 1 col of scores and then adds new col "courses" that will have corresponding score - makes spreadsheet longer& wider 
# Argument for pivot_longer 
# (1) Names of selected cols 
# (2) - new col names for those selected in (1) - "courses" replaces English:Physics
# (3) - new col names for scores - "scores" 
head(student_scores)
# reshape
scores_reshape <- student_scores %>% 
  pivot_longer( 
    cols = English:Physics,    # columns to reshape: from English to Physics (only use : if cols next to each other or else use c("English", "Math", "Physics" etc))
    names_to = "courses",      # new column name for the course names
    values_to = "scores"       # new column name for the scores
  )
view(scores_reshape) # creates a long spreadsheet

# Exercise 3: 
# pivot wider - reshapes it back to original (does opposite of pivot_longer)
?pivot_wider()
scores <- scores_reshape %>% 
  pivot_wider(
    names_from = courses,
    values_from = scores
  )
view(scores)

# ggplot

# BOXPLOT
# good way to see outliers and data distribution
# English scores are more varied than the other subjects 

# Only 1 non-binary value, so filtered it out 
scores_reshape <- scores_reshape %>% 
  filter(Gender != "non-binary")
head(scores_reshape)

# SIMPLE BOXPLOT
#geom_boxplot (geometry) - tells ggplot to make barplot
ggplot(scores_reshape, aes(x = courses, y = scores))+
  geom_boxplot()+
  # styling 
  theme_classic()+ # changes theme (removes lines)
  # Change labels of x & y axes & add title
  labs(x = "Courses",
       y = "Scores", 
       title = "Scores for grade-6 students") 

# Separate box plots by gender and color them
# set color = Gender
ggplot(scores_reshape, aes(x = courses, y = scores, color = Gender))+
  geom_boxplot()+
  # styling 
  theme_classic()+ # changes theme (removes lines)
  # Change labels of x & y axes & add title
  labs(x = "Courses",
       y = "Scores", 
       title = "Scores for grade-6 students")

# SIMPLE BARPLOT
# get the summarized scores for each course

mean <- scores_reshape %>% # compute mean score for each course
  group_by(courses) %>% # group by all courses
  summarize(ave = mean(scores)) # calculate average of mean scores
mean

# BARPLOT
ggplot(mean, aes(x = courses, y = ave))+
  geom_bar(stat = "identity")+ #id tells it plot the values it gets
  theme_classic()+
  labs(x = "Courses",
       y = "Mean Scores")


# make it colorful
?geom_bar()
ggplot(mean, aes(x = courses, y = ave, fill = courses))+ #separate fill colors for each course, also provides legend
  geom_bar(stat = "identity")+ 
  theme_classic()+
  labs(x = "Courses",
       y = "Mean Scores")

# DOT PLOTS
# geom_smooth adds the Pearson's correlation
# Plot shows no correlation, very large confidence intervals (have a small dataset)
head(student_scores) # use the initial plot (non-pivoted)
ggplot(student_scores, aes(x = Maths, y = Physics))+
  geom_point()+
  geom_smooth(method = "lm", # add a linear regression line
              formula = y ~ x, # formula for the linear regression
              se = TRUE) + # add confidence interval
  theme_classic()+
  labs(x= "Maths",
      y = "Physics")

# how about biology?
# Can see a positive correlation 
# Have one outlier (58,90) - drags the dataset upward 
ggplot(student_scores, aes(x = Maths, y = Biology))+
  geom_point()+
  geom_smooth(method = "lm", # add a linear regression line
              formula = y ~ x, # the formular for the linear regression
              se = TRUE) + # add confidence interval
  theme_classic()+
  labs(x= "Maths",
       y = "Biology")



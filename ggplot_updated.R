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
  filter(Student_ID %in% 1:5)

# filter out non-binary
tmp <- student_scores %>% 
  filter(Gender != "non-binary")
view(tmp)

# Exercise 2:Create a dataset that includes only students with a passing Maths score.
# add a fail_in_maths column
tmp <- student_scores %>% 
  mutate(fail_in_maths = ifelse(Maths < 60, 1, 0))
view(tmp)

# filter out students who failed in maths
tmp <- student_scores %>% 
  mutate(fail_in_maths = ifelse(Maths < 60, 1, 0)) %>% 
  filter(fail_in_maths == 0)
view(tmp)

# prepare the dataset for plotting
head(student_scores)
# reshape
scores_reshape <- student_scores %>% 
  pivot_longer( 
    cols = English:Physics,    # columns to reshape: from English to Physics
    names_to = "courses",      # new column name for the course names
    values_to = "scores"       # new column name for the scores
  )
view(scores_reshape)

# Exercise 3: transform back to student_scores
?pivot_wider()
scores <- scores_reshape %>% 
  pivot_wider(
    names_from = courses,
    values_from = scores
  )
head(scores)

# ggplot
# boxplot
scores_reshape <- scores_reshape %>% 
  filter(Gender != "non-binary")
head(scores_reshape)

# simple boxplot
ggplot(scores_reshape, aes(x = courses, y = scores))+
  geom_boxplot() +
  theme_classic() +
  labs(x = "Courses",
       y = "Scores",
       title = "Scores for grade-6")

ggplot(scores_reshape, aes(x = courses, y = scores, color = Gender))+
  geom_boxplot() +
  theme_classic() +
  labs(x = "Courses",
       y = "Scores",
       title = "Scores for grade-6")


# simple barplot
# get the summarized scores for each course
mean <- scores_reshape %>%
  group_by(courses) %>% 
  summarize(ave = mean(scores)) %>% 
  arrange(ave)
mean

# add row number to the names of the courses
mean_ordered <- mean %>% 
  mutate(courses = paste0(row_number(), "_", courses))
mean_ordered

# barplot
?geom_bar()
ggplot(mean_ordered, aes(x = courses, y = ave))+
  geom_bar(stat = "identity")+
  scale_x_discrete(
    labels = c(
      "1_English" = "English",  # rename the name of each course
      "2_Maths" = "Maths",
      "3_Physics" = "Physics",
      "4_Biology" = "Biology"
    )
  )+
  theme_classic()+
  labs(x = "Courses",
       y = "Mean Scores")

# make it colorful
ggplot(mean_ordered, aes(x = courses, y = ave, fill = courses))+
  geom_bar(stat = "identity")+
  scale_x_discrete(
    labels = c(
      "1_English" = "English",  # rename the name of each course
      "2_Maths" = "Maths",
      "3_Physics" = "Physics",
      "4_Biology" = "Biology"
    )
  )+
  scale_fill_manual( # manually specify the filled color of the bar plot
    labels = c( # change the lengend names
      "1_English" = "English",  # rename the name of each course
      "2_Maths" = "Maths",
      "3_Physics" = "Physics",
      "4_Biology" = "Biology"
    ),
    values= c("coral", "forestgreen", "cadetblue1", "darkorchid")
  )+
  theme_classic()+
  labs(x = "Courses",
       y = "Mean Scores")

# dot plots
head(student_scores)
ggplot(student_scores, aes(x = Maths, y = Physics))+
  geom_point()+
  geom_smooth(method = "lm", # add a linear regression line
              formula = y ~ x, # the formula for the linear regression
              se = TRUE) + # add confidence interval
  theme_classic()+
  labs(x= "Maths",
      y = "Physics")

# how about biology?
ggplot(student_scores, aes(x = Maths, y = Biology))+
  geom_point()+
  geom_smooth(method = "lm", # add a linear regression line
              formula = y ~ x, # the formula for the linear regression
              se = TRUE) + # add confidence interval
  theme_classic()+
  labs(x= "Maths",
       y = "Biology")



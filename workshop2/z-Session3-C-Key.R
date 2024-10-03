# ROTO Coding Workshop
# Fall 2024
#  
# Session 3C - *** Interactive Exercises : Key ***
#### FUN! **** Pick a dataset to work with! ****

# clear workspace
library(tidyverse) # this is a widely used library of functions for manipulating data frames
library(ggplot2) # this is a widely used library of functions developed to make graphs, plots, and charts 

getwd()
setwd("")

#### **** Pig metabolomics data ****
# Experiment:
#     5 pigs were fed a normal diet, and 5 pigs were fed a high-fat diet (10 pigs total)
#     From all pigs, we collected one blood and one urine sample
#     We sent all samples to a lab to measure the concentrations of 38 compounds

# I want to make a plot that compares molecular concentrations between diets
# Right now our results data isn't structured for this
# we need to transform our results df into long format so that we can merge it with our metadata 

# import the results we collected from our experiment
results = read.csv('data/pig experiment/exp_results.csv', fileEncoding = 'UTF-8-BOM') # ROWS are compounds, COLUMNS are sample IDs. Values are concentrations from our experiment
metadata = read.csv('data/pig experiment/sample_metadata.csv', fileEncoding = 'UTF-8-BOM') # ROWS are sample IDs, COLUMNS are parameters from our experiment. 
compounds = read.csv('data/pig experiment/molecular_categories.csv', fileEncoding = 'UTF-8-BOM') # ROWS are compounds, with one column for the category of that molecule

results_long = pivot_longer(results, cols = -Compound, names_to = "Sample.ID", values_to = "Concentration") 
# we can also do the reverse and make it wider again (will result in same df as results)
results_wide = pivot_wider(results_long, names_from = "Sample.ID", values_from = "Concentration")  

# now that our results are in long format, we can join our metadata by matching "Sample.ID" between each df
exp_data = merge(results_long, metadata)

write.csv(exp_data, './data/pig experiment/exp_data.csv')

# Joins and merges are an important topic and there are many different functions that implement different strategies:
# examples: left_join(), right_join(), inner_join(), outer_join() 

### *** Putting it all together ***
# let's create a box plot!
ggplot(exp_data, aes(Diet, Concentration)) + 
  geom_boxplot()+
  geom_jitter(width = .1)

lactic_acid = subset(exp_data, Compound == "Lactic Acid")
ggplot(lactic_acid, aes(Diet, Concentration)) + 
  geom_boxplot() + 
  geom_jitter(width = .1) + 
  ggtitle("Lactic acid concentration between pig diets")

# OR this!! Remember how the pipe %>% inherits what came before it in the chain?
exp_data %>%
  filter(Compound == "Lactic Acid") %>%
  ggplot(., aes(Diet, Concentration)) +
  geom_boxplot() + 
  geom_jitter() + 
  ggtitle("Lactic acid Concentration between pig diets")

# how about multiple compounds?
compound_list = c("Proline", "Glucose", "Ethanol", "Pyruvate")
exp_data %>%
  filter(Compound %in% compound_list) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Compound))) + 
  geom_jitter()

exp_data %>%
  filter(Compound %in% compound_list) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) + 
  geom_jitter() + 
  facet_wrap(~Compound) # make a unique graph for every compound

# remember our compounds df which has categories? 
exp_data = merge(exp_data, compounds)
exp_data %>%
  filter(Category == "Lipid") %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) +
  geom_boxplot() + 
  geom_jitter() + 
  facet_wrap(~Compound)

exp_data %>%
  filter(Category == "Sugar") %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) +
  geom_boxplot() + 
  geom_jitter() + 
  facet_wrap(~Compound)

####  **** Framingham heart study ****
# clear workspace
getwd()
setwd("/Volumes/GoogleDrive/My Drive/ROTO Summer Coding Workshop")

framingham = read.csv('data/heart study/framingham.csv', fileEncoding = 'UTF-8-BOM') # UTF-8-BOM is important for mac-windows compatibility

## What are some basic observations about this data?
# every ROW is an individual in the study. Every COLUMN is a property/variable about that person
# every value in the data frame is a number, even things like gender.
# 0 means "no" or not male, and 1 means "yes" or is male

# Which variables are binary, and which are continuous? 
# How are variables distributed?
unique(framingham$male)
hist(framingham$age)
hist(framingham$BMI, breaks = 100)
hist(framingham$totChol, breaks = 80)
hist(framingham$glucose, breaks = 80)

####  **** ggplot() Practice - Plot the distributions of all variables in the study ****
framingham_long = framingham %>%
  pivot_longer(., cols = everything())

# Basic boxplots of our data
ggplot(framingham_long, aes(x = name, y = value)) + 
  geom_boxplot()

# ... Improve the plot with better formatting
ggplot(framingham_long, aes(x = name, y = value)) + 
  geom_boxplot() + 
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"), 
    panel.grid.major.y = element_line(colour = "grey"),
    panel.grid.major.x = element_blank()
  )

# Customize further
ggplot(framingham_long, aes(x = name, y = value)) + 
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size = .3, alpha = .4, width = .07) + 
  labs(
    x = "Health Parameters Measured", 
    y = "Value (variable units)", 
    title = "Distributions of Data collected in Framingham Heart Study"
  ) + 
  theme(
    plot.title = element_text(size = 10),
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"), 
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )

# Save the graph
ggsave("distributions_of_data_collected_in_framingham_study.jpg", width = 8, height = 10)

#####  ***** Plot correlations between different variables ****
# Does total cholesterol correlate with BMI?
ggplot(framingham, aes(x = totChol, y = BMI)) + 
  geom_jitter() + 
  geom_smooth(method = "lm") # adds a trendline

# EXERCISE: Make a similar plot for cholesterol vs. systemic blood pressure (sysBP)
ggplot(framingham, aes(x = totChol, y = sysBP)) + 
  geom_jitter() + 
  geom_smooth(method = "lm")

## Explore BMI vs other key variables
BMI_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  pivot_longer(cols = c("totChol", "sysBP", "diaBP", "glucose"), names_to = "measurement")

ggplot(BMI_long, aes(x = BMI, y = value)) + 
  geom_jitter(size = .2) + 
  geom_smooth(method = "lm") + 
  facet_wrap(~measurement, scales = "free")

# EXERCISE: Do the same for sysBP vs the other variables
sysBP_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  pivot_longer(cols = c("BMI", "totChol", "diaBP", "glucose"), names_to = "measurement")

ggplot(sysBP_long, aes(x = sysBP, y = value)) + 
  geom_jitter(size = .2) + 
  geom_smooth(method = "lm") + 
  facet_wrap(~measurement, scales = "free")

# EXERCISE: Do the same for glucose vs the other variables
glucose_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  pivot_longer(cols = c("BMI", "totChol", "sysBP", "diaBP"), names_to = "measurement")

ggplot(glucose_long, aes(x = glucose, y = value)) + 
  geom_jitter(size = .2) + 
  geom_smooth(method = "lm") + 
  facet_wrap(~measurement, scales = "free")


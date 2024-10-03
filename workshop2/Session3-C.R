
# ROTO Coding Workshop
# Fall 2024
# 
# Session 3C - *** Interactive Exercises : Please fill in the blanks!  ***

#### FUN! **** Pick a dataset to work with! ****

# clear workspace

library(tidyverse) # this is a widely used library of functions for manipulating data frames
library(ggplot2) # this is a widely used library of functions developed to make graphs, plots and charts


getwd()
setwd("")


#### **** Pig metabolomics  data ****
# Experiment:
#     5 pigs were fed a normal diet, and 5 pigs were fed a high-fat diet (10 pigs total)
#     From all pigs, we collected one blood an done urine sample
#     We sent all samples to a lab to measure the concentrations of 38 compounds


# I want to make a plot that compares molecular concentrations between diets
# Right now our results data isn't structured for this
# we need to transform our results df into long format so that we can merge it with our metadata


# import the results we collected from our experiment
results = read.csv( 'data/pig experiment/exp_results.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, COLUMNS are sample IDs. Values are concentrations from our experiment

metadata = read.csv( 'data/pig experiment/sample_metadata.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are sample IDs, COLUMNS are parameters from our experiment.

compounds = read.csv( 'data/pig experiment/molecular_categories.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, with one column for the category of that molecule

results_long = pivot_longer( results, cols = -Compound, names_to = "Sample.ID", values_to = "Concentration" )

# we can also do the reverse and make wider again (will result in same df as results)
results_wide = pivot_wider( results_long, names_from = "Sample.ID", values_from = "Concentration")

# now that our results are long format, we can join our metadata by matching "Sample.ID" between each df
exp_data = merge(results_long, metadata)

write.csv()

# Joins and merges are an important topic and there are many different functions that implement different strategies:
# examples: left_join(), right_join(), inner_join(), outer_join()



### *** Putting it all together ***

# let's create a box pot!
ggplot(exp_data, aes(Diet, Concentration)) +
  ________ +
  geom_jitter(width = .1)

# Subset the data for Lactic Acid!
lactic_acid = subset(________,________ )

# Let's take a look at the boxplot for Normal vs High Fat diet
ggplot(lactic_acid, aes(Diet, Concentration)) +
  geom_boxplot() +
  geom_jitter(width = .1) +
  ggtitle("Lactic acid concentration between pig diets")


# OR this!! Remember how the pipe %>% inherits what came before it in the chain?
exp_data %>%
  filter( Compound == "Lactic Acid" ) %>%
  ggplot(., aes(Diet, Concentration)) +
  geom_boxplot() +
  geom_jitter() +
  ggtitle("Lactic acid Concentration between pig diets")


# how about multiple compounds?
compound_list = c("Proline", "Glucose", "Ethanol", "Pyruvate")

# Use the pipe %>% to filter for only the compounds in compound_list
exp_data %>%
  _______ %>%
  ggplot(., aes(Diet, Concentration, color = factor(Compound))) + # make every Compound a unique color
  geom_jitter()

# we can use facet_wrap to split our dara into unique facets :) 
exp_data %>%
  filter( Compound %in% compound_list ) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) + # make the color the diet
  geom_jitter() +
  facet_wrap(~Compound) # make a unique graph for every compound



# remember our compounds df which has categories?
exp_data = merge(exp_data, compounds)


# add fact_wrap to split the data based on Compound!
exp_data %>%
  filter(Category == "Lipid") %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) +
  geom_boxplot() +
  geom_jitter() +
  ________



#Include only the rows where the Category is "Sugar"
exp_data %>%
  filter(________) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) +
  geom_boxplot() +
  geom_jitter() +
  facet_wrap(~Compound)





####  **** Framingham heart study ****

# clear workspace

getwd()
setwd( "/Volumes/GoogleDrive/My Drive/ROTO Summer Coding Workshop")

framingham = read.csv( 'data/heart study/framingham.csv', fileEncoding = 'UTF-8-BOM') # UTF-8-BOM is important for mac-windows compatibility

## What are some basic observations about this data?

# every ROW is an individual in the study. Every COLUMN is a property/variable about that person

# every value in the data frame is a number, even things like gender.
# ... for example notice all values in the column male are 0 or 1.    0 means "no" or not male, and 1 means "yes" or is a man
# ... When everything is represented as a number, this makes it convenient to perform calculations or models on the data


# Which variables are binary, and which are continuous?


# How are variables distributed? Let's make some histograms!

unique(framingham$male)

#Let's see how is the distribution of Age in our data
hist(framingham$age)


# let's create a histogram of BMI values, splitting the data into 100 bins
hist(framingham$BMI, breaks = 100)

# Now, create a histogram of total Cholesterol, splitting the data into 80 bins
hist(framingham$totChol, ______ )

# Now, do the same for glucose!
hist(______, _______)




####  **** ggplot() Practice - Plot the distributions of all variables in the study ****


# Histograms show how data are distributed. We can also represent a distribution with a boxplot in ggplot():

# first we have to reshape our data
framingham_long = framingham %>% pivot_longer(., cols = everything() )


# Basic boxplots of our data. Boxplots show us how our data points are distributed.
# The line in the middle of the box is the median of the points
ggplot(_______, aes(x = name, y = value)) +
  geom_boxplot() 
# ... We cannot read the X variables they all overlap. Also the plot isn't super nice looking
# ... not a bad start but let's make it a litte nicer



# We can use theme() function to customize virtually any element of our ggplot2. Google is your friend here!
# Here, I'm going for a minimal black and white plot
# Comment our any of the lines in theme() and re-run to see how they change the look of the ggplot
ggplot(framingham_long, aes(x = name, y = value)) +
  geom_boxplot() +
  theme(
    axis.text.x = element_text(angle = 90), # print the names of x axis variables a 90 degree angle
    panel.background = element_rect(fill = "white", colour = "black"), # change the background fill to white, and the border to black
    panel.grid.major.y = element_line(colour = "grey"), # make the horizontal lines on the plot grey
    panel.grid.major.x = element_blank() # remove the vertical lines on the plot
  )

# ... Looking much better! Right now the geom_boxplot() function is showing points for outlines.
# I'd like to add different looking points for everything, and remove the outlines displayed through geom_boxplot()

# Complete the ggplot function here, use name and value as your x and y!
ggplot(framingham_long, aes(x = ___, y = ___)) +
  # remove the outlier points from the boxplot aesthetic:
  geom_boxplot(outlier.shape = NA) + 
  # add points that are smaller (size=.3), transparent (alpha =.4), and are clustered closer together width-wise (width = .07):
  geom_jitter(size = .3, alpha = .4, width = .07) + 
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


## Lastly, let's add axis labels and tiles to the ggplot

ggplot(framingham_long, aes(x = name, y = value)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size = .3, alpha = .4, width = .07) +
  labs(
    x = "Health Parameters Measured", # x axis label
    y = "Value (variable units)", # y axis label
    title = "Distributions of Data collected in Framingham Heart Study" # title
  ) +
  theme(
    # notice that we have to change the font size of the title within theme( plot.title = ... ).
    # Again, google is your friend here:
    plot.title = element_text(size = 10),
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )



# Okay lets save this nice looking graph!
getwd()
# ggsave("name of file.extension", width = , height = )
ggsave("distributions of data collected in framingham study.jpg", width = 8, height = 10)




#####  ***** Plot correlations between different variables ****

# Does total cholesterol correlate with BMI?
# If cholesterol increases for individuals, does BMI also tend to increase or decrese?

ggplot(framingham, aes(x = totChol, y = BMI)) +
  geom_jitter() # like geom_point, except it spreads out the points slightly if they would overlap!
# ... kind of unclear if there is a correlation? Let's add a trendline!

ggplot(framingham, aes(x = totChol, y = BMI)) +
  geom_jitter() + 
  geom_smooth(method = "lm") # this function adds a trendline to our graphs!



# **** EXERCISE **** - make a similar plot for cholesterol vs. systemic blood pressure (sysBP)
ggplot(data= _____ , aes(x= _____ , y= _____)) + 
  _____ + 
  _____



## Its seems like a lot of work to make a ggplot 1 by 1 of every variable.
## However, if we are clever about how we shape our data we can look at a lot of things in one plot
## Let's look at BMI versus other key variables

BMI_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) #first select only the columns we care about

# Then reshape so that every row is a combination of BMI and a 2nd variable;
# BUT we keep the label of that other 2nd variable
BMI_long = BMI_long %>%
  pivot_longer(cols = c("totChol", "sysBP", "diaBP", "glucose"), names_to = "measurement") # names_to lets us specify what the column containing the variable names will called when we conver to rowns

# We can of course pipe the code above into one chunk of code:
BMI_long = framingham %>%
  ______________________ %>%
  ______________________


# BMI versus every value of ALL other variables.
# We can't tell which points belong to which variables
ggplot(BMI_long, aes(x = BMI, y = value)) +
  geom_jitter(size = .2) +
  geom_smooth(method = "lm")

# ... however, we can use facet_wrap() to break out each variable into an individual plot. 
ggplot(BMI_long, aes(x = BMI, y = value)) +
  geom_jitter(size = .2) +
  geom_smooth(method = "lm") +
  _____(~measurement, scales = "free")

# ~measurement tells instructs ggplot to make an individual facet for each measurement variable
# scales = "free" makes the x & Y ranges of each facet independent






# Now, let's do the same but for sysBP versus the other variables


sysBP_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  # What columns do we select to pivot longer?
  # Hint: it is only 4 of the 5 variables called in the select() function.
  pivot_longer(cols = c("_____", "_____", "_____", "_____"), names_to = "measurement")


ggplot( sysBP_long, aes(x = , y = )) + # fill in x and y
  geom_jitter() + # fill in size argument!
  geom_smooth(method = "lm") +
  facet_wrap() # fill in arguments!


# Now do the same for glucose vs the other variables

glucose_long = framingham %>%
  
  
ggplot( , aes(x = , y = )) 






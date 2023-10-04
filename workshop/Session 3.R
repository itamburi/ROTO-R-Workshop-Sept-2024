# ROTO Summer Coding Workshop
# Summer 2023
# Session 3 - *** Basic data types and data structures ***


library(tidyverse) # this is a widely used library of functions for manipulating data frames
library(ggplot2) # this is a widely used library of functions developed to make graphs, plots and charts




#### 1.0 - **** Merging data frames ****

getwd()
setwd("")

# import the results we collected from our experiment
results = read.csv( 'data/pig experiment/exp_results.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, COLUMNS are sample IDs. Values are concentrations from our experiment

metadata = read.csv( 'data/pig experiment/sample_metadata.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are sample IDs, COLUMNS are parameters from our experiment.

compounds = read.csv( 'data/pig experiment/molecular_categories.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, with one column for the category of that molecule


# Experiment:
#     5 pigs were fed a normal diet, and 5 pigs were fed a high-fat diet (10 pigs total)
#     From all pigs, we collected one blood an done urine sample
#     We sent all samples to a lab to measure the concentrations of 38 compounds


# I want to make a plot that compares molecular concentrations between diets
# Right now our results data isn't structured for this
# we need to transform our results df into long format so that we can merge it with our metadata

results_long = pivot_longer( results, cols = -Compound, names_to = "Sample.ID", values_to = "Concentration" )

# we can also do the reverse and make wider again (will result in same df as results)
results_wide = pivot_wider( results_long, names_from = "Sample.ID", values_from = "Concentration")

# now that our results are long format, we can join our metadata by matching "Sample.ID" between each df
exp_data = merge(results_long, metadata)

write.csv()

# Joins and merges are an important topic and there are many different functions that implement different strategies:
# examples: left_join(), right_join(), inner_join(), outer_join()



### 2.0 - *** Putting it all together; More sophisticated ggplot graphs ***


ggplot(exp_data, aes(Diet, Concentration)) +
  geom_boxplot() +
  geom_jitter(width = .1)


lactic_acid = subset(exp_data, Compound == "Lactic Acid")

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

exp_data %>%
  filter( Compound %in% compound_list ) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Compound))) + # make every Compound a unique color
  geom_jitter()

exp_data %>%
  filter( Compound %in% compound_list ) %>%
  ggplot(., aes(Diet, Concentration, color = factor(Diet))) + # make the color the diet
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





### EXERCISE 1 - Together or independently

# What would the group like to plot?










#### 1.0 - **** Youtube Statistics ****

getwd()
setwd( "/Volumes/GoogleDrive/My Drive/ROTO Summer Coding Workshop")


youtube = read.csv('data/youtube/Global YouTube Statistics.csv') # this time no fileEncoding argument bc it wasnt working with that call. Just a auirk of the data set!
head(youtube)
dim(youtube)
colnames(youtube)



#### 1.1 - **** ggplot() Practice - Plot Total Youtube views by Country ****

# First use group_by & summarise() to determine the total views in the last 30 days per country
views.by.country = youtube %>%
  group_by(Country) %>%
  summarise(
    total.views = sum(video_views_for_the_last_30_days)
  )

# Most basic bar plot of total views
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity")
#... but we can't really ready the overlapping country names on the x axis





# So let's adjust the text angle with theme()
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
  )
# Theme is a huge function for editing lots of ggplot2 aesthetics
# If you are ever trying to achieve a certain look in ggplot, google is your friend.
#      - for example, I just searched "ggplot make x axis labels vertical" and got this code!
# Usually someone online already has code for what look/theme parameters you are going for!



# We can really go all out on the theme parameters to change the look
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    # more theme parameters"
    panel.background = element_rect(fill = "white", colour = "black"), 
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )



# Now I'd like to reorder the countries by greatest to least
# We would use the reorder function to reorder the Country column

views.by.country$Country <- reorder(views.by.country$Country, -views.by.country$total.views) # -views.by.country tells reorder to do descending order, greatest to least views
# same code as before:
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )
#... That looks nice!!




# We can also reorder within the ggplot aes() call for the x variable. It actually is a little bit easier to read this way!
ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )



# Theres lots of ways to add labels and edit text in our plots
# labs() is the most straightforward.
ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views)) +
  geom_bar(stat = "identity") +
  # set x, y and title text with labs()
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Youtube views in last 30 days per country" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )






# There are lots of ways to customize colors in ggplot. There are acutally too many, its crazy
# Basically anything you can think of color-wise can somehow be achieved in ggplot if you're willing to work hard enough
# Here I want to just make a simple scheme where dark blue is the most # of views, and light blue is the least # of views

# need to tell ggplot to make the color scheme based off of fill with fill == total views
# also worth pointing out that the fill argument lives inside of the aes() parentheses

ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) + 
  geom_bar(stat = "identity") +
  # function to assing our color scheme to total.views
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", 
    y = "Total Views", 
    title = "Youtube Views by Country"
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )

# Looking good now!




# Last thing id like to do is remove the countries that have very few total views.
# I will arbitrarily filter for views > 100 million
views.by.country %>%
  filter(total.views >= 100000000) %>%
ggplot(., aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Countries with more than 100 million Youtube views" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


#### For fun, lets look at where we started again:

ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity")

### .... versus where we finished

views.by.country %>%
  filter(total.views >= 100000000) %>%
  ggplot(., aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Countries with more than 100 million Youtube views" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


# I like this graph. Let's save it. ggsave() saves the current plot

ggsave("youtube views by country.jpg", width = 10, height = 8)




### **** Exercise 2 - Plot the total views in the last 30 days by category

# first execute the following to make a data frame for our plot
views.by.category = youtube %>%
  group_by(category) %>%
  summarise(
    views = sum(video_views_for_the_last_30_days)
  )


plot.data = subset(views.by.category, views > 1000000)



# Now, fill in the missing parts of the following block of code to plot Category (x axis) against views(y axis)
ggplot(plot.data, aes(x = reorder(    ,    ), y =      , fill =     )) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(    ) +
  labs(
    x = "",
    y = "",
    title = "",
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )





#### Continued exercises - Monthly earnings


yt.earnings = youtube %>%
  select(c("Youtuber", "video.views", "category", "lowest_monthly_earnings", "highest_monthly_earnings")) %>%
  mutate( average.earnings = lowest_monthly_earnings * highest_monthly_earnings / 2 )
# What is the structure of this data frame? What have we computed?



ggplot(yt.earnings, aes(x = category, y = average.earnings)) +
  geom_boxplot() # we talk more about boxplots in the next section if you want to move on


# What would you like to plot! Try anything, instructors are happy to help!














#### 2.0 - **** Framingham heart study ****

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


# How are variables distributed

unique(framingham$male)
hist(framingham$age)
hist(framingham$BMI, breaks = 100)
hist(framingham$totChol, breaks = 100)
hist(framingham$glucose, breaks = 100)




#### 2.1 - **** ggplot() Practice - Plot the distributions of all variables in the study ****


# Histograms show how data are distributed. We can also represent a distribution with a boxplot in ggplot():

# first we have to reshape our data
framingham_long = framingham %>% pivot_longer(., cols = everything() )


# Basic boxplots of our data. Boxplots show us how our data points are distributed.
# The line in the middle of the box is the median of the points
ggplot(framingham_long, aes(x = name, y = value)) +
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

ggplot(framingham_long, aes(x = name, y = value)) +
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








##### 2.2 - ***** Plot correlations between different variables ****

# Does total cholesterol correlate with BMI?
# If cholesterol increases for individuals, does BMI also tend to increase or decrese?

ggplot(framingham, aes(x = totChol, y = BMI)) +
  geom_jitter() # like geom_point, except it spreads out the points slightly if they would overlap!
# ... kind of unclear if there is a correlation? Let's add a trendline!

ggplot(framingham, aes(x = totChol, y = BMI)) +
  geom_jitter() + 
  geom_smooth(method = "lm") # this function adds a trendline to our graphs!



# **** EXERCISE **** - make a similar plot for cholesterol vs. systemic blood pressure (sysBP)
ggplot(data= , aes(x= , y= ))






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
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  pivot_longer(cols = c("totChol", "sysBP", "diaBP", "glucose"), names_to = "measurement")


# BMI versus every value of ALL other variables.
# We can't tell which points belong to which variables
ggplot(BMI_long, aes(x = BMI, y = value)) +
  geom_jitter(size = .2) +
  geom_smooth(method = "lm")

# ... however, we can use facet_wrap() to break out each variable into an individual plot.
ggplot(BMI_long, aes(x = BMI, y = value)) +
  geom_jitter(size = .2) +
  geom_smooth(method = "lm") +
  facet_wrap(~measurement, scales = "free")
# ~measurement tells instructs ggplot to make an individual facet for each measurement variable
# scales = "free" makes the x & Y ranges of each facet independent








# **** EXERCISE **** - do the same but for sysBP versus the other variables




sysBP_long = framingham %>%
  select(c("BMI", "totChol", "sysBP", "diaBP", "glucose")) %>%
  # What columns do we select to pivot longer?
  # Hint: it is only 4 of the 5 variables called in the select() function.
  pivot_longer(cols = c("", "", "", ""), names_to = "measurement")


ggplot( sysBP_long, aes(x = , y = )) + # fill in x and y
  geom_jitter() + # fill in size argument!
  geom_smooth(method = "lm") +
  facet_wrap() # fill in arguments!


# Now do the same for glucose vs the other variables


glucose_long = framingham %>%

  
ggplot( , aes(x = , y = )) 







#### 2.3 - **** Using Linear models to see what predicts CHD (Coronary Heart Disease) ****

# If you've made it this far, very well done!
# So far we've made lots of plots to look at data relationships.
# However, we haven't done as many explicit quantitative statistical tests to look at variable relationships
# We can use models to gain a more quantitative, statistically- informed view of our data
# What comes next is a little more advanced and starts to venture out of scope of what we covered today


# Run the code on your own first, and try to interperet what is going on with the resulting data frames.
# Call an instructor once you've done so!


# Linear model of variables which predict a CHD incident
log_model = glm(TenYearCHD ~ ., data = framingham, family = "binomial")

model_summary = summary(log_model)

coef_data = data.frame(
  Variable = rownames(model_summary$coefficients),
  Coefficient = model_summary$coefficients[, "Estimate"],
  PValue = model_summary$coefficients[, "Pr(>|z|)"]
)


ggplot(framingham, aex(x = male, y = ))





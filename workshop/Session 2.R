# ROTO Coding Workshop
# Fall 2024
# 
# Session 2 - *** Working with data frames ***



#### 0.0 - **** Install tidyverse  ****

# run install.packages("tidyverse") if you have not already


#### 0.1 - Load our libraries

# Session > Clear workspace (data might be loaded still from Session 1)

# Generally we load our libraries first. These libraries contain functions we use that are NOT already in base R
library(tidyverse) # this is a widely used library of functions for manipulating data frames
library(ggplot2) # this is a widely used library of functions developed to make graphs, plots and charts. It's actually already in tidyverse anyways







#### 1.0 - **** Reading Data into R ****

# R is a powerful data analysis programming language. But before we can analyze any data, we need to load the data into our R environment

# The data that we will be working with next is about spotify songs. We got this data set from the website Kaggle

# Data files can take on many forms and you will encounter all sorts of file formats along the way that are specific to the needs of a certain analysis.

# One of the most common file formats for data frames is the .csv file. 
# CSV stands for comma-separated-values, and .csv simply instructs the computer on how to parse the information in the file.

# A convenient feature of .csv files is that we can also view, edit and save them in excel!
# ... we can also save normal excel (.xlsx) files as .csv, and load them into R.
# R is very good at working with .csv files


####  Set our working directory

# In order to load our data frame that is a .csv file into R, we need to tell R where the file is located on our computer
# To do this we set a working directory, and tell R to look for that file relative to the location of our working directory
getwd()
setwd( "/workshop")


# Let's load our .csv file containing spotify data
# object =  read.csv( path to file, file encoding)
# ?read.csv()
spotify = read.csv( 'data/spotify/top_10000_1960-now.csv', fileEncoding = 'UTF-8-BOM') # UTF-8-BOM is important for mac-windows compatibility

# We can now view the data frame object in our enviornment tab!

print(spotify) # to much! try head() instead
head(spotify)




#### 2.0 - *** Investigate properties of our Spotify data frame ***

# how big is our dataframe?
dim(spotify)
# what data are we tracking?
colnames(spotify)
# ** Structure: every ROW is an individual song. Every COLUMN is a property/feature/variable of that song

# What classes/types are some of these features?
class(spotify$Tempo)
class(spotify$Copyrights)





# Next, let's investigate the variable Popularity; min, max, range, mean, median
# Since we have 9999 songs, its going to be hard to get a sense of these metrics just by looking
# ... so we will use a few functions

max(spotify$Popularity, na.rm = TRUE) # na.rm = TRUE tells the max/min functions to remove missing values (NAs) before calculating. Wont work otherwise!
min(spotify$Popularity, na.rm = TRUE)
# looks like Popularity is on a percent scale

mean(spotify$Popularity)
median(spotify$Popularity)


# Let's use a basic histogram plot to look at the distribution of Popularity scores
data = spotify$Popularity
hist(data) # wow look at all the 0 popularity! about 3000 songs!! :O
hist(data, breaks = 50)





#### *** Exercise 1 

# (1) For the columns Tempo, Energy, and Loudness, determine the range (max - min).
#     Hint: will need to use na.rm argument in the functions


range.tempo
#range.energy =
#range.loudness = 
  

# (2) Also plot a histogram for each!


  
  
  


#### 3.0 - *** Extracting Specific information from our spotify data frame that we care about ***

# Session > Clear workspace

# When we clear workspace, we need to reload our original data too:
spotify = read.csv( 'data/spotify/top_10000_1960-now.csv', fileEncoding = 'UTF-8-BOM')



### 3.1 - Popular Dua Lipa Songs

# Let's make a new df of only popular songs. B- and higher!
popular.songs = subset(spotify, Popularity > 80)



# We <3 Dua Lipa
# From popular.songs, can we extract only those by Dua Lipa??
pop.songs.by.dua = subset( popular.songs, popular.songs$Artist.Names == "Dua Lipa")

# But what if Dua isn't the only artist, or is a feature artist? the code above would miss those songs.

# We can find matches to a string in a column with grepl()
# type ?grepl() in console
# grepl( "string", data/column to look in )

grepl("Dua Lipa", popular.songs$Artist.Names) # what does this return?
# a vector as long as the # rows of our popular.songs data frame with true or false if it found a match for
# "Dua Lipa" in the Artist.Names column

dua.TF = grepl("Dua Lipa", popular.songs$Artist.Names)

pop.songs.with.dua = subset( popular.songs, dua.TF)
# Now we have them all :)

# Okay now lets select only a few of the features (columns) rather than all 35!
pop.dua.summary = pop.songs.with.dua[, c("Track.Name","Popularity","Energy", "Tempo")] # df[row, column]



# We learned how to read data into R with read.csv().
# Let's now save our dataframe using write.csv()
getwd()
write.csv(pop.dua.summary, file = 'data/spotify/summary of popular dua songs.csv', row.names = FALSE)



## 3.2 - Unique entries in a column
# It's sometimes helpful to know how many unique entries we have of something in a column

# Since we have 9998 unique songs, can we figure out how many unique artists there are among these?
artists = unique(spotify$Artist.Names) # vector of artists!!!
print(artists)
length(artists)

# in one line:
length(unique(spotify$Artist.Names))






## **** Exercise 2 - 10-15 Mins with Spotify df **** 


# (1) Subset spotify into a new df called dance.songs, which contains only songs only where both of these criteria are met:
#     a) Danceability is greater than the median Danceability
#     b) Tempo is greater than the median Tempo
#         ... don't forget na.rm = TRUE argument
#         ... the and symbol is &

dance.songs = subset( spotify, )


# (2) Subset spotify into a new df called fire.songs that has the word "Fire" in the Track.Name
# hint: use grepl() - look around lines 150-160

fire.songs = subset( , )


# (3) Select only the following columns from fire.songs and leave the rest out: (1) song name, (2) artist, (3) popularity, (4) tempo, (5) energy

cols = c("", "", "", "", "", "")
fire.songs = fire.songs[ , ] # remember [Row, Column]


# (4) Make a new column in fire.songs called dance.song that is TRUE if the 1st conditions from (1) is met, or FALSE otherwise
#    (Danceability is greater than the median Danceability):

fire.songs$dance.song = ifelse( , , )


# (5) Of our 9998 songs in Spotify, how many labels are there?
# hint, use length() and unique() - look around lines 175












#### 3.0 - *** using Tidyverse functions to manipulate our data frames more efficiently ***

# Session > Clear workspace


# So far we have been editing our data frames using base R syntax
# Another popular and flexible way to edit and manipulate our data frames comes from functions in the tidyverse package
# If you haven't already, load tidyverse
library(tidyverse)

spotify = read.csv( './data/spotify/top_10000_1960-now.csv', fileEncoding = 'UTF-8-BOM')



#### 3.1 - *** filter() to subset data
# previously, we used subset() or df[,] syntax. With tidyverse we can use filter()

popular.songs = spotify[spotify$Popularity > 80, ]
# OR
popular.songs = subset(spotify, Popularity > 80)

# Alternatively, we can use filter()
# lets look up the arguments; type ?filter() in console

popular.songs = filter(.data = spotify, Popularity > 80)



# Filter lets us easily subset based on lots of conditions, which is harder to do with subset()
filtered.songs1 = filter( .data = spotify, Popularity >= 80, Energy >= 0.50 ) # separate each filter criteria with comma ,

# We can break out the code onto multiple lines for readability! 
# As long as the parenthesis are there, and the function syntax is correct, R does not care about spaces or new lines
filtered.songs2 = filter(
                        .data = spotify, # spotify data frame
                        Popularity >= 80, # need the comma between every filter criteria
                        Artist.Names %in% c("Elton John", "Taylor Swift")
                        )




#### 3.2 - *** mutate() to add and edit columns

# previously, we used $ to address columns and make new columns. 
popular.songs$Hit.factor = popular.songs$Energy*100 + popular.songs$Danceability*100

# With tidyverse we can use the function mutate() to do the same thing
# type ?mutate() in console to see the arguments

popular.songs = mutate(.data = popular.songs, Hit.factor = Energy*100 + Danceability*100 )
# we do not have to use $ to reference columns!




#### 3.4- *** THE PIPE %>% to chain tidyverse functions together

# What's AWESOME about these tidyverse functions, is that we can chain them together to execute in sequence with the "pipe"
# When we use the pipe to chain functions together, we do not have to fill in the data argument every time!

# What happens when we execute this?
my.songs = spotify %>%
  filter( Popularity >= 80 ) %>%
  mutate( Hit.factor = Energy*100 + Danceability*100 )



## We can do a lot with just  a few lines of code.

# Take our spotify data frame, and apply a pipe. The new data frame will by my.songs2
my.songs2 = spotify %>% 
  # filter by popularity B- or greater
  filter( Popularity >= 80 ) %>%
  mutate(
    Hit.factor = Energy*100 + Danceability*100,  # calculate new metric based on existing data
    Dance.song = ifelse( Tempo > 110, TRUE, FALSE) # make another new column based on our calculation
  ) %>%
  # report only the columns we care about with select()
  select( c("Track.Name", "Artist.Names", "Hit.factor", "Dance.song") ) 
  # "." says inherit data from prior step!






#### 3.0 - **** Perform calculations over individual groups using group_by() and summarise() ****

# Two more conventient tidyverse functions that work together to perform calculations over groups of data are
# group_by() and summarise()

popularity.by.artist = spotify %>%
  group_by( Artist.Names ) %>% # group the data by the Artist.Names
  summarise( mean.pop = mean(Popularity, na.rm = TRUE) ) # compute the mean popularity of each of those groups


record.label.pop = spotify %>%
  group_by(
    Label
  ) %>%
  summarise(
    popularity = mean(Popularity)
  )



## **** Exercise 3 - 10 minute Dplyr exercises

# (1) Use tidyverse functions to make a data frame called pop.dua.songs where:
#    (a) Popularity >= 80
#    (b) Artist.Names contains Dua Lipa
#    (c) A new column Vibration which = Liveliness + Valence
#     (d) A new column fast.song is TRUE if Tempo > 110

pop.dua.songs = spotify %>%
  filter( 
    grepl( , ),
    Popularity
  ) %>%
  mutate(
    Vibration,
    fast.song = ifelse( , , )
  )


# (2) Make a df summarising the mean Popularity and mean Danceability per artist, of only Artists with the Label "Warner Records"

warner.stats = spotify %>%
  filter(
  
  ) %>%
  group_by(  ) %>%
  summarise(
    mean.pop
    mean.dance
  )









#### 4.0 - **** Basic plotting with ggplot ****

## Clear Workspace!

spotify = read.csv( 'data/spotify/top_10000_1960-now.csv', fileEncoding = 'UTF-8-BOM')

# Let's first set up a data frame of the information we are interested in plotting.
# Can check out a few mean() calulations for a few artists

my.fav.artists = spotify %>%
  filter(
    Artist.Names %in% c("Pitbull", "Elton John", "Taylor Swift")
  ) %>%
  group_by( Artist.Names) %>%
  summarise(
    mean.pop = mean( Popularity ), #
    mean.dance = mean( Danceability ),
    mean.loud = mean( Loudness ),
    mean.energy = mean( Energy )
  )





# The basic skeleton of gggplot isn't too complicated
ggplot( data = my.fav.artists, aes(x = Artist.Names, y = mean.pop) ) +
  geom_bar( stat = "identity")

# Let's look at the arguments with ?ggplot() - what is each argument?
# ggplot( data, aes( x axis variable,  y axis variable)  ) 


# ggplot works in layers!
# we have to have the first line with ggplot() basically to tell R where to find the data, and what to plot from that data.
# then we add "layers" 

ggplot( data = my.fav.artists, aes(x = Artist.Names, y = mean.pop) ) +
  geom_bar( stat = "identity") + # plots bars!
  geom_point() # plots points!


# Now let's add in a default color scheme
ggplot( data = my.fav.artists, aes(x = Artist.Names, y = mean.pop, fill = factor(Artist.Names)) ) + # fill each Artist with a unique color
  geom_bar( stat = "identity") + 
  geom_point() 


# And let's also let's get rid of the weird grey background...
ggplot( data = my.fav.artists, aes(x = Artist.Names, y = mean.pop, fill = factor(Artist.Names)) ) +
  geom_bar( stat = "identity") + 
  geom_point() +
  theme_bw() # change the look of the plot background









#### *** 5.0 - Plotting multiple stats; reshape a wide data frame to long format

# *** What if we wanted to plot all 4 stats from my_favorite_artists? at the same time
#     only lets us plot two columns at a time; an x variable an a y variable: ggplot(data, aes(x = , y = ))
#     However, we can reshape our data frame so that multiple variables are stored in one column

my.fav.artists_long = pivot_longer( my.fav.artists, cols = c("mean.pop", "mean.dance", "mean.loud", "mean.energy") ) 


# plot all 4 variables as points, with a color for each variable
ggplot( my.fav.artists_long, aes(x = Artist.Names, y = value, color = factor(name)) ) +
  geom_point() +
  theme_bw()


# plot all 4 variables as bars, with a different graph for every stat!
ggplot( data = my.fav.artists_long, aes(x = Artist.Names, y = value, fill = factor(name)) ) +
  geom_bar( stat = "identity") + 
  theme_bw() +
  facet_wrap(~name, scale = "free") # make a new plot for every unique name!




### Exercise 3  - 5 minutes ####


# (A) Make a bar graph of each artist's mean energy
#     Start by copying and pasting code from above!


















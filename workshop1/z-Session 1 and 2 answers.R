
#### Session 1 - *** Basic data types and data structures *** ####




#### *** Exercise 1 - 10 Minutes to practice working with vectors ****

myvector = c(195:51)
print(desc)

# 1) What is the value at the 50th element/position of this vector? Type the code below. 
myvector[50]

# 2) Make a new object called sum that is equal to the value at the 50th element plus the 60th.
#   Then print the value of sum
sum = myvector[50] + myvector[60]
print(sum)


# 3) What is the 50th value divided by the last value of the vector?
#     ... Sure we can see that the last value is 51, but how would you address the object at that specific position?
# Hint: use the length() function to determine the index of the last position!

# multiple line approach:

value_50th = myvector[50]

vector_length = length(myvector)
value_last = myvector[vector_length]

quotient = value_50th/value_last

# OR in one line!
quotient = myvector[50]/myvector[length(myvector)]





#### **** Exercise 2 - 5 minutes to practice working with matrices ****

## Session > Clear workspace

# (1) Run the following code in order:

rownames = c("Los Angeles", "Chicago", "Seattle", "New York", "Boston")

colnames = c("Cars", "SUVs", "Motorcycles")

vehicles_per_city = matrix(NA, nrow = 5, ncol = 3, dimnames = list(rownames, colnames))

print(vehicles_per_city)

# (2) Replace every value in the the entire ROW for New York with 6000
#     Edit the following code:

vehicles_per_city[ 4, ] = 6000 # [ROW, COL]
print(vehicles_per_city)


# (3) Replace the value for Seattle Motorcycles with 3333
# ... look at lines 250-265 above

vehicles_per_city[3 , 3] = 3333 # [ROW, COL]
print(vehicles_per_city)


# (4) Replace all values in the COLUMNS Cars and SUVs with 2024 using only one line of code!
vehicles_per_city[ ,c(1,2)] = 2024
print(vehicles_per_city)





#### Exercise 3 - **** 10 minutes - Dataframes Practice Examples ****

# load the data frame iris which is built into R
data(iris) # might take a moment to load
head(iris)



# A) How many columns and rows does the iris df have?
dim(iris)
nrow(iris)
names(iris)

# B) Add a column called Petal.Area that is equal to the petal width times the petal length
#     Multiplication sign is the star symbol:  *
#     Remember, R is case-sensitive!
names(iris)
iris$Petal.Area = iris$Petal.Length * iris$Petal.Width


# C) Make a new df called subset_species that only has the Species "setosa" OR "virginica"
#   look around lines 283-287 for help

subset_species = subset(iris, Species %in% c("setosa","virginica") )


# D) In the new dataframe from (C):
# make a new column called Season that is "spring" if the flower Species == "setosa", OR is "fall" if the Species == "virginica"
#   Look around line 353 above!
#   You will probably have to do this in two similar lines of code
subset_species$Season = ifelse( subset_species$Species == "setosa" , "spring", NA )
subset_species$Season = ifelse( subset_species$Species == "virginica" , "fall", subset_species$Season )






#### Session 2 - *** Working with data frames *** ####

library(tidyverse) 
library(ggplot2) 

spotify = read.csv( 'data/spotify/top_10000_1960-now.csv', fileEncoding = 'UTF-8-BOM') # UTF-8-BOM is important for mac-windows compatibility





#### *** Exercise 1 

# (1) For the columns Tempo, Energy, and Loudness, determine the range (max - min).
#     Hint: will need to use na.rm argument in the functions
range.tempo = max(spotify$Tempo, na.rm = TRUE) - min(spotify$Tempo, na.rm = TRUE)
range.energy = max(spotify$Energy, na.rm = TRUE) - min(spotify$Energy, na.rm = TRUE)
range.loudness = max(spotify$Loudness, na.rm = TRUE) - min(spotify$Loudness, na.rm = TRUE)


# (2) Also plot a histogram for each!
hist(spotify$Tempo)
hist(spotify$Energy)
hist(spotify$Loudness)







## **** Exercise 2 - 10-15 Mins with Spotify df **** 


# (1) Subset spotify into a new df called dance.songs, which contains only songs only where both of these criteria are met:
#     a) Danceability is greater than the median Danceability
#     b) Tempo is greater than the median Tempo
#         ... don't forget na.rm = TRUE argument
#         ... the and symbol is &

dance.songs = subset( spotify, Danceability > median(Danceability, na.rm = TRUE) & Tempo > median(Tempo, na.rm = TRUE) )


# (2) Subset spotify into a new df called fire.songs that has the word "Fire" in the Track.Name
# hint: use grepl() - look around lines 150-160
fire.songs = subset( spotify, grepl("Fire", Track.Name))


# (3) Make a dataframe called fire.songs 2 that contains ONLY the following columns: (1) Track.Name, (2) Artist.Names, (3) Popularity, (4) Tempo, (5) Energy
names(fire.songs)
cols = c("Track.Name", "Artist.Names", "Popularity", "Tempo", "Energy")
fire.songs2 = fire.songs[ , cols ] # remember [Row, Column]


# (4) Make a new column in fire.songs2 called Dance.song that is TRUE if the 1st conditions from (1) is met, or FALSE otherwise
#    (Danceability is greater than the median Danceability):
# recall formant: ifelse(condition, result if TRUE, result if FALSE)
fire.songs$dance.song = ifelse( fire.songs$Danceability > median(fire.songs$Danceability, na.rm = TRUE), TRUE, FALSE)


# (5) Of our 9998 songs in Spotify, how many labels are there?
# hint, use length() and unique() - look around lines 175

labels = unique(spotify$Label)
length(labels)







## **** Exercise 3 - 10 minute Dplyr exercises

# (1) Use tidyverse functions to make a data frame called pop.dua.songs where:
#    (a) Popularity >= 80
#    (b) Artist.Names contains Dua Lipa
#    (c) A new column Vibration which = Liveliness + Valence
#     (d) A new column fast.song is TRUE if Tempo > 110

pop.dua.songs = spotify %>%
  filter( 
    grepl( "Dua Lipa", Artist.Names),
    Popularity >= 80
  ) %>%
  mutate(
    Vibration = Liveness + Valence,
    fast.song = ifelse( Tempo > 110, TRUE, FALSE)
  )


# (2) Make a df summarising the mean Popularity and mean Danceability per artist, of only Artists with the Label "Warner Records"

warner.stats = spotify %>%
  filter(
    Label == "Warner Records"
  ) %>%
  group_by( Artist.Names ) %>%
  summarise(
    mean.pop = mean(Popularity, na.rm = TRUE),
    mean.dance = mean(Danceability, na.rm = TRUE)
  )




### Exercise 4  - free form 


# (A) Make a bar graph of each artist's mean energy from the data frame my.favorite.artists
#     Start by copying and pasting code from above!

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

ggplot( data = my.fav.artists, aes(x = Artist.Names, y = mean.energy) ) +
  geom_bar( stat = "identity")
























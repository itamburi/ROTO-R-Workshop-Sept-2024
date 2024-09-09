# ROTO Coding Workshop
# Fall 2024
# Session 1 - *** Basic data types and data structures ***



#### 0.0 - **** import our scripts and data ****


# Go to the following Google Drive link, download the zip file, and upload the zip file to R server
# https://drive.google.com/drive/folders/1_5a-cJ-1xMuCGiMWsxRdlMB3Jfqq0OR4


#### 0.1 - **** RStudio Interface ****


# - 4 windows: Script, console, environment, files/plots/help
# - cmd + enter / cntrl + enter to execute a line of code; OR Run button at the top of the window
#       > can also highlight a block of code and execute

#  hashtag/pound in front of the line to comment

print("Hello World!")
# what happens?





#### 0.2 - **** Discussion ****
#
# (1) What is programming, and what is coding?
#
# (2) What types of tasks do you think require programming and coding? What are some applications?
#
# (3) Coding creates instructions for a computer to interpret.
#
# (4) What is data? What are some examples you are familiar with? What does it look like and how is it structured?




#### 1.0 - *** Storing information in memory - data objects ***

# We can instruct R to store information in memory so that we can access it later
# We can refer to these items saved into memory broadly as "objects" or data objects

name1 = "Ian" # the string "Ian" assigned to the object 'name'
age1 = 100 # assign/store the number 28 in the object age

name1 <- "Ian" # <- and = are exactly the same
age1 <- 100 



# there are several data types in R, but the two we encounter most often are "Strings" and "Numeric".
# These are basically just text and numbers

name2 = "Nick"
age2 = 50

sum.age = age1 + age2


# type ?print() into console
print(sum.age) # print is a function that prints the values of the specified object


# what happens if we try to perform math on different data types?
value = name1 + age1


# Rule about object names: they cannot begin with a number!
4names = c("Ian", "Nellie", "Luis", "Negin") # not allowed!

four.names = c("Ian", "Nellie", "Luis", "Negin")


# Rule about R: everything is CASE-SENSITIVE
sum.age = Age1 + aGE2 # nope!
sum.age = age1 + age2 # okay :D







#### 2.0 - *** Vectors ***

# How to clear workspace: Session > Clear Workspace
# This clears everything from our local memory!


# Vectors are a fundamental data structure in R
# Vectors are basically lists of information. All items in a vector must be of the same data type (all text or all numbers)
# You can think of vectors as 1-Dimensional data structures


# basic syntax is c( values separated by commas )
pets = c("cat", "dog", "bird", "hamster", "turtle")
print(pets)


integers1 = c(1, 2, 3, 4, 5)

integers2 = c(11, 62, 90, 44)

integers3 = c(6:12) # creates a sequence
print(integers3)

integers4 = c(99, 55, 1:100)
print(integers4)


# We can reference the object at a specific index of a vector
pets[3]
integers3[2]

value = integers3[2] + integers1[5]


# what happens when we try to mix numeric and string in one vector?
mix = c("cat", "dog", 4, 5)
class(mix) # coerces, or "forces" the numerics to strings




# Vector arithmetic

integers4 = c(1, 1, 1, 5)
integers5 = c(1, 2, 2, 1)
sum = integers4 + integers5
print(sum)

div = integers4/integers5

# Combining Vectors together: concatenates or appends vectors

integers6 = c(integers4, integers5)
length(integers4)
length(integers5)
length(integers6)

print(integers6)





#### *** Exercise 1 - 10 Minutes to practice working with vectors ****

myvector = c(195:51)
print(desc)

# 1) What is the value at the 50th element/position of this vector? Type the code below. 


# 2) Make a new object called sum that is equal to the value at the 50th element plus the 60th.
#   Then print the value of sum
sum
print()


# 3) What is the 50th value divided by the last value of the vector?
#     ... Sure we can see that the last value is 51, but how would you address the object at that specific position?
# Hint: use the length() function to determine number of the last position!

# multiple line approach:

value_50th
value_last
quotient = value_50th/value_last

 
# OR in one line!
quotient







#### 3.0 - *** Matrices ***

# Clear workspace: Session > Clear Workspace

# A matrix (plural: matrices) is another fundamental data structure in R
# Its basically like a 2-Dimensional vector
# We can build 2-D matrices by stacking Vectors vertically!

# rbind() is a function that combines vectors by stacking them. Creates a 2-D matrix! (like a table)
birds = c("parrot", "cockatoo", "canary")
cats = c("tabby", "siamese", "persian")

pets = rbind(birds, cats) # rbind()
print(pets)



# what happens here?:
dogs = c("COYOTE", "pomeranian", "bulldog", "chihuahua")

pets2 = rbind(pets, dogs)

print(pets2)



# lets remove "COYOTE" from dogs. Its probably not a good pet anyways
dogs = dogs[c(2,3,4)]
print(dogs)

pets2 = rbind(pets, dogs)
print(pets2)





# We can also build a matrix using the matrix() function, but TBH we don't often have to do this

m = matrix(data = "cat", nrow = 3, ncol = 3) # pay attention to our arguments
# typing ?matrix() into the console will tell us what the arguments mean


sequence = c(1:9)
m2 = matrix( sequence, 3, 3) # notice the order it fills the matrix m2




### Session > Clear Workspace


# Let's manually build a practical example
# In practice you would rarely have to build a matrix from scratch
# However it illustrates the principles well!!

rownames = c("Los Angeles", "Chicago", "Seattle", "New York", "Boston")
colnames = c("Cars", "SUVs", "Motorcycles")

# build an empty matrix of vehicles in every city.
# What does NA mean?
vehicles_per_city = matrix(NA, nrow = 5, ncol = 3, dimnames = list(rownames, colnames)) # order matters here in list()

# dim() outputs dimensions
dim(vehicles_per_city) # row, col
print(vehicles_per_city)


# Let's assign certain numbers to certain entries in the matrix.
# ... 3200 SUVs in Boston:

vehicles_per_city[5,2] = 3200 # [ROW #, COLUMN #]
print(vehicles_per_city)
# In R, when referencing the index position of a matrix, the order is always matrix[row, column]


vehicles_per_city[, 3] = 9999 # [row, col]
print(vehicles_per_city)

vehicles_per_city[2, ] = 721
print(vehicles_per_city)

vehicles_per_city[c(3,5), ] = 6644
print(vehicles_per_city)

vehicles_per_city[] = NA
print(vehicles_per_city)

# dimesnions
dim(vehicles_per_city) # row, col






#### **** Exercise 2 - 5 minutes to practice working with matrices ****

## Session > Clear workspace

# (1) Run the following code in order:

rownames = c("Los Angeles", "Chicago", "Seattle", "New York", "Boston")

colnames = c("Cars", "SUVs", "Motorcycles")

vehicles_per_city = matrix(NA, nrow = 5, ncol = 3, dimnames = list(rownames, colnames))


# (2) Replace every value in the the entire ROW for New York with 6000
#     Edit the following code:
vehicles_per_city[ , ] = 6000 # [ROW, COL]


# (3) Replace the value for Seattle Motorcycles with 3333
# ... look at lines 250-265 above



# (4) Replace all values in the COLUMNS Cars and SUVs with 2023 using only one line of code!








#### 4.0 - *** Data frames ****


### Session > Clear Workspace


# Data frames are one of the most common data structures in R
# The rest of the data we will look at today are in the form of data frames
# Basically data frames are glorified data tables

# Why are data frames so great? LOTS of reasons But mainly:
#   dfs can elegantly handle mixed data types (e.g. strings, numerics, logical)
#   dfs can be addressed by the column name (unlike matrices where we have to address the index)
#   ... df positions can also be address by index df[i,j] in a pinch


data(mtcars) # mtcars is a data frame that comes with R. Its a good demonstrative example

head(mtcars) # prints just the first few rows in the console

# Let's take a moment to appreciate the format:
  # every ROW is an individual car (32 observations)
  # every COLUMN records a property of that car (11 variables)
  # *** When we handle data frames in R, they are generally in this format
  #     where ROWS are individuals/replicates, and COLUMNS are properties or features of those individuals


# a few ways to determine the dimensions of our df
dim(mtcars) # [Row, Col]
length(mtcars)
ncol(mtcars)
nrow(mtcars)


# we can reference a column in a df with the $ symbol
mtcars$hp
horsepower = mtcars$hp # the column is a vector!
print(horsepower)


# We can make a new column by writing data$newcol = ...
mtcars$hp.per.lb = mtcars$hp / mtcars$wt
# Made a new column for horsepower per pound



# ifelse() - lets see what this function does by typing ?ifelse() in the console
# basically:
#         if( test case,   value if true,   value if false )

# make a new column "high.efficiency" that if mpg > 29, the value for "high.efficiency" is TRUE

mtcars$high.efficiency = ifelse( mtcars$mpg > 29, TRUE, FALSE)

class(mtcars$high.efficiency) # Logical data type. What is this?





# Let's subset our dataframe for only high efficiency cars!
#
# You will later learn many ways to subset a data frame
# But here are two basic ways / common approaches that do the same thing:
#

# (1) Address the columns where the rows meet our condition:
# We use "==" when we want to test if values are equal to one another (NOT "="; this is only used for assignment)

subset_df = mtcars[mtcars$high.efficiency == TRUE, ] # recall [row, column] ... the ordering in this way may look counter-intuitive
                                                    # just think "rows where the column high.eff is TRUE"

# (2) Use the subset() function: subset(df, condition)
subset_df = subset(mtcars, high.efficiency == TRUE) # a bit easier to read


subset_df = subset(mtcars, cyl != 4)
subset_df = subset(mtcars, cyl %in% c(4,8) )
# & (and) ; | (OR)
subset_df = subset(mtcars, mpg > 15 & cyl == 4)
subset_df = subset(mtcars, mpg > 15 | cyl == 4)



# What if you wanted to select specific columns and exclude all others?
subset_df = mtcars[,c("mpg","hp")] # [row, column]




#### 1.5 - **** 10 minutes - Practice Example ****

# load the data frame iris which is built into R
data(iris) # might take a moment to load
head(iris)



# A) How many columns and rows does the iris df have?




# B) Add a column called Petal.Area that is equal to the petal width times the petal length
#     Multiplication sign is the star symbol:  *
#     Remember, R is case-sensitive!

iris$Petal.Area




# C) Make a new df called subset_species that only has the Species "setosa" OR "virginica"
#   look around lines 283-287 for help

subset_species = subset( , )



# D) In the new dataframe from (C):
# make a new column called Season that is "spring" if the flower Species == "setosa", OR is "fall" if the Species == "virginica"
#   Look around line 353 above!
#   You will probably have to do this in two similar lines of code
subset_species$Season # = ifelse( test case , result if true, result if false )
subset_species$Season 




















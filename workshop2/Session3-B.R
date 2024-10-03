# ROTO Coding Workshop
# Fall 2024
# 
# Session 3B - *** Intro to ML ***

#### **** PCA and KNN with Iris ****

# Clear workspace

# PCA w/ iris

#Install required packages
install.packages('devtools')
install.packages('datasets')
install.packages('psych')
install.packages('nnet')
install.packages('caret')
install.packages('class')
install_github("vqv/ggbiplot")



library(psych)
library(devtools)
library(ggbiplot)
library(nnet)
library(datasets)

# Load the iris dataset and check its structure and summary
data("iris")
str(iris)   # Check the structure of the iris dataset
summary(iris)  # Print summary statistics of the iris dataset

# Check your understanding!: What are the key variables in the iris dataset, and what do they represent?

# Divide the dataset into training and test datasets.
set.seed(111)  # Set seed for reproducibility
ind <- sample(2, nrow(iris),
              replace = TRUE,
              prob = c(0.8, 0.2))  # Randomly divide data into 80% training and 20% testing
training <- iris[ind==1,]  # Training data
testing <- iris[ind==2,]   # Testing data

# Check your understanding!: Why do we divide the dataset into training and testing sets?
# Some people call this 'Cross validation'

# Check the correlation between independent variables by ignoring the species factor variable
pairs.panels(training[,-5],
             gap = 0,
             bg = c("red", "yellow", "blue")[training$Species],
             pch=21)

# Check your understanding!: What does the pairs panel plot tell us about the relationships between the variables?

# Lower triangles provide scatter plots and upper triangles provide correlation values.
# Petal length and petal width are highly correlated. Similarly, sepal length and petal length,
# sepal length, and petal width are also highly correlated.
# This leads to multicollinearity issues. If we predict the model based on this dataset, it may be erroneous.
# One way to handle these kinds of issues is by using PCA.

# Principal Component Analysis is based only on independent variables, so we remove the fifth variable (Species) from the dataset.
pc <- prcomp(training[,-5],
             center = TRUE,
             scale. = TRUE)

# What kind of structure does prcomp produce?
attributes(pc)

# Check your understanding!: What are the components of the PCA object 'pc' and what do they represent?

# Explore the structure of the PCA result
pc$scale  # Scale function is used for normalization
pc$rotation  # Matrix of variable loadings
pc$center  # Centroids of each variable
print(pc)  # Print the PCA model

# For example, PC1 increases when Sepal Length, Petal Length, and Petal Width increase, indicating positive correlation.
# PC1 increases while Sepal Width decreases indicating negative correlation.

# Summary of the PCA model
summary(pc)

# Check your understanding!: How much of the variability in the data is captured by the first principal component? What about the second component?
#What about the cumulative explained variability of the first 3 principal components?

# Plot the cumulative variance explained by the principal components
variance_explained <- summary(pc)$importance[3,]
plot(variance_explained, type='b', xlab='Principal Component', ylab='Cumulative Proportion of Variance Explained', 
     main='Cumulative Variance Explained by Principal Components')

# Plot PC1 vs PC2
plot(pc$x[,1], pc$x[,2], col=training$Species, xlab="Principal Component 1", ylab="Principal Component 2", 
     main="PC1 vs PC2", pch=19)
#Nice, now let's add a legend
legend("topright", legend=levels(training$Species), col=1:3, pch=19)

# Question: What can you infer about the separation of species from the PC1 vs PC2 plot?

# Plot PC2 vs PC3
plot(pc$x[,2], pc$x[,3], col=training$Species, xlab="Principal Component 2", ylab="Principal Component 3", 
     main="PC2 vs PC3", pch=19)
legend("topright", legend=levels(training$Species), col=1:3, pch=19)

# Question: How does the separation of species in the PC2 vs PC3 plot compare to that in the PC1 vs PC2 plot?

# In this case, the first two components capture the majority of the variability.

# Create a scatterplot based on the principal components to see if the multicollinearity issue is addressed.
# Orthogonality of PCs
pairs.panels(pc$x,
             gap=0,
             bg = c("red", "yellow", "blue")[training$Species],
             pch=21)

# Check your understanding!: How does the pairs panel plot of the principal components help address multicollinearity?
# What do the numbers in the top right represent?

# Generate a biplot to visualize the PCA results
g <- ggbiplot(pc,
              obs.scale = 1,
              var.scale = 1,
              groups = training$Species,
              ellipse = TRUE,
              circle = TRUE,
              ellipse.prob = 0.68)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal',
               legend.position = 'top')
print(g)

# PC1 explains about 73.7% and PC2 explains about 22.1% of the variability in the data.
# Arrows close to each other indicate high correlation.
# For example, Sepal Width is weakly correlated with other variables.
# Another way to interpret this plot is that PC1 is positively correlated with Petal Length, Petal Width, and Sepal Length,
# and PC1 is negatively correlated with Sepal Width.
# PC2 is highly negatively correlated with Sepal Width.
# The biplot is an important tool in PCA to understand what is going on in the dataset.

# Check your understanding!: What insights can you gather from the biplot about the relationships between the variables?

# Prediction using Principal Components

trg <- predict(pc, training)  # Apply PCA transformation to training data
# Add the species column information to 'trg'.
trg <- data.frame(trg, training[5])
tst <- predict(pc, testing)  # Apply PCA transformation to testing data
tst <- data.frame(tst, testing[5])

# Multinomial Logistic Regression with first two PCs
# 
# Because our dependent variable has 3 levels, we will use multinomial logistic regression.

trg$Species <- relevel(trg$Species, ref = "setosa")  # Relevel the species factor to use 'setosa' as the reference level
mymodel <- multinom(Species~PC1+PC2, data = trg)  # Fit the multinomial logistic regression model
summary(mymodel)

# Check your understanding!: What does it mean to set a reference?

# Model output
multinom(formula = Species ~ PC1 + PC2, data = trg)
# The model output shows the significance of the first two principal components, 
# because the majority of the information is available in these components.

# Confusion Matrix & Misclassification Error – training
p <- predict(mymodel, trg)  # Predict on training data
tab <- table(p, trg$Species)  # Create confusion matrix
tab

# Calculate the misclassification error on the training dataset
1 - sum(diag(tab))/sum(tab)

# Check your understanding!: How do you interpret the confusion matrix and misclassification error for the training data?

# Confusion Matrix & Misclassification Error – testing
p1 <- predict(mymodel, tst)  # Predict on testing data
tab1 <- table(p1, tst$Species)  # Create confusion matrix for testing data
tab1

# Calculate the misclassification error on the test dataset
1 - sum(diag(tab1))/sum(tab1)

# Check your understanding!: How does the misclassification error for the test data compare to the training data, and what might this indicate about the model's performance?


#Section 2
# Clear workspace
# KNN w/ iris

# The KNN - K Nearest Neighbor algorithm is a non-parametric supervised machine learning model.
# It is used for both classification and regression. It predicts a target variable using one or multiple independent variables. 
# The k-NN algorithm stores all the available data and classifies a new data point based on similarity. 
# This means when new data appears, it can be easily classified (or sorted) into a category by the k-NN algorithm.

# We use Euclidean Distance to find the distance between two points.

# Generally, we follow these steps to perform KNN:

# 1. Select the K value: number of Nearest Neighbors
# 2. Calculate the Euclidean distance from each datapoint to its K nearest neighbors.
# 3. Take the K nearest neighbors as per the calculated Euclidean distance.
# 4. Among these K neighbors, count the number of datapoints in each category.
# 5. Classify the new datapoint to the category for which the number of neighbors is maximum.

# Let's use the iris dataset for this example
library(caret)
library(class)
data("iris")
dataset <- na.omit(iris)  # Remove any missing values
# k-nearest neighbors with an Euclidean distance measure is sensitive to magnitudes and hence should have scaled features to weigh in equally.
dataset[,-5] <- scale(dataset[,-5])

# Let's begin by splitting the data into a training set and a testing set
validationIndex <- createDataPartition(dataset$Species, p=0.70, list=FALSE)

train <- dataset[validationIndex,] # 70% of data for training
test <- dataset[-validationIndex,] # remaining 30% for testing

# Question: Why do we need to scale the features before applying the KNN algorithm?

# Question: How does the choice of K value affect the performance of the KNN model?

# Choosing a K value is critical for model accuracy! So how do we most objectively pick a K value?
# Let's use the Elbow plot method to search along a range of K's while we check model accuracy at every point!

# Using Caret
# Run algorithms using 10-fold cross-validation
trainControl <- trainControl(method="repeatedcv", number=10, repeats=3)
metric <- "Accuracy"

set.seed(7)
fit.knn <- train(Species~., data=train, method="knn",
                 metric=metric, trControl=trainControl)
knn.k1 <- fit.knn$bestTune # keep this initial K value for testing with the knn() function in the next section
print(fit.knn)
plot(fit.knn)

# Question: What does the Elbow method show us, and why is it useful in choosing K?

set.seed(7)
prediction <- predict(fit.knn, newdata = test)
cf <- confusionMatrix(prediction, test$Species)
print(cf)
cf_mat_table <- cf$table
cf_misclassification_error <- 1 - sum(diag(cf_mat_table)) / sum(cf_mat_table)
cf_misclassification_error


# Using this method, we see K=9 is most appropriate because it is most accurate.
# Let's run prediction with the test dataset and create a confusion matrix.

# Choosing a K value
# One uncomplicated way to choose an initial K is to take the square root of the number of observations.
# USING KNN FUNCTION
initial_k <- sqrt(NROW(dataset))
initial_k

# Let's check K=12 and K=13
# Run KNN with K=12
knn.12 <- knn(train=train[,-5], test=test[,-5], cl=train$Species, k=floor(initial_k))
knn.13 <- knn(train=train[,-5], test=test[,-5], cl=train$Species, k=ceiling(initial_k))

# Extract confusion matrix table from cf.12 and calculate the misclassification error
cf_matrix_12 <- cf.12$table
misclassification_error_12 <- 1 - sum(diag(cf_matrix_12)) / sum(cf_matrix_12)
misclassification_error_12

# Extract confusion matrix table from cf.13 and calculate the misclassification error
cf_matrix_13 <- cf.13$table
misclassification_error_13 <- 1 - sum(diag(cf_matrix_13)) / sum(cf_matrix_13)
misclassification_error_13

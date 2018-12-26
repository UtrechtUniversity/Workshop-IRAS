# Recognize written digits with Support Vector Machines
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
# License:      BSD-3-Clause
#

library("e1071")            # library for SVM functions
library("raster")


# The digits dataset for training
# the digits are digitized in a 8 * 8 raster with 16 grey values

train_set     <- read.csv("data/digits_trainset.csv", header= FALSE)
train_images  <- train_set[1:64]
train_targets <- as.factor(train_set[[65]])

# How does an image look like?
mnist_image   <- matrix(as.numeric(train_images[230,]), nrow=8, ncol=8, byrow = TRUE)
mnist_label   <- train_targets[230] 
plot(as.raster(mnist_image/16))
cat("The poltted digit has been labeled as a: ", mnist_label, "\n") 


# The digits dataset for testing
#
test_set     <- read.csv("data/digits_testset.csv", header= FALSE)
test_images  <- test_set[1:64]
test_targets <- as.factor(test_set[[65]])

# Hyperparamaters of the model
gamma <- 2^-7 # `gamma` is some parameter of the kernel function
cost  <- 2^0  # `cost` is penalty when a point is on the wrong side of the hyper plane 

# It is interesting to know how long it takes the computer to fit a model.
# Let's look at the clock now and at the end and compare both clock times
#
clock_start <- Sys.time()

# Fit a Support Vector Classifier
model <- e1071::svm(x =     train_images,
                    y =     train_targets, 
                    gamma = gamma,
                    cost =  cost,
                    scale = FALSE)

# Duration of training session
#
clock_end <- Sys.time()
duration  <- as.numeric(clock_end - clock_start)


# Predict the values of the digits in the test dataset
prediction <- predict(object =  model, 
                      newdata = test_images)

# Accuracy measure to evaluate the result
  # How many predictions are correct or false
agreement <- table(prediction == test_targets)

  # Accuracy is defined as the fraction of correct predictions of all predictions
accuracy  <- agreement[2]/(agreement[1] + agreement[2])

# Establish the duration of training session
#
clock_end <- Sys.time()
duration  <- as.numeric(clock_end - clock_start)

# Print out the results
#
cat("Accuracy: ", accuracy,
    " with parameters C=", cost, 
    " and G=", gamma, 
    " in ", duration, " sec\n")


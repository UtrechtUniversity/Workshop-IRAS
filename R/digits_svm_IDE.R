# Recognize written digits with Support Vector Machines
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License:      BSD-3-Clause
#
library("e1071")
library("raster")

# Hyperparamaters of the model
gamma <- 0.1
cost  <- 1.0 

# The digits dataset (train dataset)
train_set     <- read.csv("data/digits_trainset.csv", header= FALSE)
train_images  <- train_set[1:64]
train_targets <- as.factor(train_set[[65]])

# Have a closer look at hand-written digits
mnist_image   <- matrix(as.numeric(train_images[230,]), nrow=8, ncol=8, byrow = TRUE)
mnist_digit   <- train_targets[230]
plot(as.raster(mnist_image/16))
print(mnist_digit)


# The digits dataset (test dataset)
test_set     <- read.csv("data/digits_testset.csv", header= FALSE)
test_images  <- test_set[1:64]
test_targets <- as.factor(test_set[[65]])

# Hyperparamaters of the model
gamma <- 0.01
cost  <- 1.0 

# Fit a Support Vector Classifier
model <- e1071::svm(x =     train_images,
                    y =     train_targets, 
                    gamma = gamma,
                    cost =  cost,
                    scale = FALSE)

# Predict the value of the digit on the test dataset
prediction <- predict(object =  model, 
                      newdata = test_images)

# Accuracy measure to evaluate the result
agreement <- table(prediction == test_targets)
accuracy  <- agreement[2]/(agreement[1] + agreement[2])
cat("Accuracy: ", accuracy, " with parameters C=", cost, " and G=", gamma, "\n")


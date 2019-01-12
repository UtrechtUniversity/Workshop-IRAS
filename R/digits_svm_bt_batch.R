# Recognize written digits with Support Vector Machines
#
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
#
# License:      BSD-3-Clause
#
library("tidyverse")
library("e1071")
library("batchtools")
library("parallel")

opt <- getopt::getopt(
  matrix(
    c('node',      'N', 1, "numeric"    # Max. number of nodes 
    ), 
    byrow=TRUE, ncol=4))

if (is.null(opt$node) )


# The digits dataset (train dataset)
train_set     <- read.csv("data/digits_trainset.csv", header= FALSE)
train_images  <- train_set[1:64]
train_targets <- as.factor(train_set[[65]])

# The digits dataset (test dataset)
test_set     <- read.csv("data/digits_testset.csv", header= FALSE)
test_images  <- test_set[1:64]
test_targets <- as.factor(test_set[[65]])


svm_wrapper <- function(cost, gamma) {
  # Fit a Support Vector Classifier
  model <- e1071::svm(x =     train_images,
                      y =     train_targets, 
                      gamma = gamma,
                      cost =  cost,
                      scale = FALSE)

  # Predict the value of the digit on the test dataset
  prediction <- predict(object =  model, 
                        newdata = test_images)
  
  
  # Calculate accuracy of this model
  agreement          <- table(prediction == test_targets)
  accuracy           <- agreement[2]/(agreement[1] + agreement[2])
  return(data_frame(cost = cost, gamma = gamma, accuracy = accuracy))
}


# hyperparameter: grid search
hyperparameters <- read.csv("./data/digits_svm_bt_parameters.csv")
hyperparameters <- hyperparameters %>% filter(node_id = node)


reg = makeRegistry(file.dir = NA, seed = 1)

reg$cluster.functions <- makeClusterFunctionsMulticore(ncpus = detectCores() - 1)
#reg$cluster.functions <- makeClusterFunctionsSocket(ncpus = detectCores() - 1)
#reg$cluster.functions <- makeClusterFunctionsInteractive()

batchMap(fun = svm_wrapper, args = hyperparameters)

res <- submitJobs()

waitForJobs()

trials <- batchtools::reduceResults(rbind, init = data_frame()) %>% arrange(desc(accuracy))
trials[1,]






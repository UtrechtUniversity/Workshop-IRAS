# Recognize written digits with Support Vector Machines
# Parallelisation with 'mclapply' from package 'parallel'
# Example of Parallel Programming (in R)
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
#
# License:      BSD-3-Clause
#
library("tidyverse")
library("e1071")
library("parallel")      # don't install because is part of 'base'

# The digits dataset (train dataset)
train_set     <- read.csv("data/digits_trainset.csv", header= FALSE)
train_images  <- train_set[1:64]
train_targets <- as.factor(train_set[[65]])

# The digits dataset (test dataset)
test_set     <- read.csv("data/digits_testset.csv", header= FALSE)
test_images  <- test_set[1:64]
test_targets <- as.factor(test_set[[65]])



svm_wrapper <- function(par_combi) {
  # Fit a Support Vector Classifier
  model <- e1071::svm(x =     train_images,
                      y =     train_targets, 
                      gamma = par_combi['gamma'],
                      cost =  par_combi['cost'],
                      scale = FALSE)

  # Predict the value of the digit on the test dataset
  prediction <- predict(object =  model, 
                        newdata = test_images)
  
  
  # Calculate accuracy of this model
  agreement          <- table(prediction == test_targets)
  accuracy           <- agreement[2]/(agreement[1] + agreement[2])
  return(accuracy = accuracy)
}


# hyperparameter: grid search
cost            <- c(2^-5, 2^-3, 2^-1, 2^0, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma           <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost = cost, gamma = gamma)

n_tasks <- nrow(hyperparameters)
hyper_list <- list()
for (i in 1:n_tasks) {
  hyper_list[[length(hyper_list) + 1]] <- c(cost = hyperparameters$cost[i],
                                           gamma = hyperparameters$gamma[i])
}
  
res <- mclapply(hyper_list, svm_wrapper, mc.cores = detectCores() - 1)

trials <- hyperparameters %>% mutate(accuracy = 0)
for (i in 1:n_tasks) {
  trials$accuracy[i] <- res[[i]]
}
trials <- trials %>% arrange(desc(accuracy))
write.csv(trials, "./output/digits_svm_mc.csv", row.names = FALSE)

# Recognize hand written digits with Support Vector Machines
# Parallelisation with 'mclapply' from package 'parallel'
# 'mcapply' is the multicore version of 'lapply'
# Example of Parallel Programming in R
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



# The training and testing of a model is wrapped in a function
# 
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

# 'mcapply' work on lists not on data tables (c.f. 'lapply')
#  Hence we construct a list of parameter combinations
#
hyper_list <- list()
for (c in cost) {
  for (g in gamma) {
    hyper_list[[length(hyper_list) + 1]] <- c(cost = c, gamma = g)
  }
}

# 'mcapply' works in the same way as 'lapply'. Only it doesn't run the tasks sequentially,
# but divides the tasks over the assigned cores (parameter 'mc.cores')
# 'detectCores' gives the number of cores on the node. We always reserve one core for
# system tasks. The 'result_list' is a list of the return values of the function 'svm_wrapper'
#
result_list <- mclapply(X = hyper_list, FUN = svm_wrapper, mc.cores = detectCores() - 1)

# Put the results back in the data table and write the table to a file
#
trials <- hyperparameters %>% mutate(accuracy = 0)
for (i in 1:nrow(trials)) {
  trials$accuracy[i] <- result_list[[i]]
}
trials <- trials %>% arrange(desc(accuracy))
write.csv(trials, "./output/digits_svm_mc.csv", row.names = FALSE)

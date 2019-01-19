# Recognize hand written digits with Support Vector Machines
# Parallelisation with 'parLapply' from package 'parallel'
# 'parLapply' as the name suggests is parallel version of 'lapply'
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

# 'parLapply' works on lists not on data tables.
#  Hence we construct a list of parameter combinations
#
hyper_list <- list()
for (c in cost) {
  for (g in gamma) {
    hyper_list[[length(hyper_list) + 1]] <- c(cost = c, gamma = g)
  }
}

# Define a cluster and assign a number of cores
#
cluster <- makeCluster(detectCores() - 1)

# Each core of the cluster gets its own copy of the global variables which are used 
# in the wrapper functions. The copies are real copies and will take up memory!
clusterExport(cl = cluster,
              varlist = c("train_images",
                          "train_targets",
                          "test_images",
                          "test_targets"))

# 'parApply' applies the wrapper function to each element of the list. Divides the tasks
# among the cores and returns a list of results
#
clock_start <- Sys.time()

result_list <- parLapply(cl =  cluster,
                         X =   hyper_list,
                         fun = svm_wrapper)

# stop the cluster and release the memory it occupies
#
stopCluster(cluster)

clock_end <- Sys.time()
duration  <- as.numeric(clock_end - clock_start)
print(duration)

# Put the results back in the data table and write the table to a file
#
trials <- hyperparameters %>% mutate(accuracy = 0)
for (i in 1:nrow(trials)) {
  trials$accuracy[i] <- result_list[[i]]
}
trials <- trials %>% arrange(desc(accuracy))
write.csv(trials, "./output/digits_svm_pl.csv", row.names = FALSE)

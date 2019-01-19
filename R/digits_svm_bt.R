# Recognize written digits with Support Vector Machines
# Parallel programming in R with the package batchtools
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License:      BSD-3-Clause
#
library("tidyverse")
library("e1071")
library("batchtools")
library("parallel")

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
cost            <- c(2^-5, 2^-3, 2^-1, 2^0, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma           <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost = cost, gamma = gamma)

   # For bookkeeping purposes a registry must be made. All the batchtool functions
   # will store their settings, parameters, and results in the registry 
   # 
registry        <- makeRegistry(file.dir = NA, seed = 1)
                
   # Multicore on Linux and macOS
   #
registry$cluster.functions <- makeClusterFunctionsMulticore(ncpus = detectCores() - 1)

   # Multicore on windows
   #
#registry$cluster.functions <- makeClusterFunctionsSocket(ncpus = detectCores() - 1)

   # Sequential on Linux, macOS and Windows
   #
#registry$cluster.functions <- makeClusterFunctionsInteractive()

  # 'batchMap' is like 'parLapply with 2 major differences:
  # 1. operates on rows of a table and not on elements of a list
  # 2. makes preparations for all the tasks, but don't executes them.
  #
  # The term 'map' comes from the MapReduce programming model. See
  # https://en.wikipedia.org/wiki/MapReduce
  #
batchtools::batchMap(fun =  svm_wrapper,
                     args = hyperparameters,
                     reg =  registry)

  # submitJobs submit the tasks to the machine and the machine decides when
  # in our case the tasks will run immediately, because we have the node already
  # at our disposal.
  # Unfortunately, batchtools uses the term 'job' where we are using 'task'
  #
clock_start <- Sys.time()
res <- batchtools::submitJobs(reg = registry)

  # Depending on the machine 'submitJobs' will not wait for the tasks
  # to end. To be sure we wait a while
  #
batchtools::waitForJobs(reg = registry)
clock_end <- Sys.time()
duration  <- as.numeric(clock_end - clock_start)
print(duration)
  # reduceResults combines (reduces) the results of the tasks
  # How to combine (reduce) is up to the user.
  # Here we choose to 'rbind' into one 'data_frame'
  #
trials <- batchtools::reduceResults(fun =  rbind,
                                    init = data_frame(),
                                    reg =  registry) 


trials <- trials %>% arrange(desc(accuracy))
write.csv(trials, "./output/digits_svm_bt.csv", row.names = FALSE)

  # clean up the registry
  #
batchtools::clearRegistry(reg = registry)





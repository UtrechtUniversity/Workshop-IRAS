# Recognize hand-written digits with Support Vector Machines
# Parallel programming in R with the package batchtools.
# Designed to work on one node of a cluster as part of a multthe i node grid search
# 
# Usage:
#   Rscript ./R/digits_svm_bt_node.R -N <integer>
#
# Arguments:
#   -N: node number in multi node grid search. Used to select the parameter settings for
#       chunk of tasks
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License:      BSD-3-Clause
#
library("tidyverse")
library("e1071")
library("batchtools")
library("parallel")

opt <- getopt::getopt(
  matrix(
    c('node', 'N', 1, "numeric"    # N is the node number assigned to this batch
    ), 
    byrow=TRUE, ncol=4))

if (is.null(opt$node) || (opt$node < 1)) {
  cat("Node number must be specified and larger than 0\n")
  q(status = 1)
}

node <- opt$node 

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

# the hyperparameters for this node

# Read all the parameter combinations
#
hyperparameters <- read.csv("./data/digits_svm_bt_parameters.csv")

# Select the combinations for this node
#
hyperparameters <- hyperparameters %>% filter(node_id == node) %>% select(cost, gamma)


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
res <- batchtools::submitJobs(reg = registry)

  # Depending on the machine 'submitJobs' will not wait for the tasks
  # to end. To be sure we wait a while
  #
batchtools::waitForJobs(reg = registry)

  # reduceResults combines (reduces) the results of the tasks
  # How to combine (reduce) is up to the user.
  # Here we choose to 'rbind' into one 'data_frame'
  #
trials <- batchtools::reduceResults(fun =  rbind,
                                    init = data_frame(),
                                    reg =  registry) 


trials <- trials %>% arrange(desc(accuracy))

  # write out the results of this node
  # appends the node number to the filename to distuingish from 
  # outputfiles of other nodes
  #
output_file <- sprintf("./output/digits_svm_bt_node_%d.csv", node)
write.csv(x = trials, file = output_file, row.names = FALSE)

  # clean up the registry
  #
batchtools::clearRegistry(reg = registry)




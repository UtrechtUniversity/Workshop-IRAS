# Recognize written digits with Support Vector Machines
#
# Arguments:
#     -C: Penalty (cost) parameter C of the error term.
#     -G: Kernel coefficient gamma
#     -T: number of the task within the grid search
#
# Authors:      Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# Dependencies: 
# License:      BSD-3-Clause
#

library("getopt")
library("e1071")
library("dplyr")
library("magrittr")

#parsing the arguments to Rscript after program file: Rscript --[options] digits_svm.R [arguments]
opt <- getopt::getopt(
  matrix(
    c('gamma', 'G', 1, "numeric",
      'cost',  'C', 1, "numeric",
      'task',  'T', 1, "numeric"
    ), 
    byrow=TRUE, ncol=4
  ))

# default values for options not specified
if (is.null(opt$gamma) ||
    is.null(opt$cost)  ||
    is.null(opt$task)) {quit(status = -1)}

gamma <- opt$gamma
cost  <- opt$cost
task  <- opt$task


trials <- expand.grid(cost = cost, gamma = gamma) %>% mutate(accuracy = 0, task = task)

# The digits dataset (train dataset)
train_set     <- read.csv("data/digits_trainset.csv", header= FALSE)
train_images  <- train_set[1:64]
train_targets <- as.factor(train_set[[65]])


# The digits dataset (test dataset)
test_set     <- read.csv("data/digits_testset.csv", header= FALSE)
test_images  <- test_set[1:64]
test_targets <- as.factor(test_set[[65]])

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
agreement           <- table(prediction == test_targets)
trials$accuracy[1]  <- agreement[2]/(agreement[1] + agreement[2])


# write trial to a CSV file in output directory
if (!dir.exists("output")) { dir.create("output") }
output_file <- file.path(
  "output", 
  sprintf("digits_svm_hpc_T_%d_C_%f_gamma_%f.txt", task, cost, gamma))
write.csv(trials, output_file, row.names= FALSE)

# end of program

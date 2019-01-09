# Recognize written digits with Support Vector Machines
# 
# Call:
#   Rscript ./R/digits_svm_hpc.R -C <value for 'cost'> -G <value for 'gamma'>
# 
# Arguments:
#     -C:     Penalty parameter C of the error term.
#     -G:     Kernel coefficient.
#
# Authors:    Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# Dependencies: 
# License:      BSD-3-Clause
#

library("getopt")
library("e1071")
library("raster")
library("tidyverse")

  # `getopt` parses the arguments given to an R script:
  # Rscript --[options] script.R [arguments]
  # Example: Rscript digits_svm_shell.R -C 0.5 -G 0.01
opt <- getopt::getopt(
  matrix(
    c('gamma', 'G', 1, "numeric",
      'cost', 'C', 1, "numeric"
    ), 
    byrow=TRUE, ncol=4))

# default values for options not specified
# depending on the situation at hand you could/should also check if given values are allowed

if (is.null(opt$gamma)) {opt$gamma = 2^-3}
if (is.null(opt$cost))  {opt$cost  = 2^-1}


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
                    gamma = opt$gamma,
                    cost =  opt$cost,
                    scale = FALSE)

# Predict the value of the digit on the test dataset
prediction <- predict(object =  model, 
                      newdata = test_images)

# Accuracy measure to evaluate the result
agreement  <- table(prediction == test_targets)
accuracy   <- agreement[2]/(agreement[1] + agreement[2])

# Store results in a data fame (tibble) and 
# write that data frame to an '.csv' file
trial      <- as_data_frame (
                x = list(cost =     opt$cost,
                         gamma =    opt$gamma,
                         accuracy = accuracy))

  # It's good practise to use the hyper paarmeter values in the name the outputfile and
  # store the outputfiles in a dedicated subfolder
  #
if (!dir.exists("output")) { dir.create("output") }
output_file <- file.path("./output", 
                          sprintf("digits_svm_C_%f_G_%f.csv",
                                   opt$cost,
                                   opt$gamma))

  # Write the result of this trial to the file with the parameter setting
  #
write.csv(trial, output_file, row.names= FALSE)

# end of program

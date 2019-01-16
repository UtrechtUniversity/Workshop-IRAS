library(tidyverse)

# make list of all the output files of each task
data_file_pattern <- sprintf("^digits_svm_bt.*\\.csv$")
data_files        <- list.files(path =       "output/",
                                pattern =     data_file_pattern,
                                full.names =  TRUE)
n_tasks <- length(data_files)
if (n_tasks == 0) {
  cat("No data files found!\n\n")
  q(save = "no", status = -1)
}

for (n in 1:n_tasks) {
  trial <- read.csv(data_files[n], header = TRUE)
  if (n == 1) {
    trials <- trial
  } else {
    trials <- rbind(trials, trial)
  }
}

trials <- trials %>% arrange(desc(accuracy)) %>% select(cost, gamma, accuracy)

best_model <- sprintf("Best performing model with accuracy %f with cost %f and gamma %f\n",
                       trials$accuracy[1],
                       trials$cost[1],
                       trials$gamma[1])
cat(best_model)
cat("You can find all the results in file digits_svm_bt.csv\n")
write.csv(trials, "digits_svm_bt.csv", row.names = FALSE)




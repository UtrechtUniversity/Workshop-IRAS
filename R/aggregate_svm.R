library(magrittr)
library(readr)

# make list of all the output files of each task
data_file_pattern <- sprintf("^digits_svm_hpc.*\\.txt$")
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

trials <- trials %>% arrange(desc(accuracy)) %>% select(task, cost, gamma, accuracy)
write.csv(trials, "digits_svm.out", row.names = FALSE)




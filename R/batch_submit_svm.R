# Generate Batch Script for Digits Recognition with SVM
# - Generates batch script for each node
# - generates submission script for all the jobs
# - does a grid search
#
# Command:
#     Rscript R/generate_batch_svm.R -N [positive integer]
#
# Arguments:
#     -N: Number of nodes to use; one batch file (job) for each node 
#
# Authors:
#     Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License:
#     BSD-3-Clause


#' Generic function to create batch files for HPC cluster.
#' 
#' @param arguments The hyperparameters
#' @param n_processes Number of processes/tasks per file/node
#' @param n_batch Number of the batch.
#'
make_bash_file <- function (parameters, n_processes = 15, n_batch = 1) {

  # recursive as long as number of rows greater than number of processes on one node
  if (nrow(parameters) > n_processes){
    make_bash_file(tail(parameters, nrow(parameters)-n_processes), 
                   n_processes = n_processes, 
                   n_batch =     n_batch + 1)
  }
  parameters <- head(parameters, n_processes)

  # write batch commands to file
  if (!dir.exists("batch")) dir.create("batch")
  batch_script <- file.path("batch",
                             sprintf("batch-%d.sh", n_batch))
  fbatch       <- file(batch_script, open = "w")
  
  writeLines("#!/bin/bash", fbatch)
  writeLines("#SBATCH -t 00:05:00", fbatch)
  writeLines("#SBATCH -N 1", fbatch)
  writeLines("cd $HOME/workshop", fbatch)
  writeLines("module load eb", fbatch)
  writeLines("module load R", fbatch)
  writeLines("date", fbatch)
  
  for (i in 1:nrow(parameters)){

    i_task = i + ((n_batch  - 1) * n_processes)
  
    command <- sprintf("Rscript --vanilla R/digits_svm_hpc.R -T %d -C %f -G %f &", 
                        i_task,
                        parameters[i, 'cost'],
                        parameters[i, 'gamma'])
    writeLines(command, fbatch)
  }

  writeLines("wait", fbatch)
  writeLines("date", fbatch)
  close(con= fbatch)
}


# hyperparameter: grid search
cost    <- c(2^-5, 2^-3, 2^-1, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma   <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost =  cost, 
                               gamma = gamma)


# parsing the arguments to Rscript after program file: Rscript --[options] progam.R [arguments]
opt <- getopt::getopt(
  matrix(
    c('nodes', 'N', 1, "numeric"), 
    byrow=TRUE, ncol=4)
)

# defaults for options not specified
if (is.null(opt$nodes)) { opt$nodes = 1 }

# using more nodes than tasks is a waste
if (opt$nodes > nrow(hyperparameters)) {opt$nodes <- nrow(hyperparameters)}

# the number of tasks or processes on one node (in one job)
n_processes <- ceiling(nrow(hyperparameters)/opt$nodes)

# make the batch files
make_bash_file(hyperparameters, n_processes = n_processes)

# write submit commands to file
if (!dir.exists("batch")) dir.create("batch")
submit_script <- file.path("batch", "submit_svm.sh")
fsubmit <- file(submit_script, open = "w")
writeLines("#!/bin/bash", fsubmit)
for ( n in 1:opt$nodes) {
  submit_cmd <- sprintf("sbatch batch/batch-%d.sh", n)
  writeLines(submit_cmd, fsubmit)
}
close(con = fsubmit)
Sys.chmod(paths = submit_script, mode = "0700")  #submit file must be an executable (bash)


# Generate SLURM submission and batch scripts for training SVM models for Digits Recognition
# Finds best performing model by doing a grid search with 2 hyperparamaters:
# 'cost' and 'gamma'.
# 
# Usage:
#   Rscript ./R/generate_batch1_svm.R [-N <integer> XOR -W <integer>] -T <integer>
#
# Arguments:
#   -N: number of batches (= number of nodes)
#   -W: (max) walltime each script may take in seconds
#   -T: time to completion of a task (training a model) in seconds
# 
# Details:
#
# Authors: Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License: BSD-3-Clause

library(getopt)
library(tidyverse)
library(parallel)
library(batchtools)

  # Parsing the arguments
opt <- getopt::getopt(
  matrix(
    c('nodes',      'N', 1, "numeric",    # Max. number of nodes 
      'walltime',   'W', 1, "numeric",    # Or max. walltime (sec) of each job
      'completion', 'T', 1, "numeric"     # Time (sec) to completion of one task
    ), 
    byrow=TRUE, ncol=4))

# default values for options not specified
# depending on the situation at hand you could/should also check if given values are allowed

if (( is.null(opt$nodes) && is.null(opt$walltime)) ||
    (!is.null(opt$nodes) && !is.null(opt$walltime))){
  print("Either nodes (-N) or walltime (-W) must be specified")
  quit(status = 1)
}

if (is.null(opt$completion) || (opt$completion < 1)) {
  print("Time to completion of task must be specified and >= 1")
  quit(status = 1)
}

if (!is.null(opt$nodes) && (opt$nodes < 1)) {
  print("Number of nodes must be greater then 0")
  quit(status = 1)
}

if (!is.null(opt$walltime) && (opt$walltime < 1)) {
  print("Walltime must be greater then 0")
  quit(status = 1)
}

nodes      <- opt$nodes
walltime   <- opt$walltime
completion <- opt$completion


# Function to a create batch file for SLURM scheduler.
#

make_batch_file <- function (parameters, node, walltime, n_cores) {

  # Write the batch commands to this file
  #
  if (!dir.exists("batch")) dir.create("batch")
  batch_script <- file.path("batch", sprintf("batch1-%d.sh", node))
  fbatch       <- file(batch_script, open = "w")
  
  # The instructions for the scheduler
  #
  writeLines("#!/bin/bash", fbatch)
  
    # Conversion of walltime to 'hh:mm:ss" format
    #
  hours    <- walltime %/% 3600
  walltime <- walltime %% 3600
  minutes  <- walltime %/% 60
  walltime <- walltime %% 60
  seconds  <- walltime
  walltime_directive <- sprintf("#SBATCH -t %02d:%02d:%02d", hours, minutes, seconds)
  writeLines(walltime_directive, fbatch)
  
  writeLines("#SBATCH -N 1", fbatch)
  writeLines("#SBATCH -n 16", fbatch)               # number of cores in a node
  writeLines("#SBATCH -J IRAS", fbatch)
  writeLines("#SBATCH --mail-type=BEGIN,END", fbatch)
  writeLines("#SBATCH --mail-user=k.vaneijden@uu.com", fbatch)
  
  # Instructions for file handling and loading R
  #
  writeLines("module load R", fbatch)
  writeLines("cd $SLURM_SUBMIT_DIR", fbatch)
  writeLines("cp -r $SLURM_SUBMIT_DIR/R \"$TMPDIR\"", fbatch)
  writeLines("cp -r $SLURM_SUBMIT_DIR/data \"$TMPDIR\"", fbatch)
  writeLines("cd \"$TMPDIR\"", fbatch)
  writeLines("mkdir ./output", fbatch)
  
    # Write out (at the most) n_tasks calls to Rscript to the batch file
    #

  # Construct the call to Rscript for this task
  command <- sprintf("Rscript ./R/digits_svm_bt_batch.R -N %d &", node)
  writeLines(command, fbatch)
  writeLines("wait", fbatch)
  writeLines("cp -r \"$TMPDIR\"/output $SLURM_SUBMIT_DIR", fbatch)
  close(con= fbatch)
}


  # hyperparameter value for the grid search
cost            <- c(2^-5, 2^-3, 2^-1, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma           <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost =  cost, gamma = gamma)

n_tasks         <- nrow(hyperparameters)
n_cores         <- parallel::detectCores() - 1                # number of (free) cores on node

if (!is.null(nodes)) {
  
  if (nodes > ceiling(n_tasks / n_cores)) { # user asks too many nodes 
    nodes   <- ceiling(n_tasks / n_cores)     
  }
      
  node_id  <- chunk(1:n_tasks, n.chunks = nodes)
  nodes    <- max(node_id)
  
  walltime <- ceiling(max(table(node_id)) / n_cores) * completion
} else {
  if (walltime < completion) {
    walltime <- completion
  }
  n_task_per_node <- ceiling(walltime/completion) * n_cores
  node_id         <- chunk(1:n_tasks, chunk.size = n_task_per_node)
  nodes           <- max(node_id)
}

hyperparameters   <- hyperparameters %>% mutate(node_id = node_id)
write.csv(hyperparameters, "./data/digits_svm_bt_parameters.csv", row.names = FALSE)
  
for (n in 1:nodes) {
  parameters <- hyperparameters %>% filter(node_id == n)
  make_batch_file(parameters = parameters,
                  node       = n,
                  walltime   = walltime,
                  n_cores    = n_cores)
}


  # create a submission script
  #
if (!dir.exists("batch")) dir.create("batch")
submit_script <- file.path("batch", "submit_bt_svm.sh")
fsubmit       <- file(submit_script, open = "w")

  # write sbatch command for each node / batch job

writeLines("#!/bin/bash", fsubmit)
for ( n in 1:nodes) {
  submit_cmd <- sprintf("sbatch ./batch/batch1-%d.sh", n)
  writeLines(submit_cmd, fsubmit)
}
close(con = fsubmit)
  
  # change file permissions so this file can be run from the c0mmand line
  #
Sys.chmod(paths = submit_script, mode = "0700")  #file must be an executable (bash)

# End of program
#


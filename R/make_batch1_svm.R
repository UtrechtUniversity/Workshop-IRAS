# Generate SLURM submission and batch scripts for training SVM models for Digits Recognition
# Finds best performing model by doing a grid search with 2 hyperparamaters:
# 'cost' and 'gamma'.
# 
# Usage:
#   Rscript ./R/make_batch1_svm.R [-N <integer> XOR -W <integer>] -T <integer>
#
# Examples:
#   Rscript ./R/make_batch1_svm.R -N 5 -T 20
#   Rscript ./R/make_batch1_svm.R -W 100 -T 20
#
# Arguments:
#   -N: number of batches (= number of nodes)
#   -W: max. walltime each job may take in seconds
#   -T: time to completion of one task (training a model) in seconds
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
      'walltime',   'W', 1, "numeric",    # Or max. walltime (in sec) of each job
      'completion', 'T', 1, "numeric"     # Time (in sec) to completion of one task
    ), 
    byrow=TRUE, ncol=4))

# 
# checking the argument values
#

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

N     <- opt$nodes
W     <- opt$walltime
T     <- opt$completion

# On Lisa all the nodes have 16 cores, but we reserve one core for the system
#
n <- 16 - 1

# hyperparameter values for the grid search
# the number of rows is the number of tasks
cost            <- c(2^-5, 2^-3, 2^-1, 2^0, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma           <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost =  cost, gamma = gamma)

t <- nrow(hyperparameters)            # number of tasks

# Calculate walltime (W) when number of nodes N is given
if (!is.null(N)) {
  if (N > ceiling(t / n)) {           # user asks too many nodes 
    N <- ceiling(t / n)     
  }
  W <- T * ceiling(t / (n * N))
# 
# Or number of nodes (N) when walltime (W) is given
} else {
  if (W < T) {                        # walltime is less than time of completion
    W <- T
  }
  N = ceiling((t * T) / (n * W))
}

# Node_id contains a mapping of tasks to nodes: task i has been assigned to node_id[i]
# The function `batchtools::chunk`` assigns the node numbers 1, ... N to the tasks.
# `chunk` tries to assign equal number of tasks to the nodes.
#
node_id           <- chunk(1:t, n.chunks = N)
hyperparameters   <- hyperparameters %>% mutate(node_id = node_id)

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
  writeLines("#SBATCH -J IRAS1", fbatch)
  writeLines("#SBATCH --mail-type=BEGIN,END", fbatch)
  writeLines("#SBATCH --mail-user=<your email address>", fbatch)
  
  # Instructions for file handling and loading R
  #
  writeLines("module load R", fbatch)
  writeLines("cd $SLURM_SUBMIT_DIR", fbatch)
  writeLines("cp -r $SLURM_SUBMIT_DIR/R \"$TMPDIR\"", fbatch)
  writeLines("cp -r $SLURM_SUBMIT_DIR/data \"$TMPDIR\"", fbatch)
  writeLines("cd \"$TMPDIR\"", fbatch)
  writeLines("mkdir ./output", fbatch)
  
    # Write out calls to Rscript <progam> to the batch file
    #
  for (task in 1:nrow(parameters)){
    # Construct the call to Rscript for this task
    command <- sprintf("Rscript ./R/digits_svm_hpc.R -C %f -G %f &", 
                        parameters[task, 'cost'],
                        parameters[task, 'gamma'])
    writeLines(command, fbatch)
      
      # At most 'n_cores' tasks can run in parallel. To avoid too many tasks
      # competing for the cores, wait untill all cores are free
      # Only works well when tasks don't differ to much in lead time
      #
    if ((task %% n_cores) == 0) {
      writeLines("wait", fbatch)
    }
  }
  # Write the instructions for file handling
  #
  writeLines("wait", fbatch)
  writeLines("cp -r \"$TMPDIR\"/output $SLURM_SUBMIT_DIR", fbatch)
  close(con= fbatch)
}


# Create a batch file for every node
  
for (node in 1:N) {
    #
    # select the tasks for node `node`
    #
  parameters <- hyperparameters %>% filter(node_id == node)
    #
    # make batch for node `node`
    #
  make_batch_file(parameters = parameters,
                  node       = node,
                  walltime   = W,
                  n_cores    = n)
}


  # create a submission script
  #
if (!dir.exists("batch")) dir.create("batch")
submit_script <- file.path("batch", "submit_svm1.sh")
fsubmit       <- file(submit_script, open = "w")

  # write sbatch command for each node / batch job

writeLines("#!/bin/bash", fsubmit)
for ( node in 1:N) {
  submit_cmd <- sprintf("sbatch --reservation=iraspd ./batch/batch1-%d.sh", node)
  writeLines(submit_cmd, fsubmit)
}
close(con = fsubmit)
  
  # change file permissions so this file can be run from the c0mmand line
  #
Sys.chmod(paths = submit_script, mode = "0700")  #file must be an executable (bash)

# End of program
#


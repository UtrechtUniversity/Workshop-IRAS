# Generate Batch Script for grid search Digits Recognition with SVM
#
# Usage:
#   Rscript ./R/generate_batch_svm.R
#
# Authors: Roel Brouwer, Kees van Eijden, Jonathan de Bruin
#
# License: BSD-3-Clause


# Generic function to create batch files for SLURM scheduler.
#

make_batch_file <- function (parameters, n_cores = 15) {

  # how big is the grid search?
  #
  n_tasks <- nrow(parameters)                    # number of tasks to perform
  n_nodes <- ceiling(n_tasks/n_cores)            # number of nodes needed
  
  for (node in 1:n_nodes) {
    
    # Create for every node a batch script
    # Write batch commands to this file
    #
    if (!dir.exists("batch")) dir.create("batch")
    batch_script <- file.path("batch", sprintf("batch-%d.sh", node))
    fbatch       <- file(batch_script, open = "w")
  
    # The instructions for the scheduler
    #
    writeLines("#!/bin/bash", fbatch)
    writeLines("#SBATCH -t 00:05:00", fbatch)
    writeLines("#SBATCH -N 1", fbatch)
    writeLines("#SBATCH -n 16", fbatch)               # number of cores in a node
    writeLines("#SBATCH -J IRAS", fbatch)
    writeLines("#SBATCH --mail-type=BEGIN,END", fbatch)
    writeLines("#SBATCH --mail-user=<email address>", fbatch)
  
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
    for (core in 1:n_cores){
      task    <- core + ((node - 1) * n_cores)       # the task at hand
      if (task > n_tasks) {break}                    # last task reached
        
        # Construct the call to Rscript for this task
      command <- sprintf("Rscript ./R/digits_svm_hpc.R -C %f -G %f &", 
                          parameters[task, 'cost'],
                          parameters[task, 'gamma'])
      writeLines(command, fbatch)
    }
    # Write the instructions for file handling
    #
    writeLines("wait", fbatch)
    writeLines("cp -r \"$TMPDIR\"/output $SLURM_SUBMIT_DIR", fbatch)
    close(con= fbatch)
  }
  return(n_nodes)
}


  # hyperparameter value for the grid search
cost            <- c(2^-5, 2^-3, 2^-1, 2^1, 2^3, 2^5, 2^7, 2^9, 2^11, 2^13, 2^15)
gamma           <- c(2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5, 2^-3, 2^-1, 2^1, 2^3 )
hyperparameters <- expand.grid(cost =  cost, gamma = gamma)

  # make the batch files
  # returns the number of batch scripts made
  #
n_batch = make_batch_file(hyperparameters)

  # create a submission script
  #
if (!dir.exists("batch")) dir.create("batch")
submit_script <- file.path("batch", "submit_svm.sh")
fsubmit       <- file(submit_script, open = "w")

  # write sbatch command for each node / batch job

writeLines("#!/bin/bash", fsubmit)
for ( n in 1:n_batch) {
  submit_cmd <- sprintf("sbatch batch/batch-%d.sh", n)
  writeLines(submit_cmd, fsubmit)
}
close(con = fsubmit)
  
  # change file permissions so this file can be run from the c0mmand line
  #
Sys.chmod(paths = submit_script, mode = "0700")  #file must be an executable (bash)

# End of program
#


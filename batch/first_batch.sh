#!/bin/bash           
                    
#SBATCH -N 1              # we want 1 node
#SBATCH --mem=32G         # with 32 GB memory
#SBATCH -t 00:05:00       # for 5 minutes
#SBATCH -J IRAS           # and use 'IRAS' as name of the job

    # When a node is available, the system logins at the node impersonating
    # the user who has submitted this batch script
    # The following commands will be executed on behalf of that user
module load R             # load the R modules

cd $SLURM_SUBMIT_DIR      # go to the directory from which the job was
                          # submitted
                          
                          # Run the R script in batch mode, meaning that this
                          # script will not wait for this program to end
Rscript ./R/digits_svm_IDE.R &

                          # Wait till all previous programs have ended
                          # Sounds weird, but will be explained when we run several 
                          # programs (tasks) in the same batch script
wait
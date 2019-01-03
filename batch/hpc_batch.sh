#!/bin/bash           
                    
#SBATCH -N 1              # we want 1 node
#SBATCH --mem=32G         # with 32 GB memory
#SBATCH -t 00:05:00       # for 5 minutes
#SBATCH -J IRAS           # and use 'IRAS' as name of the job
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=k.vaneijden@gmail.com

    # When a node is available, the system logins at the node impersonating
    # the user who has submitted this batch script
    # The following commands will be executed on behalf of that user
module load R             # load the R modules

cd $SLURM_SUBMIT_DIR      # go to the directory from which the job was
                          # submitted

cp -r $SLURM_SUBMIT_DIR/R "$TMPDIR"
cp -r $SLURM_SUBMIT_DIR/data "$TMPDIR"

cd "$TMPDIR"
mkdir ./output

            # The "&" at the end forces the R scripts to run in the background
            # Every script is started without waiting upon his predecessor.
            # If there are less tasks than cores in the node this will be fine.
            # Else the tasks (Rscripts) will compete with each other for the available cores
            # resulting in a longer lead time of the batch job

Rscript ./R/digits_svm_hpc.R -C 0.25 -G 0.0625 &
Rscript ./R/digits_svm_shell.R -C 0.125 -G 0.03125 &
Rscript ./R/digits_svm_shell.R -C 0.5 -G 0.125 &

            # Wait till all previous programs have ended, because we must copy all the
            # output files of the batch job back to the home space of the user
wait

cp -r "$TMPDIR"/output $SLURM_SUBMIT_DIR

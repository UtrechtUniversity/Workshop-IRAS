## Your first batch job on LISA

### From RStudio to Rscript

So many cores on one machine is a huge advantage, but a super computer has also disadvantages.
For instance you don't have a nice _interactive development environment (IDE)_ as RStudio on LISA. How then are you going to run your R jobs. The solution to this problem is to use `Rscript`.
This program can run from the command prompt and takes as argument a script written in R. Rscript will run that script like RStudio runs an script in its _source pane_.

If you have correctly installed the repo in the previous lesson, and if your working directory is `Workshop-IRAS` than you can try `Rscript` by typing the following lines at the prompt

```
module load R
Rscript ./R/digits_svm_IDE.R
```

The output to your screen should look like the output you have gotten before in the _console pane_ of RStudio. It took **Lisa** a little bit longer to train a model. Do you know why? And where has the picture of the digit gone?

**Warning!** You could have offended the rules of SURFsara. It's not allowed to run highly demanding computations on a login node. The login node may only be used for editing, copying or moving files and other linux commands. All heavy computations must be send to the batch schedulers which will transfer these jobs to compute nodes. But this was just a very little program, wasn't it?

So from now on, we are going to use the batch scheduler. 

### SLURM: the batch scheduler on LISA

With the `sbatch` command, you tell the scheduler to run a job some time in the near future on a batch node. To fullfill it's obligations the scheduler has to know a few things. First, what resources are needed and, second, which programs have to be executed. We specify those settings in a so called batch file. In the `batch` folder the batch file `first_batch.sh` contains the following lines

```
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
```

With the `sbatch` commmand this job can be submitted to the scheduler. Type the following line at the command prompt. Be sure that your working directory is `Workshop-IRAS`

```
sbatch ./batch/first_batch.sh
```

The schedulers acknowledges the submission by replying with the job number.
After submitting, you can inspect the status of your job in the queue with:

```
squeue -u <username>
```

If you don't see a queue with your program it may have already been ended, because this job is very small.

In the the directory `Workshop-IRAS` there is a file `slurm-<job number>.out`. If you open this file you see the already well known output of your R script. This file will contain all output (e.g. warnings and errors) of all the commands in the batch file.

#### Sending output of R script to a separate file

You can separate the console output of your R script from the other messages by sending (a.k.a. redirecting) the console output of Rscript to another file. In the file `first_batch.sh` alter the the line with Rscript command into:

```
Rscript ./R/digits_svm_IDE.R &> ./output/digits_svm_IDE.out &
```

The console output of R is now redirected to the file `digits_svm_IDE.out` in de subfolder `output`. It's quite common to store different types of files in separate subfolders (e.g. `R` scripts, `data` files, `batch` files, and `output` files).

Run the batch script and check the output files. Notice that the scheduler, by using the job number, takes care that its output file doesn't overwrite those of its predecessors. Something we have to keep in mind for the output of our R script. 

Where is the output file of Rscript? Is the contents of this file as you expected?. Why is the output file of the batch scheduler (slurm) empty?

From time to time delete the output files of `sbatch`

```
rm ./slurm*.out
```

And also in the `output` directory. How?


#### Notify user when job has started and ended

The jobs in this workshop are very small. The scheduler give priority to small jobs to make testing and debugging less time consuming.Therefore, the jobs we submit here will often run almost immediately. When you work with larger jobs with many resources, it can take hours or even days before a job starts/finishes. To be able to follow the progress of your job without login in to Lisa all the time, you can instruct the scheduler to send you an email when the job starts and ends.

Add to the batch file `first_batch.sh` the following 2 lines.

```
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=<your email address>
```

Run submit the batch job and check whether you have received the two email messages


#### Using **scratch** space

Every node of **Lisa** has, as almost every other computer cluster, its own disks attached. This file space (known as **scratch space**) is very fast compared to the disks where you have stored the files of this workshop.

The system administrators urge the users to use the scratch space for performance reasons. So before running the R script we will copy the input files to the scratch space and at the end we will copy the output back to our home space. To accomplish this add the necessary lines (below) to the file `first_batch.sh`

```
cd $SLURM_SUBMIT_DIR

  # Copy input tot scratch
  #
cp -r $SLURM_SUBMIT_DIR/R    "$TMPDIR"
cp -r $SLURM_SUBMIT_DIR/data "$TMPDIR"

  # Change working directory and make a subdirectory to store the output
cd "$TMPDIR"
mkdir ./output


Rscript ./R/digits_svm_IDE.R &> ./output/digits_svm.out &

wait

  # Copy output back to home
  # 
cp -r "$TMPDIR"/output $SLURM_SUBMIT_DIR
```

Submit the batch file and check if all went well.

#### Doing a grid search with LISA

In a previous lesson we did a grid search on our workstations. Now we have access to a supercomputer. Will the grid search run faster? Let's check by chanching the line with `Rscript` in the file `first_batch.sh` to contain the R script for the grid search.

```
Rscript ./R/digits_svm_IDE_gs.R &> ./output/svm_grid_search.out &
```

Submit the script `first_batch.sh` and inspect the output. Compare the results with the ones you obtained on your workstation. A slight disappointment, isn't it? My workstation was almost 30% faster. The reason is that **Lisa** still uses one core to solve your problem sequentially. The cores of **Lisa** are slower than the cores on your workstation if that is a recent model. We need to do things in parallel to speed things up and that is the topic of the next lesson

Go to [next lesson](./hpc_on_lisa.md) or to the [overview](./overview.md)















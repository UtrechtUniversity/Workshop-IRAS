## Your first batch job on LISA

### From RStudio to Rscript

So many cores on one machine is a huge advantage, but a super computer has also disadvantages.
For instance you don't have a nice _interactive development environment (IDE)_ as RStudio on LISA. How then are you going to run jobs. The solution to this problem is to use `Rscript`.
This program can run from the command prompt and takes as argument an script written in R. Rscript will run that script like RStudio runs an script in its _source pane_.

If you have correctly installed the repo in the previous lesson, and if your working directory is `Workshop-IRAS` than you can try `Rscript` by typing the following lines at the prompt

```
module load R
Rscript "./R/digits_svm_IDE.R"
```

The output to your screen should look like the output you have gotten before in the _console pane_ of RStudio.

A warning! You have offended the rules of SURFsara. It's not allowed to run computations on a login node. The login node may only be used for editing, copying or moving files and other linux commands. All computations must be send to the batch schedulers which will transfer these jobs to compute nodes.

So from now on, we are going to use the batch scheduler. 

### SLURM: the batch scheduler on LISA

With the `sbatch` command, you tell the scheduler to run a job some time in the near future. To fullfill it's obligations the scheduler has to know a few things. First, which programs have to be executed and, second, what resources are needed. We specify those settings in a so called batch file. In the `batch` folder the batch file `first_batch.sh` contains the following lines

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

The console output is now redirected to the file `digits_svm_IDE.out` in de subfolder `output`. It's quite common to store different types of files in separate subfolders (e.g. `R` scripts, `data` files, `batch` files, and `output` files).

Run the batch script and check the output files. Notice that the scheduler by using the job number takes care its output file doesn't overwrite its predecessor. Something we have to keep in mind for the output of our R script


#### Notify user when job has started and ended

The jobs in this workshop are very small and nearly all the time they will run almost immediately. But when the time your jobs remain in the queue and the lead times of the jobs will take hours or days, you can't repeatedly running `squeue` at the terminal. It would be nice if the scheduler would send you a mail when the job has started and has ended.

Add to the batch file `first_batch.sh` the following 2 lines.

```
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=<your email address>
```

Run submit the batch job and check wether you are receiving the two mail messages


#### Using **scratch** space

Every node of LISA has, as almost every other computer cluster, its own disks attached. This file space (a.k.a. as scratch space) is very fast compared to the disks (a.k.a. home space) where you have stored the files of this workshop.

The system administrators urge us users to use the scratch space for performance reasons. So before running the R script we will copy the input files to the scratch space and at the end we will copy the output back to our home space. Add the necessary lines to the file `first_batch.sh`

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

Submit the script `first_batch.sh` and inspect the output. Compare the results with the ones you obtained on your workstation. A not so slight disappointment, isn't it. My workstation was almost 30% faster. The reason is that LISA still uses one core to solve your problem sequentially. And in my case the cores of LISA are slower than the cores on my workstation (a remarkably fast Mac Book). We need to do things in parallel and thats the topic of the next lesson















## High Performance Computing on LISA

At the end of the lesson you have learned how to run many similar tasks in parallel. 


The problem at hand is the training of dozens of the same svm models with different (hyper-) parameter settings. This is an example of pleasingly parallel computations. The tasks are completely independent from each other. We don't have to take care of synchronisations or communications between the various tasks.

The general workflow is:

1. Make a list of all the combinations of parameter values (a.k.a. _search grid_).

2. For every combination start a task without waiting for the previous task to end.

3. When all the tasks have finished, collect the results and do some summarizing or post-processing if necessary (in our case looking for the parameter settings which lead to the best model accuracy).


### Adjusting the R script
First we have to adjust the R script to make it possible to provide the script with input parameters (a.k.a. arguments) upon calling the script. In this way we can start each task with it's own combination of parameter values. The call to Rscript will look like:

```
Rscript ./R/digits_svm_hpc.R -C 0.5 -G 0.01
```

We have changed the name of the script to emphasize that we don't run the R script in the source pane of RStudio anymore, but with Rscript on an computer cluster.

Secondly, we need to store the results of a task in such a format that it can be easily read by another program (e.g. R script) that collects (summarizes) the task results. This can for example be done by storing values in a `.csv` file (**comma separated values**).. We also want to store the values in a human readable format in case of errors. Furthermore, we have to prevent the individual tasks to overwrite each others results. We accomplish this by writing out the results of a task to files with unique file names (e.g. containing the parameter values as follows: `digits_svm_C_0.5_G_0.01). 

Open the file `./R/digits_svm_hpc.R` in your editor and inspect the code and comments. Don't make any changes.

In the `batch` directory there is a file named `hpc_batch.sh`. Open the file and read the code and comments. You will see that it instructs the batch scheduler to run the new R script not once but three times with different parameter combinations. And also the redirection of the standard output is gone. Why? And is that wise?

Submit the batch script and wait for the output file. Before starting the batch script, maybe you should remove the `.out` files in the main directory and in the `output` subdirectory.

```
sbatch --reservation=iraspd ./batch/hpc_batch.sh
sbatch ./batch/hpc_batch.sh
squeue -u <your username>
```

Check if the results are stored in the `output` directory. Look also in the slurm output file  in the main directory. Do you notice anything different? Why has that happened?

Also check the wall time and CPU efficiency with

```
seff <job number>
```

Feel free to run the batch script again with more tasks by adding more Rscript lines with other parameter settings. Could you run dozens, hundreds or even thousands of tasks that way? 
Supposedly not. And how to solve this, is the topic of the next paragraph.

### Using more than one node

If we want to run more than 15 tasks (trials) in parallel on **Lisa**, we need more than one node. **Lisa** has 16 cores per node, but we always reserve one for system programs to run. For every node we need a separate batch script. Creating these batch scripts by hand is not doable in practise. Therefore, we create an R script which generates those batch scripts. Remember how we, in a previous lesson, did a grid search in RStudio:

1. We constructed a table with all the parameter combinations

2. Sequentially, from the first to the last, we trained the svm model with the parameter combination at hand.

3. We selected the parameter combination with the best accuracy.

We will copy this approach. But after constructing the table, we take the first 15 combinations and write out 15 calls to `Rscript ./R/digits_svm_hpc.R <parameter values>` to a file. We surround the 15 calls to `Rscript ....` with the necessary SBATCH commands and commands for copying files there and back. We repeat this proces for the next 15 tasks and so on till there are no more task left.

Open the file `make_batch_svm.R` in the `R` subdirectory. Read the code and comments. Take your time.

>In line 38, fill in your own email address.

Tip: you can run the script `make_batch_svm.R` in RStudio step-by-step to see what it does. 

The batch files are made by the function `make_batch_file`. At the end there is a little extra code  to make your life more convenient. It makes a submission script, so you don't have to type all the `sbatch` commands at the command line.

If you are ready run the following command on **Lisa**.

```
Rscript ./R/make_batch_svm.R
```

Look in the subdirectory `batch`. How many batch files there are present? You should also see the submission script. Run this script after removing `.out` and `.csv` files from the main directory and its subdirectory `output`.

```
./batch/submit_svm.sh
squeue -u <your username>
```

Check whether all the 110 `.csv` files are present in the `output` directory.

```
ls ./output/*.csv | wc      # 'wc' counts lines, words and characters of the input
```

Check for a few jobs the walltimes and cpu efficiciencies.

### Collecting and processing the results

After all the tasks have produced their results, it's time to collect them in one file. The R script `collect_svm.R` reads all the results and stores them in one table. This table will be written to the final output file `digits_svm.csv` in the working directory. The script does a little bit of summarizing by printing the parameters of the best performing model to the console. Read the R script and then run it at the command line.

```
Rscript ./R/collect_svm.R
```

Every job sends an email to notify you when the job has ended. In this email also the actual run time (a.k.a. walltime) is mentioned (e.g. Run time 00:00:16). You can also check with `seff <job id>`. The run time of a job is pretty much the same as the run time of a single task. Because you have used 110 different processors for this job it is possible that you have your results much quicker than when you would have run them sequentially (which would take 6-10 minutes). This depends largely on how much time the job was in the queue. For such a short task you can imagine that the time in the queue is a very important determinant of the total lead time.  However, if the run time of one task increases this difference will play a lesser role in determining the total lead time of the whole computation, and you can reduce the computation time e.g. by a factor of 10 - 100.

The same considerations apply when comparing with the run time on your workstation. But even if it is not possible to parallelize a job or the run time on **Lisa** is not significantly less, it can be still beneficial to run jobs on a cluster as your workstation remains available for other tasks (e.g. writing an article or project proposal). This phenomenom is called **offloading**

Now you should be able to run a pleasingly parallel computation on **Lisa**. Return to the [overview](./overview.md) page to see what the next topics of this workshop are.

## High Performance Computing on LISA

At the end of the lesson you have learned how to run many similar tasks in parallel. 


The problem at hand is the training of dozens of the same svm models with different (hyper-) parameter settings. This is an example of pleasingly parallel computations. The tasks are completely independent from each other. We don't have to take care of synchronisations or communications between the various tasks.

The general workflow is:

1. Make a list of all the combinations of parameter values (a.k.a. _search grid_).

2. For every combination start a task without waiting for the previous task to end.

3. When all the tasks are ended, collect the results and do some summarizing if necessary. In our case looking for the parameter settings which lead to the best accuracy.


### Adjusting the R script
First we have to adjust the R script to have input parameters (a.k.a. arguments). In this way we can start each task with it's own combination of parameter values. The call to Rscript will look like:

```
Rscript ./R/digits_svm_hpc.R -C 0.5 -G 0.01
```

We have changed the name of the script to emphasize that we don't run the R script in the source pane of RStudio anymore, but with Rscript on an computer cluster.

Secondly, we need to store the result of a task in such a format that a program that collects (summarizes) the task results can find them at the end. But also in a human readable format in case of errors. And we must prevent the individual tasks to overwrite each others results. We accomplish this by writing out the result of a task to a file which name contains the parameter values (e.g. `digits_svm_C_0.5_G_0.01). The file format will be `.csv` (**comma separated values**).

Open the file `./R/digits_svm_hpc.R` in your editor and inspect the code and comments. Don't make any changes.

In the `batch` directory there is a file named `hpc_batch.sh`. Open the file and read the code and comments. You will see that it instructs the batch scheduler to run the new R script not once but three times with different parameter combinations. And also the redirection of the standard output is gone. Why? And is that wise?

Submit the batch script and wait for the output file. Before starting the batch script, maybe you should remove the `.out` files in the main directory and in the `output` subdirectory.

```
sbatch ./batch/hpc_batch.sh 
squeue -u <your username>
```

Check if the results are stored in the `output` directory. Look also in the slurm output file  in the main directory. Do you notice anything different? Why has that happened?

Feel free to run the batch script again with more tasks by adding more Rscript lines with other parameter settings. Could you run dozens, hundreds or even thousands of tasks that way? 
Supposedly not. And how to solve this, is the topic of the next paragraph.

### Using more than one node

If we want to run more than 15 tasks (trials) in parallel on **Lisa**, we need more than one node. **Lisa** has 16 cores per node, but we always reserve one for system programs to run. For every node we need a separate batch script. Creating this batch scripts by hand is not doable in practise. We must make an R script which generates those batch scripts. Remember how we, in a previous lesson, did a grid search in RStudio:

1. We constructed a table with all the parameter combinations

2. Sequentially, from the first to the last, we trained the svm model with the parameter combination at hand.

3. We selected the parameter combination with the best accuracy.

We will copy this approach. But after constructing the table, we take the first 15 combinations and write out 15 calls to `Rscript ./R/digits_svm_hpc.R <parameter values>` to a file. We surround the 15 calls to `Rscript ....` with the necessary SBATCH commands and commands for copying files there and back. We repeat this proces for the next 15 tasks and so on till there are no more task left.

Open the file `make_batch_svm.R` in the `R` subdirectory. Read the code and comments. Take your time. Tip: you can run the script `make_batch_svm.R` in RStudio step-by-step to see what it does. 

The batch files are made by the function `make_batch_file`. At the hand there is a little extra to make your life more convenient. It makes a submission script, so you don't have to type all the `sbatch` commands at the command line.

If you are ready run the following command on **Lisa**.

```
Rscript ./R/make_batch_svm.R
```

Look in the subdirectory `batch` how many batch files there are present. You should also see the submission script. Run this script after removing `.out` and `.csv` files from the main directory and its subdirectory `output`.

```
./batch/submit_svm.sh
squeue -u <your username>
```

Check after a coffee or tea break whether all 110 the `.csv` files are present in the `output` directory.

```
ls ./output/*.csv | wc      # 'wc' counts lines, words and characters of the input
```

### Collecting and processing the results

After all the tasks have produced their results, it's time to collect them in one file. The R script `collect_svm.R` reads all the results and stores them in one table. This table will be written to the final output file `digits_svm.csv` in the working directory. The script does a little bit of summarizing by printing the parameters of the best performing model to the console. Read the R script and then run it at the commanline.

```
Rscript ./R/collect_svm.R
```

Now you should be able to run a pleasingly parallel computation on **Lisa**. Return to the overview page to see what the next topics of this workshop are.

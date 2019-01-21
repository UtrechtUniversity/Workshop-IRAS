## Running many small tasks revisited

In this lesson we are going to play around with the number of nodes and the walltime.
Previously, we used the R script `make_batch_svm.R` to make the submission script and the batch scripts. The script calculates the number of nodes that are needed, but for the walltime it uses a fixed period of time (5 minutes). That was long enough.

But now we want to have more control over these resource parameters. Let's do a little bit of arithmetic. 

Neglecting overhead (the time it takes to divide tasks among processors and collecting the results from all processors), the total walltime of a job (W) can be estimated by dividing the total computation time (TC) by the number of processors (P):
```
W = TC / P
```
The number of processors is simply the number of nodes (N) times the number of cores per node (n) and the total computation time is the time needed to perform 1 task (T) times the total number of tasks (t) (valid when the task have a similar size).

When the following assumptions are met we can estimate the total walltime:

1. The time needed for completion of a task (T) does not differ (too) much between the different parallel tasks.
2. We know the value of T or we can make an educated guess
2. The number of cores (n) in a node (N) is known
3. The number of tasks (t) to run is known 

If the user specifies the number of nodes (N), then the walltime (W) of a node is given by the formula:

```
W = (t * T) / (n * N)     # walltime W is the total needed core time (t*T) 
                          # divided by total number of available cores (n*N)
```

On the other hand, if W is specified, we can calculate the number of nodes (N) with:

```
N = (t * T) / (n * W)     # number of nodes N is total needed core time (t*T)
                          # divided the available core time on one node (n*W)
```
Using these equations we can determine the preferred values of N or W.


There is a new R script `make_batch1_svm.R`. Open that script in your editor; edit the email address and browse the code.

The script has 3 arguments (-N, -W, -T). The user has to specify -T (time of completion of one task) AND either -N (number of nodes) or -W (walltime). 

If we know the number of nodes we must assign equal chunks of tasks to each node. The function `batchtools::chunk` takes care of that.

The function `make_batch_file` (lines 103-162) has been altered considerably compared to script we used in the previous workshop. This time it only makes one batch file for each `node`. Furthermore, it fills in the walltime, which is also an argument to the function. 

And last but not least, it divides the calls to Rscript in series with a length equal to the number of available cores. After every subseries there is a `wait` command. Why?

The `wait` limits the maximum number of concurrent task to the number of available cores. Every task gets its own core. If there are more tasks than cores, the cores will be switching between tasks to give the tasks a fair share of the available cores (a.k.a. time sharing). But the swapping takes time!

We must warn you that parellizing in this way doesn't work as well if completion times of the task differ substantially. Then it could be possible that cores are waiting idle while one core is still busy working on a long task, reducing the speed up. When initializing the parameters of the make_batch_svm script, the time of completion T must always be the time of the "slowest" task, otherwise the task may not finish before the requested walltime has finished (a job kills automatically when the requested walltime has finished).

At the end of the script there is a for loop that calls the function `make_batch_file` with the right argument values.

Fill in your argument -N in the code below and run the commands to run the R script and to submit the jobs.

```
Rscript ./R/make_batch1_svm.R -N <integer> -T 20
./batch/submit_svm1.sh
```

When the jobs have ended, check the walltime of the jobs with:

```
seff <job number>
```
It should be less than the requested walltime.

Collect the output with

```
Rscript ./R/collect_svm.R
```

Experiment with different values of N or W.

We have come to the end of this lesson. In the next lesson you will learn how to run parts of a program in parallel. [Go back to the overview](./overview.md) or go [to the next lesson](./Parallel_programming_R.md).












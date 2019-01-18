## Running many small tasks revisited

In this lesson we are going to play around with the number of nodes and the walltime.
Previously, we used the R script `make_batch_svm.R` to make the submission script and the batch scripts. The script calculates the number of nodes that are needed, but for the walltime it uses a fixed period of time(5 minutes). That was long enough.

But now we want to have more control over these resource parameters. Let's  do  little bit of arithmetic. Our assumptions are:

1. The times of completions (T) of all the tasks don't differ (too) much.
2. We know the value of T or we can make an educated guess
2. The number of cores (n) in a node node is known
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

There is a new R script `make_batch1_svm.R`. Open that script in your editor; edit the email address and browse the code.

The script has 3 arguments (-N, -W, -T) of which the user must specify -T (time of completion of one task) and -N (number of nodes) or -W (walltime). And "or" means "exclusive or".

If we know the number of nodes we must assign equal chunks of tasks to each node. The function `batchtools::chunk` takes care of that.

The function `make_batch_file` has been altered considerably. It only makes one batch file for the argument `node`. Secondly, it fills in the walltime, which is also an argument. 

And last but not least, it divides the the calls to Rscript in series with a length equal to the number of available cores. After every subseries there is a `wait` command. Why?

The `wait` limits the maximum number of concurent task to the number of available cores. Every task gets its own core. If there are more tasks than cores, the system will be swapping between the task to give the tasks a fair share (a.k.a. time sharing). But the swapping takes time!

We must warn you that it doesn't work well if completion times of the task differ substantially. Then it could be possible that cores are waiting idle while one core is still busy working on a long task. The time of completion T must always be the time of the "slowest" task.

At the end of the script there is a for loop that calls the function `make_batch_file` with the right argument values.

Run the script and submit the run.

```
Rscript ./R/make_batch1_svm.R -N <integer> -T 20
./batch/submit_svm1.sh
```

When the jobs have ended, check from some jobs the walltime with:

```
seff <job number>
```

Collect the output with

```
Rscript ./R/collect_svm.R
```

Experiment with different values of N or W.

We have come to the end of this lesson. In the next lesson you will learn how to run parts of a program in parallel. [Go back to the overview](./overview.md) or go [to the next lesson](./Parallel_programming_R.md).












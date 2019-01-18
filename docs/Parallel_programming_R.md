## Parallel Programming in R

An R program often contains one for-loops. If each iteration is indepedent of its successors, those iterations could be performed in parallel. Depending on the lead time of the for-loop, you can decide to do so. The same considerations apply for the famous `apply` functions over lists and vectors (e.g. `lapply`). In the R eco-system there are numerous packages which implements parallel functions. See [this link](https://cran.r-project.org/web/views/HighPerformanceComputing.html) for an overview. We will show examples from two packages `parallel` and `batchtools`.

These functions work also on your workstation or notebook. These days workstations and laptops have several cores and "why not" make use of them. But beware that there are differences between Windows and macOS/Linux.

### Package `parallel`: the function 'parLapply`

The package `parallel` contains functions which implement the parallel versions of apply family: `lapply`, `sapply`, etc. This package is a `base` package, hence you don't have to install it. You only have to load it with `library(parallel)`.

In file `./R/digits_svm_pl.R` we have a rewritten version of our example program for recognizing hand-written digits. Open the file in a editor and browse the code. You can also run the code in RStudio on your laptop or workstation!

There are several points we want to focus your attention to:

1. 'parLapply', like `lapply`, needs a function to apply on the elements of the list. So, we need to wrap the code for learning and testing in a function.

2. `parLapply`, also like `lapply`, works on elements of a list (or vector). We have converted the table with parameter combinations to a list.

3. With `makeCluster` you create a `cluster` object. You assign a number of cores to a cluster. The function `detectCores` returns the number of cores on your node or your computer.

4. The function that you are going to apply, uses global variables. With `clusterExport` you must export these variables to all the cores in the cluster.

5. The parallel equivalent of `lapply` is `parLapply`. It takes a list (or vector) `X` and a function `fun`. Then it applies `fun` on every element of `X`. It creates chunks of tasks and submits them to the available cores in the cluster `cl`. The number of `chunks` is by default equal to the number of cores. This works fine if the times of completion of the tasks differ only slightly. The result of `parLapply` is a list of the return values from the wrapper function. This list is in the same order as the input list!

6. `stopCluster` releases the claimed resources for other uses inside the same R program.

7. The list with the results must be converted to a column in the original table.

There is a submission script `./batch/pl_batch.sh`. Edit the email address in this batch script. Submit this script to the scheduler:

```
sbatch --reservation=iraspd ./batch/pl_batch.sh
squeue -u <your login name> 
```

When the run has ended, check the output in `./output/digits_svm_pl.csv`. Also check the walltime:

```
seff <job id>
```
Two final remarks about `parLapply`:

1. The functions in the package `parallel` only work inside one node. The degree of parallelisation is thereby limited to the number of cores inside the node.

2. Often you can transform a for-loop in a form suited for `parLapply`. Put the iteration or index values in a vector (X) and wrap the body of the for-loop in a function (fun).

### Package `batchtools`

Our second package is `batchtools`. This package has been designed to move your  parallel computations seamlessly from the laptop/workstation to remote computers or computer clusters. `batchtools` also implements a workflow for **experiment design**. See for more information [this link](https://cran.r-project.org/web/packages/batchtools/vignettes/batchtools.pdf).

A nice feature of `batchtools` is the fact that it works with data tables instead of lists. __Lists Are So 20th Century!__

In the file `./R/digits_svm_bt.R` we have rewritten our example to work with `batchtools`. Open this script in an editor and browse the code. You also can, step-by-step, run this script in RStudio on your laptop provided that you have `installed.packages('batchtools')`.

There are several points we want to focus your attention to:

1. The R code that does the trainin and testing is wrapped in a function. The return value is a table (data frame) with one row.

2. With `makeRegistry` you create a `registry` object. This object contains all the information which is needed to execute the tasks.

3. `batchtools` has several `clusterFunctions` which specifies how the tasks are run. `Multicore` and `Socket` run the tasks in parallel. The former on macOS and Linux and the latter on Windows. With `ncpus` you specify how many cores may be used. The function `Interactive` runs on Windows, macOS and Linux, but sequentially on one core. If `multicore` and `socket` are run on a wrong system the functions defaults to `Interactive`.

4. `batchMap` tells the registry which function to apply on which table. It sets up the registry to do accounting for all the tasks.

5. `submitJobs` runs all the tasks. The tasks store their results in the registry `reg`.

5. `reduceResults` reduces the results in the registry by iterating the function `fun` over the list of results. If `n` is the number of tasks, and `r` is the vector with all the tasks results, then the reduced result `red_r` is computed as follows:

```
red_r[0] = init                       # last value                        
red_r[i] = fun(r[i], red_r[i-1])      # reduced result after i-th iteration
red_r = red_r[n]                      # reduced result of computation is the 
                                      # reduced result after n-th iteration
```

There is a batch script `./batch/bt_batch.sh` that runs the `./R/digits_svm_bt.R` script on a node. Edit the email address in the batch script and submits it.

```
sbatch --reservation=iraspd ./batch/batch_bt.sh
squeue -u <your login name>
```

When the job has ended inspect the output in `./output/digits_svm_bt.csv`. Also check the walltime with:

```
seff <job number>
```

### Epilogue

This is the end of our lesson on **Parallel Programming in R**. As we have mentioned in the first paragraph, there are many more packages to explore. We must admit that the given examples were rather simple. In a real parallel universe you can encounter problems which requires you to delve deep in the documentation. E.g. if you have tasks that differ substantially in computing time.

One of the nice things, however, is that `parallel` and `batchtools` also run on your workstation. And workstations, today, have often 6 or more cores. And if you need more and/or remote computing power, your program can easily be migrated to a node on a cluster.









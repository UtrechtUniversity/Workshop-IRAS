## Combining parallel batch scripts with parallel R scripts

In this lesson we combine both types of parallelism. Why should we do so?

* Parallel programming in R allows for a lot of flexibility and efficient use of cores on a single node. E.g. you can write progams that have more than one parallel part. Or you can write parallel code inside parallel code.

* If we expect more work than a single node can handle in a given time frame, you have to divide the work over multiple nodes. As we have seen in the previous lesson it is possible to divide work over multiple cores using R functions. However, dividing work over multiple nodes is not straightforward. It requires advanced techniques which are out of scope of this workshop.

We continue using our example program for recognizing hand-written digits. We have made a new script `make_batch2_svm.R` which is a modified version of the make script from lesson 8. Open this file in your editor and browse the code.

The code is altered on a few places:

1. After the program has determined how to spread the tasks over the nodes, the table with parameter settings and node assignments are written out to a file `./data/digits_svm_bt_parameters.csv`. The R program that will run on the nodes will read this table and uses its node number to select the parameter combinations it has to explore. 

2. `parameters` aren't an argument of the function `make_batch_file` anymore. The function only writes one call to R script: `Rscript ./R/digits_svm_bt_node.R -N <node number>  &`. The R script `./R/digits_svm_bt_node.R` is a modified version of the R script `./R/digits_svm_bt.R` which we used in lesson 9. We will see thes modification in a short while.

Edit the file to contain your email adress. Run the make script (on Lisa) with arguments:

```
Rscript ./R/make_batch2_svm.R -N 4 -T 20
```

The results are five new files in the `./batch` directory. Four batch files: `batch2-1.sh`, .. etc. And one submission script: `./batch/submission_svm2.sh`. Open one of the batch script and browse the contents. There is now only one call to an Rscript in each batch job script that will run on a single node.

Before we can submit the batch scripts, we have to discuss the modifications in the R script that runs on the node. Open `./R/digits_svm_bt_node.R` in your editor and browse the code.

1. There is now only one argument (-N <integer>) as input parameter. This parameter is the node number which identifies the specific node (or batch) in the pool of (4) nodes that are assigned to this run.

2. It reads the file `./data/digits_svm_bt_parameters.csv` and filters the parameter combinations which are assigned to this specific node. The program now knows which tasks to perform.

3. At the end the scripts write the results to a file `./output/digits_svm_bt_node_<node_number>.csv`. To prevent the program to overwrite output from its "siblings", it uses the node number in the name of the output file.

Now submit the batches with the submission script

``
./batch/submit_svm2.sh
squeue -u <your login name>
``

When the jobs are done, chech if the output files are present in the `./output` directory.
You can check the effiency of a single job with:

```
seff <job number>
```

The final step is collecting the results of the jobs in one file. At the command prompt of Lisa type:

```
Rscript ./R/collect_svm_bt.R
```

In your working directory there should be a file `digits_svm_bt.csv`. Open the file to see if all the accuracies of the 120 parameter combinations are present.


Return to the [overview](./overview.md)




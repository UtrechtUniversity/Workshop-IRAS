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

The output to your screen should look like the output you will have gotten in the _console pane_ of RStudio before.

A warning! You have been offending the rules of SURFsara. It's not allowed to run computations on a login node. The login node may only be used for editting, copying or moving files and other linux commands. All computations must be send to the batch schedulers which will transfer these jobs to compute nodes.

From now on, we are going to use the batch scheduler. 








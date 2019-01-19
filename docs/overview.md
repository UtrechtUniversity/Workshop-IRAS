---
output:
  html_document: default
  pdf_document: default
---
## Objectives of the workshop HPC

This is an entry level workshop, aimed at reserachers with considerable programming experience in R, but no significant knowledge of high performance computers or computer clusters.

You will learn how to run your programs in parallel on a computer cluster. A computer cluster is a system with a lot of memory and a lot of processors which you share with hundreds of other users. A scheduler keeps track of the resources available and decides when to run your programs. You will learn how to write scripts telling the scheduler which programs to run, which resources are needed and for how long.

The operating system of a computer cluster will nearly always be Linux. The basic Linux concepts and commands will be introduced. But before you can learn Linux, you have to make a connection to the cluster. We will tell you how to login from your desk- or laptop (which will be referred to as _your local workstation_) onto a cluster with a terminal application. In this workshop we will also go into editing files and transferring files between your local workstation and the remote cluster.

The programming examples are in R. So, general understanding of R and RStudio is required. Some experience with text editing (E.g. Notepad, Xcode or RStudio's Source Pane) and command line interfaces (a.k.a. terminal) is a plus.

## Content of the workshop HPC

We have planned 2 sessions of 4 hours each. 

It is a very hands-on workshop, except for the first and sixth lesson. All other lessons will start with a brief introduction by one of the teachers followed by hands-on exercises on your local workstation and on the computer cluster **Lisa** of SURFsara. In the next paragraphs you will find instructions. Two or three teachers will be present at the workshopfor advice. 

### Lesson 1: Brief Introduction into High Performance Computing

Without delving to deep in the theory of HPC the most important concepts and characteristics of cluster computers and computing are explained. This lesson we will end  with a discussion of what types of computing jobs are suited to run on HPC.

_<[course material](./intro_hpc.md)>_

### Lesson 2: Example program in R: Recognizing Hand-written Digits with Machine Learning

Throughout the workshop we will use a small Machine Learning (ML) program (a.k.a. model) which can be trained to recognize digitized handwritten digits. This is a rather famous example in Machine Learning. A ML model usually has some parameters. The problem is to find the parameter combination which lead to the best performing model. We will run an R script on your local computer and by doing so we will notice "why & when" we are in need of an HPC.

_<[course material](./intro_svm.md)>_

### Lesson 3: Necessary preparations for using **Lisa**

Before you can start working on **Lisa**, you have to register your account and install some software packages on your computer. This software is necessary to login on **Lisa** and to transfer files between your workstation and Lisa. There are differnt software tools for Mac users and for Window users. On **Lisa** all of you will work with the same operating system: **Linux**. Most Linux systems don't support a graphical user interface (GUI). You will learn how to run programs and to manipulate files on a window-less system.

_<[course material](./preparations.md)>_

### Lesson 4: Running your first program on **Lisa**

In this lesson you will run your first job on the computer cluster. Step by step you learn how to write batch scripts to instruct the job scheduler what to do. Although you haven't run programs in parallel at yet the end of this lesson, you will know the basics of handling computer clusters.

_<[course material](./first_job_on_lisa.md)>_

### Lesson 5: High Performance Computing: running dozens of programs in parallel

This is the moment you have been waiting for. In this lesson you are going to run a few dozen programs in parallel. You will train several machine learning models in parallel and, afterwards, pick the best performing one. This is the same as the grid search as you did on your local workstation, but now in **parallel** instead of **sequentially**.

In the previous chapter job submission scripts (or batch scripts) were introduced. You have made them with a text editor. You can imagine that it is unpractical if you would have to make hunderds or thousands of different job submission scripts. You will learn how to make an R script to generate those scripts.

_<[course material for this lesson](./hpc_on_lisa.md)>_

### Lesson 6: Wrap up and preview of 2nd session

We close the first session with a plenary discussion of what you have learned sofar. 

We would also like to give you a preview of the second session

### Lesson 7: Start of second sessions.

If you have any questions regarding the contents of the first session, now is the time to ask.

When the questions are answered, we start the second session with (re-)installing the documents and scripts on Lisa from the repository.

Login on Lisa and type the following commands:

```
rm -r Workshop-IRAS       # removes the folder Workshop-IRAS and
                          # everything in it
                          
ls                        # Workshop-IRAS should not be in the list

git clone https://github.com/UtrechtUniversity/Workshop-IRAS.git

ls                        # Workshop-RAS should be listed again
```


### Lesson 8: Running many small tasks revisited

In lesson 5 you learned how to run dozens of small tasks in parallel. We asked the scheduler for 6 nodes of 15 cores each. Each task had it's own dedicated core. Lisa has ~420 nodes / ~7.000 cores, hence to give you 6 nodes (= 120 cores) wasn't a problem. But what to do when you are working on a smaller cluster and you have far more tasks to run? Then you probably can't give each task it's own core. Another problem arises, when a system would charge you a start up fee per node besides charging for walltime. Then it could be wiser to use a node longer than the ~20 seconds as we did. In this lesson we show you how to control the number of nodes or the walltime of a job.

_<[course material](./nodes_vs_walltime.md)>_

### Lesson 9: Parallel Programming in R

Untill now we have been dealing with **pleasingly parallel** jobs. We have one program that we have run many times with different parameter settings. The R program itself is strictly sequential and, therfore, uses one core. But often you can also parallelize parts of your programs too. E.g. when you use `for-loops` or when you apply functions over a list (e.g. the famous `lapply` function). These program parts are also candidates for parallelisation. In this lesson we teach you how!

_<[course material](./Parallel_programming_R.md)>_

### Lesson 10: Combining parallel batch scripts with parallel R scripts

Finally, we combine both types of parallelism. First we divide the work in chunks (or batches) over nodes, as we did with `make_batch_svm[1].R` and second, on each node an R scripts picks up the its chunk and processes it on the available cores. 

_<[course material](./chunks.md)>_

### Lesson 11 Working on your own parallel scripts (batch and/or R)

When there is time left, you can start working on a parallel program of your own. We will be there to help you to help you get started. Your login will be available for another 2 weeks. If you want a prolongation of your account, send us an email at <info.rdm@uu.nl>.

##  Epilogue

This is the end of our workshop. Although it may have been difficult subject matter for you, we hope you have enjoyed working with a computer cluster. The contents of this workshop is just an introduction to get you started. When you are going to program a computer cluster yourself, you will undoubtedly run into problems, errors etc. On the internet there are many fora, blogs, vignettes, repos, etc. dedicated to R and HPC to help you.

Some nice sources of information are:

1. [SURFsara Lisa user info](https://userinfo.surfsara.nl/systems/lisa)

2. [Packages for High-Performance and Parallel Computing with R](https://cran.r-project.org/web/views/HighPerformanceComputing.html)

3. [Introduction package batchtools](https://cran.r-project.org/web/packages/batchtools/vignettes/batchtools.pdf)

4. [Introduction package parallel](https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf)












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

### Lesson 7: Start of second sessions: recap of lessons I to V

### Lesson 8: Running many small tasks

### Lesson 9: Parallel Programming in R

### Lesson 10: Combining parallel batch scripts with parallel R scripts

### Lesson 11 Working on your own parallel scripts (batch and/or R)

### Lesson 12 Wrap up & Discussion










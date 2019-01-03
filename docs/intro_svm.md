---
output:
  html_document: default
  pdf_document: default
---
## Introduction Machine Learning

Machine learning algorithms build a mathematical model of sample data, known as "training data", in order to make predictions or decisions on new data without being explicitly programmed to perform the task.

Lineair regression is an simple form of machine learning. Although probably, you have used `lm` for hypothesis testing. But if you have established the `intercept a` and the `slope b`, you have a model to predict a new dependent variable `y'` when you fill in a new independent variable `x'` in the formula `y' = a + b*x'`

![_Lineair Regression_](./pictures/lineair_regression.png)

Another type of machine learning are Neural Networks which, at the moment, are very appealing to scientists in all kinds of disciplines. But we are going to use another very powerfull Machine Learning algorithme: **Support Vector Machiness (SVM)**

The idea behind SVM is to represent the observations or samples as points in a p-dimensional space and, then, to find the p-1 dimensional plane which creates the greatest separation between the points according to some classification. See picture below for a 2-dim case. 

![SVM](./pictures/svm1.png)

Non lineair classificaion can be achieved with a kernel trick. See picture below. A function ø (a.k.a. kernel) maps the points in such a way that they are lineairly separable. This will often lead to points in a higher dimensional space.

![Non-lineair SVM with _kernel_](./pictures/svm.png)

## Training a Support Vector Machine in RStudio on your local computer

We are going to train a SVM model written in R on your local computer. In the proces of training the model with a lot of different parameter settings, we will see why we eventually need to migrate to a computer cluster. But first we have to download the scripts and data.

### Download course material from GitHub

All the documents and scripts belonging to this workshop are stored in a GitHub repo [Workshop-IRAS](https://github.com/UtrechtUniversity/Workshop-IRAS).

This repo is public and you can download the repository in a `.zip` file on your desktop. Sometimes your local computer will unzip the file immediately. If you are familiar with GitHub, you can also fork/clone the repo, but for this workshop it is not necessary to have these sources in a local git repo.

Install (download/unzip or clone) the content of this repo in a folder on your local workstation where you keep all the sources of your R projects. Later on in the workshop you will learn how to copy these file to your account on LISA.


### Prepare R and RStudio

We assume you have installed R and RStudio on your local workstation. Install the following packages.

```
install.packages('tidyverse')  # functions for data cleaning
install.packages('e1071')      # functions for modeling/training with SVM
install.packages('raster')     # raster data structure 
```
Choose as working directory the folder Workshop-IRAS in which the contents of the repo is copied.

```
setwd("<path to folder>/Workshop-IRAS/")
```

### Train one SVM model on the famous MNIST dataset

Open the file ./R/digits_svm_IDE.R) in the _source panel_ of RStudio. Go step by step (ctrl-R) through the code and see what happens. Read the comments in the code.

### Apply a grid search to get a model with a better accuracy

In the previous exercise we had a model with an accuray of ~85%. If a mail sorting process of a postal service would have such an accuracy, that company should close its doors. To find a better accuracy, we are going to do a grid search. Several combinations of hyperparameter settings are tried and then we can select the parameter setting with the best accuracy. 

Load the file ./R/digits_svm_IDE_gs.R in the _source pane_ of RStudio. Run the programm step by step (Ctrl-R)

We have found a better model with accuray of ~97%. Which in fact is probably still pretty worse if you are running a postal service.

We have tried 12 hyperparameter settings, but what if we have to try thousands or tenthousands of different settings. It would take hours or days on a local computer. The nice thing about this kind of ML programs is that every model setting can be tried independently. And that opens a way to reduce the lead time if we can run lots of models in parallel.

If we want to do a grid search with n parameter settings and we have to run the models sequentially, the lead time will be `n * D` where D (duration) is the time needed for training one model. But if we have N machines (cores), we can set up N streams in parallel and the lead time will be reduced with a factor `n/N`.

And that are we going to explore on LISA. A super computer with ~7500 cores, alltough we aren't going to use them all.

So many cores on one machine is a huge advantage, but a super computer has also disadvantages.
For instance you don't have a nice _interactive development environment (IDE)_ as RStudio on Lisa. How then are you going to run jobs. 

[Go back to the overview](./overview.md) or go [to the next lesson](./preparations.md).




















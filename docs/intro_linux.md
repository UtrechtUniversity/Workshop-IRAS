## Introduction to Linux

Most information on this page is composed from introduction manuals at the websites of [Surfsara](https://userinfo.surfsara.nl/systems/lisa/getting-started) and [University of Surrey](http://www.ee.surrey.ac.uk/Teaching/Unix/). Check these websites for more elaborate information.

---------------------------

### Command line interface

Your workstation has a graphical user interface: you interact with your computer by clicking on files, applications, etc. Most HPC systems are using Unix/Linux, where you communicate through a command line interface. 


In a command line session, for everything you want to do you have to use commands: to navigate between folders, to make or remove folders, to search for information or to start a program. 

You are going to learn the most useful commands. Some of these commands can be pretty destructive (e.g. deleting files). To avoid corrupting the workshop files and folders, we make a copy of these files first:

```
cd ~                             # go to login directory (a.k.a. home directory)
cp -r Workshop-IRAS/ playground  # copy directory all contents of directory to a new directory
cd playground                    # change current directory to 'playground'
ls                               # show content of current directory
```


### Navigating between directories

For navigation you basically need three commands: `cd`, `ls` and `pwd`. The first two you have already met.

```
pwd                # print name of directory you are curently in (a.k.a working directory)
cd docs            # change working directory to 'docs'
pwd                # print name of working directory
ls -l              # make a list in long format of files and directories in current directory
```

Let's look at some useful options of `cd`.

```
cd ..              # go to parent directory
pwd                # working directory should be 'playground'
cd docs/pictures   # take two steps with one instruction
cd ../../R         # take two steps back and one forward
pwd                # check if your working directory is 'R'
```

All the `cd` commands sofar are relative to the working directory (except `cd ~`). Some Linux systems requires you to specify the working directory explicitely with a '.'.

```
cd ~/playground    # go to directory 'playground' where ever you currently are
pwd
cd ./batch         # go from the working directory to its subdirectory 'batch'
pwd
```


### Creating, moving and removing files and directories
 
Now your are going to manipulate files and directories. Some will be destructive, but if you remain in the `playground` that should not matter.

```
cd ~/playground                 # go to your 'playground'
cd ./batch                      # go to the subdirectory 'batch'
cp hpc_batch.sh hpc_batch2.sh   # make a copy of the file hpc_batch.sh
mkdir batch2                    # make a new subdirectory 'batch2'
ls                              # check the results of previous actions
mv hpc_batch2.sh batch2         # move the new file to the new directory
ls                              # the list should not contain file 'hpc_batch2.sh' 
cd ./batch2                     # go to 'batch2'
ls                              # now 'hpc_batch2.sh' will show up
mv hpc_batch2.sh batch_hpc.sh   # rename the file into 'batch_hpc.sh'
ls                              #
```

To delete files and directories:

```
pwd                              # you should be in the 'batch2' directory
rm batch_hpc.sh                  # remove file batch_hpc.sh
ls                               # check if file has gone
cd ..                            # go to parent directory
rmdir batch2                     # remove the directory 'batch2'
ls                               # check if directory has gone
```

Caution: deleting files and directories can not be undone!


### Commands with parameters (flags)

Many commands have a number of different options that can be activated with a `-` followed by a letter. E.g. `ls -l`. To see which options exist for a command you can open the manual:

```
man ls             # all the information is there, but often it's better to google the command
```

### Wild cards

You can use __wild cards__ in to match one or more file names. The most important one is `*` which matches any string. Maybe that sounds weird, but see how useful it is:

```
cd ~/playground              # go to 'playground'
cp ./batch/* .               # copy all files in subdirectory batch to working directory
cp ./R/* .                   # copy all files in subdirectory R to working directory
ls -l                        # list all the files
ls -l *.sh                   # show only the files with extension '.sh'
mkdir ./wildcard             # 
cp *.R ./wildcard            # copy all the .R files to subdirectory 'wildcard'
cd ./wildcard
ls -l                        # list all the files in 'wildcard'
ls -l *batch*                # show only the files with string 'batch' in their names
rm *                         # remove all the files
cd ..                        # 
rmdir wildcard               # 'wildcard' must be empty, else 'rmdir' doesn't work
rm *.sh                      # remove files with extension '.sh'
ls                           # files with '.R' are still there
rm *                         # remove all files; subdirectories are not affected
ls                           # directory only contains subdirectories
cd ..                        # go to playground
```


### Repeat commands and Command completion

You can recycle commands that you have typed earlier, which saves a lot of time.  
After you have typed in a few commands, use the arrow-up and arrow-down keys to see previous commands. Execute a previous command by pressing Enter. You can also edit previous commands if you need to run a command which is only slightly different.

If you type enough characters of a command or a filename to help the system identify what you mean, you can press tab to let the system finish the command or filename or foldername. This will also save you a lot of time. 

### Naming files

In naming files, characters with special meanings such as `/ * & %` , should be avoided. Also, avoid using spaces within names. The safest way to name a file is to use only letters and numbers, together with _ (underscore) and . (dot). It is also good practise to give a file an extension indicating contents of the file. Only use capitals at the beginning or after an underscore. This file naming convention is known as *snake_case*. 

**Good filenames**        
project.txt        # file contains text      
Test_1.R           # file contains R code        
Bert_Ernie.csv     # file contains comma separated values

**Bad filenames**
project
Test 1.m 
Bert & Ernie.txt
BertErnie.R


### Epilogue

This was a short introduction to Linux to help you on to start working with **Lisa**. When you become a real HPC aficionado, you will have to learn more Linux commands. On the Internet there is an abundance of introductions, courses and e-books.

For now go back to the [Preparations](./preparations.md)




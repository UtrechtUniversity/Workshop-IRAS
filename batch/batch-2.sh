#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load eb
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 20 -C 2048.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 21 -C 8192.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 22 -C 32768.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 23 -C 0.031250 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 24 -C 0.125000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 25 -C 0.500000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 26 -C 2.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 27 -C 8.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 28 -C 32.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 29 -C 128.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 30 -C 512.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 31 -C 2048.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 32 -C 8192.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 33 -C 32768.000000 -G 0.000488 &
Rscript --vanilla R/digits_svm_hpc.R -T 34 -C 0.031250 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 35 -C 0.125000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 36 -C 0.500000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 37 -C 2.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 38 -C 8.000000 -G 0.001953 &
wait
date

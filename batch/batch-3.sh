#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load eb
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 39 -C 32.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 40 -C 128.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 41 -C 512.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 42 -C 2048.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 43 -C 8192.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 44 -C 32768.000000 -G 0.001953 &
Rscript --vanilla R/digits_svm_hpc.R -T 45 -C 0.031250 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 46 -C 0.125000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 47 -C 0.500000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 48 -C 2.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 49 -C 8.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 50 -C 32.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 51 -C 128.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 52 -C 512.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 53 -C 2048.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 54 -C 8192.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 55 -C 32768.000000 -G 0.007812 &
Rscript --vanilla R/digits_svm_hpc.R -T 56 -C 0.031250 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 57 -C 0.125000 -G 0.031250 &
wait
date

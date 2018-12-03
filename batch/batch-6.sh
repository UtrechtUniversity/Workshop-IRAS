#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load eb
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 96 -C 512.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 97 -C 2048.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 98 -C 8192.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 99 -C 32768.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 100 -C 0.031250 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 101 -C 0.125000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 102 -C 0.500000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 103 -C 2.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 104 -C 8.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 105 -C 32.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 106 -C 128.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 107 -C 512.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 108 -C 2048.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 109 -C 8192.000000 -G 8.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 110 -C 32768.000000 -G 8.000000 &
wait
date

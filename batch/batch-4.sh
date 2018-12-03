#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load eb
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 58 -C 0.500000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 59 -C 2.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 60 -C 8.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 61 -C 32.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 62 -C 128.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 63 -C 512.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 64 -C 2048.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 65 -C 8192.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 66 -C 32768.000000 -G 0.031250 &
Rscript --vanilla R/digits_svm_hpc.R -T 67 -C 0.031250 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 68 -C 0.125000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 69 -C 0.500000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 70 -C 2.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 71 -C 8.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 72 -C 32.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 73 -C 128.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 74 -C 512.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 75 -C 2048.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 76 -C 8192.000000 -G 0.125000 &
wait
date

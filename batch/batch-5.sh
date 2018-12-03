#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load eb
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 77 -C 32768.000000 -G 0.125000 &
Rscript --vanilla R/digits_svm_hpc.R -T 78 -C 0.031250 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 79 -C 0.125000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 80 -C 0.500000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 81 -C 2.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 82 -C 8.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 83 -C 32.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 84 -C 128.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 85 -C 512.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 86 -C 2048.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 87 -C 8192.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 88 -C 32768.000000 -G 0.500000 &
Rscript --vanilla R/digits_svm_hpc.R -T 89 -C 0.031250 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 90 -C 0.125000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 91 -C 0.500000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 92 -C 2.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 93 -C 8.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 94 -C 32.000000 -G 2.000000 &
Rscript --vanilla R/digits_svm_hpc.R -T 95 -C 128.000000 -G 2.000000 &
wait
date

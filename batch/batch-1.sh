#!/bin/bash
#SBATCH -t 00:05:00
#SBATCH -N 1
cd $HOME/workshop
module load R
date
Rscript --vanilla R/digits_svm_hpc.R -T 1 -C 0.031250 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 2 -C 0.125000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 3 -C 0.500000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 4 -C 2.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 5 -C 8.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 6 -C 32.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 7 -C 128.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 8 -C 512.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 9 -C 2048.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 10 -C 8192.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 11 -C 32768.000000 -G 0.000031 &
Rscript --vanilla R/digits_svm_hpc.R -T 12 -C 0.031250 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 13 -C 0.125000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 14 -C 0.500000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 15 -C 2.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 16 -C 8.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 17 -C 32.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 18 -C 128.000000 -G 0.000122 &
Rscript --vanilla R/digits_svm_hpc.R -T 19 -C 512.000000 -G 0.000122 &
wait
date

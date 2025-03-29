#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH --error=task2.err --output=task2.out
#SBATCH --cpus-per-task=8
#SBATCH -n 1
#SBATCH --gpus-per-task=1

module load nvidia/cuda/11.8.0

nvcc task2.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

./task2


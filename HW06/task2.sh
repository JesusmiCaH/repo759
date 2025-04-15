#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH --error=task2.err --output=task2.out
#SBATCH --cpus-per-task=8
#SBATCH -n 1
#SBATCH --gpus-per-task=1

module load nvidia/cuda/11.8.0

nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o task2

for((i=9; i<30; i++))
do
	echo "n:2^$i"
	./task2 $((2**i)) 128 16
	echo ""
done

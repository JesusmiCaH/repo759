#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH --error=task3.err --output=task3.out
#SBATCH --cpus-per-task=8
#SBATCH -n 1
#SBATCH --gpus-per-task=1

module load nvidia/cuda/11.8.0

nvcc task3.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3

for((i=10; i<30; i++))
do
	echo "n:2^$i"
	./task3 $((2**i))
	echo ""
done


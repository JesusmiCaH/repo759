#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=Q2.err --output=Q2.out
#SBATCH --cpus-per-task=20

g++ task2.cpp convolution.cpp -Wall -O3 -std=c++17 -o task2 -fopenmp


for ((i=1; i<=20; i++))
do
    echo "T: $i"
    ./task2 1024 $i
    echo ""
done

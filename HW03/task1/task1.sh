#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=Q1.err --output=Q1.out
#SBATCH --cpus-per-task=20

g++ task1.cpp matmul.cpp -Wall -O3 -std=c++17 -o task1 -fopenmp

for ((i=1; i<=20; i++))
do
    echo "T: $i"
    ./task1 1024 $i
    echo ""
done

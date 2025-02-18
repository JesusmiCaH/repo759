#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=Q1.err --output=Q1.out

g++ scan.cpp task1.cpp -Wall -O3 -std=c++17 -o task1

for ((i=0; i<=30; i++))
do
    echo "2^$i: "
    ./task1 $((2**i))
    echo ""
done
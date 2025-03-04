#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=Q3.err --output=Q3.out
#SBATCH --cpus-per-task=20

g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

echo "C1----"
for ((i=1; i<=10; i++))
do
    echo "T: $i"
    ./task3 $((10**6)) 8  $((2**i))
    echo ""
done

echo "C2----"
for ((i=1; i<=20; i++))
do
    echo "T: $i"
    ./task3 $((10**6)) $i $((2**10))
    echo ""
done

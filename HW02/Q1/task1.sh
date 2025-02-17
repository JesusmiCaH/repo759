#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=SecondSlurt.err --output=SecondSlurt.out

g++ scan.cpp task1.cpp -Wall -O3 -std=c++17 -o task1

./task1 4096
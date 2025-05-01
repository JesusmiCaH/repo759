#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=task3.err --output=task3.out

g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3
./task3

#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=SecondSlurt.err --output=SecondSlurt.out

./task3
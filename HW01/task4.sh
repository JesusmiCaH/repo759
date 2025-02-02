#!/usr/bin/bash

#SBATCH --job-name=FirstSlurm
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=FirstSlurm.err --output=FirstSlurm.out

for i in {1..5}
do
    echo "Compute $i * $i = $(($i * $i))"
    sleep 1
done

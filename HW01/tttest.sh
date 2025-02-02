#!/bin/bash
#SBATCH --job-name=array_example
#SBATCH -p instruction
#SBATCH --output=job_output_%A_%a.out
#SBATCH --array=0-9

echo "Running job $SLURM_ARRAY_TASK_ID on host $(hostname)"

#!/usr/bin/bash

#SBATCH -J SecondSlurt
#SBATCH -p instruction
#SBATCH -c 2
#SBATCH --error=task4.err --output=task4.out
#SBATCH --cpus-per-task=8

num_p=100
end_time=100
g++ task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

echo "static"
export OMP_SCHEDULE="static,32"
for ((i=1; i<=8; i++))
do
    echo "Thread_num: $i"
    ./task3 $num_p $end_time $i
    echo ""
done

echo "dynamic"
export OMP_SCHEDULE="dynamic,16"
for ((i=1; i<=8; i++))
do
    echo "Thread_num: $i"
    ./task3 $num_p $end_time $i
    echo ""
done

echo "guided"
export OMP_SCHEDULE="guided,4"
for ((i=1; i<=8; i++))
do
    echo "Thread_num: $i"
    ./task3 $num_p $end_time $i
    echo ""
done


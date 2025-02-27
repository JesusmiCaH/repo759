cd task1
g++ task1.cpp matmul.cpp -Wall -O3 -std=c++17 -o task1 -fopenmp

cd ../task2
g++ task2.cpp convolution.cpp -Wall -O3 -std=c++17 -o task2 -fopenmp

cd ../task3
g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

cd ..

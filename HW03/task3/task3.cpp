#include <iostream>
#include <chrono>
#include <omp.h>
#include "msort.h"

using namespace std;
using std::chrono::duration;


template <typename T>
void compute_n_timer(T Arr, void (*sort)(T, size_t, size_t), size_t n, size_t threshold);

int main(int argc, char* argv[]){
    int n = std::stoi(argv[1]);
    int t = std::stoi(argv[2]);
    int ts = std::stoi(argv[3]);

    omp_set_num_threads(t);

    int* arr = (int*)malloc(n*sizeof(int));
    int r_max = 1000, r_min = -1000;
    //initialize
    #pragma omp parallel for
    for(int i = 0; i<n; i++){
        arr[i] = (int) ((float)rand() / RAND_MAX * (r_max - r_min) + r_min);
    }

    compute_n_timer(arr, msort, n, ts);
}

template <typename T>
void compute_n_timer(T Arr, void (*sort)(T, size_t, size_t), size_t n, size_t threshold){
    auto start_time = std::chrono::steady_clock::now();
    #pragma omp parallel
    {
	#pragma omp single
	{
	     sort(Arr, n, threshold);
	}
    }

    auto end_time = std::chrono::steady_clock::now();

    auto duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);

    cout << Arr[0] << endl;
    cout << Arr[n-1] << endl;
    cout << "Time: " << duration_sec.count() << endl;
    }

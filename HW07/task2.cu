#include <iostream>
#include <cuda.h>
#include "matmul.cuh"
#include <chrono>
#include <random>

using std::chrono::duration;
using namespace std;

template <typename T>
void randomize(T* A, int n, T min, T max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    using DistType = std::conditional_t<
        std::is_integral<T>::value,
        std::uniform_int_distribution<T>,
        std::uniform_real_distribution<T>
        >;
    DistType dist(min, max);
    for (int i = 0; i < n; i++) {
        A[i] = dist(gen);
    }
}

int main(int argc, char* argv[]){
    uint N = std::stoi(argv[1]);
    uint block_dim = std::stoi(argv[2]);

    float * arr = new float[N];
    randomize(arr, N, -1.0f, 1.0f);

    float * d_arr;
    cudaMalloc((void**)&d_arr, N * sizeof(float));
    cudaMemcpy(d_arr, arr, N * sizeof(float), cudaMemcpyHostToDevice);
    float * d_out;
    cudaMalloc((void**)&d_out, (N+block_dim-1)/block_dim * sizeof(float));

    auto start_time = std::chrono::steady_clock::now();
    reduce(&d_arr, &d_out, N, block_dim);
    auto end_time = std::chrono::steady_clock::now();
    auto duration_sec = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);

    cudaMemcpy(arr, d_arr, sizeof(float), cudaMemcpyDeviceToHost);
    cout << arr[0] << endl;
    cout << duration_sec.count() << endl;
    cout << "------------------------" << endl;

    return 0;
}

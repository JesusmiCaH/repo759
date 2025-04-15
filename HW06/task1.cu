#include <iostream>
#include <cuda.h>
#include "matmul.cuh"
#include <chrono>
#include <random>

using namespace std;
using std::chrono::duration;

int main(int argc, char* argv[]){
    int n = std::stoi(argv[1]);
    unsigned int threads_per_block = std::stoi(argv[2]);

    float *h_A = new float[n * n];
    float *h_B = new float[n * n];
    float *h_C = new float[n * n];

    unsigned int seed = 759;
    std::mt19937 generator(seed);
    std::uniform_real_distribution<float> dist(-1.0, 1.0);
    
    // Initialize
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            h_A[i * n + j] = dist(generator);
            h_B[i * n + j] = dist(generator);
        }
    }

    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, n * n * sizeof(float));
    cudaMalloc(&d_B, n * n * sizeof(float));
    cudaMalloc(&d_C, n * n * sizeof(float));

    cudaMemcpy(d_A, h_A, n * n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, n * n * sizeof(float), cudaMemcpyHostToDevice);
    auto start_time = std::chrono::steady_clock::now();
    matmul(d_A, d_B, d_C, n, threads_per_block);
    auto end_time = std::chrono::steady_clock::now();
    cudaMemcpy(h_C, d_C, n * n * sizeof(float), cudaMemcpyDeviceToHost);

    auto duration_sec = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);	
    
    cout << h_C[n*n-1] << endl;
    cout << duration_sec.count() << endl;

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    delete[] h_A;
    delete[] h_B;
    delete[] h_C;

    return 0;
}

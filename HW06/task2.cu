#include <iostream>
#include <cuda.h>
#include "stencil.cuh"
#include <chrono>

int main(int argc, char* argv[]){
    int n = std::stoi(argv[1]);
    int R = std::stoi(argv[2]);
    unsigned int threads_per_block = 256;

    float* image = new float[n];
    float* mask = new float[2 * R + 1];
    float* output = new float[n];
    unsigned int seed = 759;
    std::mt19937 generator(seed);
    std::uniform_real_distribution<float> dist(-1.0, 1.0);
    for (int i = 0; i < n; i++) {
        image[i] = dist(generator);
    }
    for (int i = 0; i < 2 * R + 1; i++) {
        mask[i] = dist(generator);
    }

    float* d_image, *d_mask, *d_output;
    cudaMalloc(&d_image, n * sizeof(float));
    cudaMalloc(&d_mask, (2 * R + 1) * sizeof(float));
    cudaMalloc(&d_output, n * sizeof(float));
    cudaMemcpy(d_image, image, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, (2 * R + 1) * sizeof(float), cudaMemcpyHostToDevice);

    auto start_time = std::chrono::steady_clock::now();
    stencil(d_image, d_mask, d_output, n, R, threads_per_block);
    auto end_time = std::chrono::steady_clock::now();
    cudaMemcpy(output, d_output, n * sizeof(float), cudaMemcpyDeviceToHost);

    auto duration_sec = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);	
    
    std::cout << output[n-1] << std::endl;
    std::cout << duration_sec << std::endl;

    cudaFree(d_image);
    cudaFree(d_mask);
    cudaFree(d_output);
    delete[] image;
    delete[] mask;
    delete[] output;

    return 0;
}
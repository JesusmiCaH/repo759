#include "matmul.cuh"
#include <iostream>
#include <cuda.h>

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n)
{
    // Calculate the row and column index for the element to compute
    int element_idx = blockIdx.x * blockDim.x + threadIdx.x;
    int row = element_idx / n;
    int col = element_idx % n;

    // Check if the indices are within bounds
    if (row < n && col < n) {
        float value = 0.0f;
        for (int k = 0; k < n; k++) {
            value += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = value;
    }
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block){
    // Calculate the number of blocks needed
    int num_elements = n * n;
    int num_blocks = (num_elements + threads_per_block - 1) / threads_per_block;

    // Launch the kernel
    matmul_kernel<<<num_blocks, threads_per_block>>>(A, B, C, n);

    // Wait for the kernel to finish
    cudaDeviceSynchronize();
}

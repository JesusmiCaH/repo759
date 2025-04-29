#include <cuda_runtime.h>
#include <iostream>
#include "matmul.cuh"

template <typename T, unsigned int block_dim>
__global__ void matmul_kernel(
    const T *A, T *B, T *C, 
    unsigned int n
) {
    __shared__ T tile_A[block_dim][block_dim];
    __shared__ T tile_B[block_dim][block_dim];
    uint round = (n + block_dim - 1) / block_dim;
    uint row = blockIdx.y * block_dim + threadIdx.y;
    uint col = blockIdx.x * block_dim + threadIdx.x;
    C[row * n + col] = 0;
    for(int i = 0; i < round; i++){
        if (i*block_dim + threadIdx.x < n && row < n) {
            tile_A[threadIdx.y][threadIdx.x] = A[row * n + i * block_dim + threadIdx.x];
        } else {
            tile_A[threadIdx.y][threadIdx.x] = 0;
        }
        if (i*block_dim + threadIdx.y < n && col < n) {
            tile_B[threadIdx.y][threadIdx.x] = B[(i * block_dim + threadIdx.y) * n + col];
        } else {
            tile_B[threadIdx.y][threadIdx.x] = 0;
        }
        __syncthreads();
        for (int j = 0; j<block_dim; j++){
            C[row * n + col] += tile_A[threadIdx.y][j] * tile_B[j][threadIdx.x];
        }
        __syncthreads();
    }
}

__host__ void matmul_1(
    const int *A, const int *B, int *C, 
    unsigned int n, unsigned int block_dim
) {
    int *d_A, *d_B, *d_C;
    size_t size = n * n * sizeof(int);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    matmul_kernel<int, block_dim> <<<grid, block>>>(d_A, d_B, d_C, n);
    cudaDeviceSynchronize();
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

__host__ void matmul_2(
    const float *A, const float *B, float *C, 
    unsigned int n, unsigned int block_dim
){
    float *d_A, *d_B, *d_C;
    size_t size = n * n * sizeof(float);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    matmul_kernel<float, block_dim> <<<grid, block>>>(d_A, d_B, d_C, n);
    cudaDeviceSynchronize();
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

__host__ void matmul_3(
    const double *A, const double *B, double *C, 
    unsigned int n, unsigned int block_dim
){
    double *d_A, *d_B, *d_C;
    size_t size = n * n * sizeof(double);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    matmul_kernel<double, block_dim> <<<grid, block>>>(d_A, d_B, d_C, n);
    cudaDeviceSynchronize();
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
    
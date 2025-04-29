#include <cuda_runtime.h>
#include <iostream>
#include "reduce.cuh"

__global__ void reduce_kernel(float *g_idata, float *g_odata, unsigned int n){
    extern __shared__ float sdata[];
    unsigned int tid = threadIdx.x;
    unsigned int i = blockIdx.x * blockDim.x * 2 + threadIdx.x;

    if (i < n) {
        sdata[tid] = g_idata[i];
        if (i+blockDim.x < n) {
            sdata[tid] += g_idata[i + blockDim.x];
        }
    } else {
        sdata[tid] = 0;
    }
    __syncthreads();
    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();
    }
    if (tid == 0) {
        g_odata[blockIdx.x] = sdata[0];
    }
}

__host__ void reduce(float **input, float **output, unsigned int N,
    unsigned int threads_per_block
){
    unsigned int blocks = (N + threads_per_block * 2 - 1) / (threads_per_block * 2);
    reduce_kernel<<<blocks, threads_per_block, threads_per_block * sizeof(float)>>>(input[0], output[0], N);
    cudaDeviceSynchronize();
    if (blocks > 1) {
        reduce(output, input, blocks, threads_per_block);
    }
    if (blocks == 1) {
        cudaMemcpy(input[0], output[0], sizeof(float), cudaMemcpyDeviceToDevice);
    }
}

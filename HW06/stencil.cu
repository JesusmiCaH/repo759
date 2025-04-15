#include "stencil.cuh"
#include <iostream>
#include <cuda.h>

__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R){
    extern __shared__ float shared[];
    float* shared_image = shared;
    float* shared_mask = shared + blockDim.x;
    float* shared_output = shared_mask + (2 * R + 1);

    unsigned int tid = threadIdx.x;
    unsigned int gid = blockIdx.x * blockDim.x + tid;

    // Load image and mask
    if(gid < n) {
        // Load shared_image value between idx = R:num_t+R
        shared_image[tid+R] = image[gid];
        if(tid < R){
            // Load shared_image value between idx = 0:R
            if(gid - R >= 0) {
                shared_image[tid] = image[gid - R];
            } else {
                shared_image[tid] = 0.0f; // Handle boundary condition
            }
            // Load shared_image value between idx = R+num_t:2R+num_t
            if(gid + R < n) {
                shared_image[tid + R + blockDim.x] = image[gid + R];
            } else {
                shared_image[tid + R + blockDim.x] = 0.0f; // Handle boundary condition
            }
        }
    }
    if (tid < 2 * R + 1) {
        shared_mask[tid] = mask[tid];
    }

    __syncthreads();

    // Convolution
    if(gid < n){
        shared_output[tid] = 0.0f;
        for(int i = -R; i <= R; i++) {
            shared_output[tid] += shared_image[tid + i + R] * shared_mask[i + R];
        }
        output[gid] = shared_output[tid];
    }
}


__host__ void stencil(const float* image,
    const float* mask,
    float* output,
    unsigned int n,
    unsigned int R,
    unsigned int threads_per_block){
        stencil_kernel<<<(n + threads_per_block - 1) / threads_per_block, threads_per_block, (2 * (R+threads_per_block) + 1) * sizeof(float)>>>(
            image, mask, output, n, R
        );
    }
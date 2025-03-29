#include <iostream>
#include <cuda.h>
#include <random>
#include "vscale.cuh"

__global__ void vscale(float* a, float* b, unsigned int n){
	int id = threadIdx.x;
	if(id < n){
		b[id] = a[id] * b[id];
	}
}


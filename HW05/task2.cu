#include <iostream>
#include <cuda.h>
#include <random>

__global__ void sum_kernel(int a, int* dA){
	int x = threadIdx.x;
	int y = blockIdx.x;
	dA[y*blockDim.x + x] = a*x + y;
}

int main(){
	unsigned int seed = 759;
	std::mt19937 generator(seed);
	std::uniform_int_distribution<int> dist(0,10);
	int a = dist(generator);
	int blocknum = 2;
	int threadnum = 8;

	int* dA;
        int hA[16];
	cudaMalloc(&dA, blocknum*threadnum*sizeof(int));

	sum_kernel<<<blocknum, threadnum>>>(a, dA);
	cudaDeviceSynchronize();

	cudaMemcpy(hA, dA, blocknum*threadnum*sizeof(int), cudaMemcpyDeviceToHost);

	for(int i=0; i<blocknum*threadnum; i++){
		printf("%d ",hA[i]);
	}
	std::cout<<std::endl;
	return 0;
}

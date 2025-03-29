#include <iostream>
#include <cuda.h>

__global__ void testfunc(){
	int a = threadIdx.x;
	int b = 1;
	for(int i=0; i<=a; i++){
		b*=(i+1);
	}
	printf("%d!=%d\n", a+1, b);
}

int main(){
	int blocknum = 1;
	int threadnum = 8;

	testfunc<<<blocknum, threadnum>>>();
	cudaDeviceSynchronize();
	return 0;
}

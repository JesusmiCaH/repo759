#include <iostream>
#include <chrono>
#include <cuda.h>
#include <random>
#include "vscale.cuh"

using namespace std;
using std::chrono::duration;

int main(int argc, char* argv[]){
	int n = std::stoi(argv[1]);

	unsigned int seed = 759;
	std::mt19937 generator(seed);
	std::uniform_real_distribution<float> dist_a(-10.0,10.0);
	std::uniform_real_distribution<float> dist_b(0.0,1.0);

	float a[n], b[n];
	float *da, *db;

	cudaMalloc(&da, n*sizeof(float));
	cudaMalloc(&db, n*sizeof(float));

	// initialize
	for(int i=0; i<n; i++){
		a[i] = dist_a(generator);
		b[i] = dist_b(generator);
	}

	cudaMemcpy(da, a, n*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(db, b, n*sizeof(float), cudaMemcpyHostToDevice);
	auto start_time = chrono::steady_clock::now();
	vscale<<<1, n>>>(da, db, n);
	cudaDeviceSynchronize();
	auto end_time = chrono::steady_clock::now();

	cudaMemcpy(a, da, n*sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(b, db, n*sizeof(float), cudaMemcpyDeviceToHost);

	auto duration_sec = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);	
	cout << duration_sec.count() << endl;
	cout << a[0] << endl;
	cout << a[n-1] << endl;
	
	return 0;
}

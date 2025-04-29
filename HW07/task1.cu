#include <iostream>
#include <cuda.h>
#include "matmul.cuh"
#include <chrono>
#include <random>

using std::chrono::duration;
using namespace std;

template <typename T>
void randomize(T* A, int n, T min, T max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    using DistType = std::conditional_t<
   	std::is_integral<T>::value,
    	std::uniform_int_distribution<T>,
    	std::uniform_real_distribution<T>
	>;
    DistType dist(min, max);
    for (int i = 0; i < n; i++) {
        A[i] = dist(gen);
    }
}

int main(int argc, char* argv[]){
    uint n = std::stoi(argv[1]);
    uint block_dim = std::stoi(argv[2]);

    int* A_1 = new int[n * n];
    int* B_1 = new int[n * n];
    int* C_1 = new int[n * n];
    float* A_2 = new float[n * n];
    float* B_2 = new float[n * n];
    float* C_2 = new float[n * n];
    double* A_3 = new double[n * n];
    double* B_3 = new double[n * n];
    double* C_3 = new double[n * n];
    randomize(A_1, n*n, -10, 10);
    randomize(B_1, n*n, -10, 10);
    randomize(A_2, n*n, -10.0f, 10.0f);
    randomize(B_2, n*n, -10.0f, 10.0f);
    randomize(A_3, n*n, -10.0, 10.0);
    randomize(B_3, n*n, -10.0, 10.0);
    

    auto start_time = std::chrono::steady_clock::now();
    matmul_1(A_1, B_1, C_1, n, block_dim);
    auto end_time = std::chrono::steady_clock::now();
    auto duration_sec_1 = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);	

    start_time = std::chrono::steady_clock::now();
    matmul_2(A_2, B_2, C_2, n, block_dim);
    end_time = std::chrono::steady_clock::now();
    auto duration_sec_2 = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);

    start_time = std::chrono::steady_clock::now();
    matmul_3(A_3, B_3, C_3, n, block_dim);
    end_time = std::chrono::steady_clock::now();
    auto duration_sec_3 = chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);
    
    cout << C_1[0] << endl << C_1[n-1] << endl;
    cout << duration_sec_1.count() << endl;
    cout << C_2[0] << endl << C_2[n-1] << endl;
    cout << duration_sec_2.count() << endl;
    cout << C_3[0] << endl << C_3[n-1] << endl;
    cout << duration_sec_3.count() << endl;
    cout << "------------------------" << endl;

    return 0;
}

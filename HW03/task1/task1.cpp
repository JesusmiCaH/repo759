#include <iostream>
#include <chrono>
#include <omp.h>
#include "matmul.h"
#include <random>

using namespace std;
using std::chrono::duration;

std::mt19937 gen(404);
std::uniform_real_distribution<float> dist(0,1);

struct Matrix{
    std::size_t height;
    std::size_t width;
    float *MatVals;

    Matrix(int h, int w){
        height = h;
        width = w;
        MatVals = (float*)malloc(h * w * sizeof(float));
    }
    void initialize(){
        //#pragma omp parallel for
        for(int i = 0; i < height*width; i++){
            MatVals[i] = dist(gen);
        }
        // cout << "finishInit" << MatVals[height * width -1 ] << endl;
    }
};

template <typename T>
void compute_n_timer(T A, T B, T (*mmul)(T, T));

int main(int argc, char* argv[]){
    int n = std::stoi(argv[1]);
    int t = std::stoi(argv[2]);
    omp_set_num_threads(t); 
    Matrix A(n,n);
    Matrix B(n,n);

    A.initialize();
    B.initialize();

    compute_n_timer(A,B,mmul);

}

template <typename T>
void compute_n_timer(T A, T B, T (*mmul)(T, T)){
    auto start_time = std::chrono::steady_clock::now();
    T C = mmul(A, B);
    auto end_time = std::chrono::steady_clock::now();

    auto duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);
    cout << C.MatVals[0] << endl;
    cout << C.MatVals[C.height * C.width - 1] << endl;
    cout << duration_sec.count() << endl;
    }

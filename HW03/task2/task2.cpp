#include <iostream>
#include <chrono>
#include <omp.h>
#include "convolution.h"

using namespace std;
using std::chrono::duration;


struct Matrix{
    std::size_t height;
    std::size_t width;
    float *MatVals;

    Matrix(int h, int w){
        height = h;
        width = w; 
        MatVals = (float*)malloc(h * w * sizeof(float));
    }
    void initialize(float min, float max){
        #pragma omp parallel for
        for(int i = 0; i < height*width; i++){
            MatVals[i] = (float)rand()/RAND_MAX * (max - min) + min;
        }
        // cout << "finishInit" << MatVals[height * width -1 ] << endl;
    }
};


template <typename T>
void compute_n_timer(T A, T B, T (*mmul)(T, T));

int main(int argc, char* argv[]){
    int n = std::stoi(argv[1]);
    int t = std::stoi(argv[2]);
    Matrix image(n,n);
    Matrix mask(3,3);

    omp_set_num_threads(t);
    image.initialize(-10, 10);
    mask.initialize(-1, 1);

    compute_n_timer(image, mask, convolve);
}

template <typename T>
void compute_n_timer(T A, T B, T (*conv)(T, T)){
    auto start_time = std::chrono::steady_clock::now();
    T C = conv(A, B);
    auto end_time = std::chrono::steady_clock::now();

    auto duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);

    cout << C.MatVals[0] << endl;
    cout << C.MatVals[C.height * C.width - 1] << endl;
    cout << "Time: " << duration_sec.count() << endl;
    }

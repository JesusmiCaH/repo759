#include <iostream>
#include <chrono>
#include "matmul.h"

using namespace std;

struct Matrix{
    unsigned int height;
    unsigned int width;
    double *MatVals;

    Matrix(int h, int w){
        height = h;
        width = w;
        MatVals = (double*)malloc(h * w * sizeof(double));
    }
};

void compute_n_timer(Matrix A, Matrix B, Matrix (*mmul)(Matrix, Matrix));

int main(){
    int dim = 1000;
    Matrix A(dim, dim);
    Matrix B(dim, dim);

    srand(time(NULL));
    for(int i=0; i<dim*dim; i++){
        A.MatVals[i] = (double)rand()/RAND_MAX;
    }
    for(int i=0; i<dim*dim; i++){
        B.MatVals[i] = (double)rand()/RAND_MAX;
    }
    cout << dim << endl;
    compute_n_timer(A,B,mmul1);
    compute_n_timer(A,B,mmul2);
    compute_n_timer(A,B,mmul3);
}    

void compute_n_timer(Matrix A, Matrix B, Matrix (*mmul)(Matrix, Matrix)){
    auto start_time = std::chrono::steady_clock::now();
    Matrix C = mmul(A, B);
    auto end_time = std::chrono::steady_clock::now();

    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);

    cout << duration.count() << endl;
    cout << C.MatVals[C.height * C.width - 1] << endl;
    }


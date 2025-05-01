#include <iostream>
#include <chrono>
#include "matmul.h"
#include <vector>

using namespace std;
using std::chrono::duration;
using std::vector;

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


struct vecMatrix{
    unsigned int height;
    unsigned int width;
    vector<double> MatVals;

    vecMatrix(int h, int w){
        height = h;
        width = w;
        MatVals.resize(h * w);
    }
};

template <typename T>
void compute_n_timer(T A, T B, T (*mmul)(T, T));

int main(){
    int dim = 1024;
    Matrix A(dim, dim);
    Matrix B(dim, dim);

    vecMatrix Av(dim, dim);
    vecMatrix Bv(dim, dim);

    srand(time(NULL));
    for(int i=0; i<dim*dim; i++){
        A.MatVals[i] = (double)rand()/RAND_MAX;
    }
    for(int i=0; i<dim*dim; i++){
        B.MatVals[i] = (double)rand()/RAND_MAX;
    }

    for(double &values : Av.MatVals){
        values = (double)rand()/RAND_MAX;
    }
    for(double &values : Bv.MatVals){
        values = (double)rand()/RAND_MAX;
    }

    cout << dim << endl;
    compute_n_timer(A,B,mmul1);
    compute_n_timer(A,B,mmul2);
    compute_n_timer(A,B,mmul3);
    compute_n_timer(Av,Bv,mmul4);
}    

template <typename T>
void compute_n_timer(T A, T B, T (*mmul)(T, T)){
    auto start_time = std::chrono::steady_clock::now();
    T C = mmul(A, B);
    auto end_time = std::chrono::steady_clock::now();

    auto duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end_time - start_time);

    cout << duration_sec.count() << endl;
    cout << C.MatVals[C.height * C.width - 1] << endl;
    }


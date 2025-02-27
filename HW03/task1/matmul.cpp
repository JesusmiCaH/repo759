#include "matmul.h"
#include <iostream>
#include <omp.h>

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


// Convert to Parallel version
struct Matrix mmul(struct Matrix A, struct Matrix B){
    Matrix C(A.height, B.width);
    #pragma omp parallel for
    for(int i = 0; i < C.height * C.width; i++){
        C.MatVals[i] = 0;
    }

    #pragma omp parallel for
    for(int i = 0; i < C.height; i++){
        for(int k = 0; k < A.width; k++){
            for(int j = 0; j < C.width; j++)
                C.MatVals[i*C.width + j] += A.MatVals[i*A.width + k] * B.MatVals[k*B.width + j];
        }
    }
    return C;
}



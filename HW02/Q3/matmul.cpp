#include "matmul.h"
#include <iostream>

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

    vecMatrix(int h, int w, double init_v = 0){
        height = h;
        width = w;
        MatVals.resize(h * w, init_v);
    }
};

struct Matrix mmul1(struct Matrix A, struct Matrix B){
    Matrix C(A.height, B.width);
    for(int i = 0; i < C.height * C.width; i++){
        C.MatVals[i] = 0;
    }

    for(int i = 0; i < C.height; i++){
        for(int j = 0; j < C.width; j++){
            for(int k = 0; k < A.width; k++)
                C.MatVals[i*C.width + j] += A.MatVals[i*A.width + k] * B.MatVals[k*B.width + j];
        }
    }
    return C;
}

struct Matrix mmul2(struct Matrix A, struct Matrix B){
    Matrix C(A.height, B.width);
    for(int i = 0; i < C.height * C.width; i++){
        C.MatVals[i] = 0;
    }

    for(int i = 0; i < C.height; i++){
        for(int k = 0; k < A.width; k++){
            for(int j = 0; j < C.width; j++)
                C.MatVals[i*C.width + j] += A.MatVals[i*A.width + k] * B.MatVals[k*B.width + j];
        }
    }
    return C;
}


struct Matrix mmul3(struct Matrix A, struct Matrix B){
    Matrix C(A.height, B.width);
    for(int i = 0; i < C.height * C.width; i++){
        C.MatVals[i] = 0;
    }

    
    for(int j = 0; j < C.width; j++){
        for(int k = 0; k < A.width; k++){
            for(int i = 0; i < C.height; i++)
                C.MatVals[i*C.width + j] += A.MatVals[i*A.width + k] * B.MatVals[k*B.width + j];
        }
    }
    return C;
}

struct vecMatrix mmul4(struct vecMatrix A, struct vecMatrix B){
    vecMatrix C(A.height, B.width, 0);

    for(int i = 0; i < C.height; i++){
        for(int j = 0; j < C.width; j++){
            for(int k = 0; k < A.width; k++)
                C.MatVals.at(i*C.width + j) += A.MatVals.at(i*A.width + k) * B.MatVals.at(k*B.width + j);
        }
    }
    return C;
}
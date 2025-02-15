#include <iostream>
#include <chrono>
#include "convolution.h"

using namespace std;

struct Matrix{
    unsigned int height;
    unsigned int width;
    float *MatVals;

    Matrix(int h, int w){
        height = h;
        width = w;
        MatVals = (float*)malloc(h * w * sizeof(float));
    }
};

int main(int argc, char *argv[]){
    int n = stoi(argv[1]);
    int m = stoi(argv[2]);

    Matrix image(n, n);
    Matrix mask(m, m);

    srand(time(NULL));
    for(int i=0; i<n*n; i++){
        image.MatVals[i] = (float)rand()/RAND_MAX;
    }
    for(int i=0; i<m*m; i++){
        mask.MatVals[i] = (float)rand()/RAND_MAX;
    }
    
    auto start_time = std::chrono::steady_clock::now();
    Matrix output = conv(image, mask);
    auto end_time = std::chrono::steady_clock::now();

    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
    cout << duration.count() << endl;
    cout << output.MatVals[0] << endl;
    cout << output.MatVals[output.height * output.width - 1] << endl;
}

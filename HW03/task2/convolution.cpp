#include "convolution.h"
#include <iostream>

struct Matrix{
    std::size_t height;
    std::size_t width;
    float *MatVals;

    Matrix(int h, int w){
        height = h;
        width = w;
        MatVals = (float*)malloc(h * w * sizeof(float));
    }
};

struct Matrix convolve(struct Matrix image, struct Matrix mask){
    Matrix result(image.height, image.width);

    #pragma omp parallel for collapse(2)
    for(int i = 0; i < result.height; i++){
        for(int j = 0; j < result.width; j++){
            result.MatVals[i*result.width + j] = 0;
            for(int u = 0; u < mask.height; u++){
                for(int v = 0; v < mask.width; v++){
                    int p_y = i - (mask.height - 1)/2 + u;
                    int p_x = j - (mask.width - 1)/2 + v;
                    float p_value;
                    bool y_in_range = (p_y>=0 && p_y<result.height);
                    bool x_in_range = (p_x>=0 && p_x<result.width);

                    if(x_in_range && y_in_range)
                        p_value = image.MatVals[p_y*image.width + p_x];
                    else if(!x_in_range && !y_in_range)
                        p_value = 0;
                    else 
                        p_value = 1;
                    result.MatVals[i*result.width + j] += p_value * mask.MatVals[u*mask.width + v];
                }
            }
        }
    }
    return result;
}
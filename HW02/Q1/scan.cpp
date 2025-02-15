#include "scan.h"
#include <iostream>
#include <vector>

float *scan(float *arr, int n) {
    float sum = 0;
    float *output = (float *)malloc(n * sizeof(float));
    for (int i = 0; i < n; i++) {
        sum += arr[i];
        output[i] = sum;
    }
    return output;
}
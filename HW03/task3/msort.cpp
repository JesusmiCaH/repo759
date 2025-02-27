#include <iostream>
#include "msort.h"

void msort(int* arr, const std::size_t n, const std::size_t threshold){
    if(n<=1){
        return;
    }
    else if(n <= threshold){
        #pragma omp task
        msort(arr, n/2, threshold);
        #pragma omp task
        msort(arr + n/2, (n-n/2), threshold);
        #pragma omp taskwait
    }
    else{
        msort(arr, n/2, threshold);
        msort(arr + n/2, (n-n/2), threshold);
    }
    
    int* temp = (int*)malloc(n*sizeof(int));
    std::copy(arr, arr+n, temp);
    int i = 0;
    int j = n/2;
    for(int k = 0; k<n; k++){
        if( i>=n/2 || (temp[j]<=temp[i] && j<n) ){
            arr[k] = temp[j];
            j++;
        }
        else{
            arr[k] = temp[i];
            i++;
        }
    }
    free(temp);
}
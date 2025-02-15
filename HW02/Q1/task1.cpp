#include <iostream>
#include <chrono>
#include "scan.h"
using namespace std;

int main(int argc, char *argv[]) {
    int n = std::stoi(argv[1])+1;
    float *arr = (float *)malloc(n * sizeof(float));

    float interval = 2.0/n;
    arr[0] = -1;
    for(int i=1; i<n; i++){
        arr[i] = arr[i-1] + interval;
    }
     // Main body
    auto start_time = std::chrono::steady_clock::now();
    float *scanned_arr = scan(arr, n);
    auto end_time = std::chrono::steady_clock::now();

    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
    cout << duration.count() << endl;
    cout << scanned_arr[0] << endl <<  scanned_arr[n] << endl;

    free(arr);
    free(scanned_arr);
}
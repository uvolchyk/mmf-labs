#include <iostream>

static const int numberOfElements = 10;

using namespace std;

int partitionLomuto(int *&, int, int);
void quicksortLomuto(int *&, int, int);

int partitionHoare(int *&, int, int);
void quicksortHoare(int *&, int, int);

int main() {
    int *array = new int[numberOfElements];

    for (int i = 0; i < numberOfElements; i++) array[i] = arc4random_uniform(1000);    
    quicksortHoare(array, 0, numberOfElements - 1);
    cout << "Hoare's result" << endl;
    for(int i = 0; i < numberOfElements; i++) cout << array[i] << endl;

    for (int i = 0; i < numberOfElements; i++) array[i] = arc4random_uniform(1000);
    quicksortLomuto(array, 0, numberOfElements - 1);
    cout << "Lomuto's result" << endl;
    for(int i = 0; i < numberOfElements; i++) cout << array[i] << endl;

    return 0;

}


// Lomuto's paritition scheme

int partitionLomuto(int *&array, int low, int high) {
    int pivot = array[high];
    int i = low;

    for (int j = low; j < high; j++) {
        if (array[j] < pivot) {
            int tmp = array[j];
            array[j] = array[i];
            array[i] = tmp;
            i++;                 
        }
    }

    int tmp = array[high];
    array[high] = array[i];
    array[i] = tmp;
    return i;
}

void quicksortLomuto(int *&array, int low, int high) {
    if (low < high) {
        int pivot = partitionLomuto(array, low, high);
        quicksortLomuto(array, low, pivot - 1);
        quicksortLomuto(array, pivot + 1, high);
    }
}


// Hoare's paritition scheme

int partitionHoare(int *&array, int low, int high) {
    int pivot = array[low];
    
    int i = low - 1;
    int j = high + 1;

    while (true) {
        do { i++; } while (array[i] < pivot);
        do { j--; } while (array[j] > pivot);

        if (i >= j) return j;
        
        int tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
    }
    
}

void quicksortHoare(int *&array, int low, int high) {
    if (low < high) {
        int pivot = partitionHoare(array, low, high);
        quicksortHoare(array, low, pivot - 1);
        quicksortHoare(array, pivot + 1, high);
    }
}
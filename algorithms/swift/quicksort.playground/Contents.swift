import Foundation

let numberOfElements = 10

func generator(max: Int = numberOfElements) -> [Int] {
    (1..<max).map { _ -> Int in Int.random(in: -2000...1000) }
}

// MARK: Lomuto partition scheme

func partitionLomuto<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let pivot = array[high]
    var i = low
    
    for j in low..<high {
        if array[j] <= pivot {
            array.swapAt(i, j)
            i += 1
        }
    }
    
    
    array.swapAt(i, high)
    return i
}

func quicksortLomuto<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = Int.random(in: low...high)
        array.swapAt(high, pivotIndex)
        let pivot = partitionLomuto(&array, low: low, high: high)
        quicksortLomuto(&array, low: 0, high: pivot - 1)
        quicksortLomuto(&array, low: pivot + 1, high: high)
    }
}

var lomutoArray = generator()
quicksortLomuto(&lomutoArray, low: 0, high: lomutoArray.count - 1)
print("\n---Lomuto's result---")
print(lomutoArray)


// MARK: Hoare's partition scheme

func partitionHoare<T: Comparable>(_ array: inout [T], low: Int, high: Int) -> Int {
    let pivotIndex = Int.random(in: low...high)
    let pivot = array[pivotIndex]
    var lo = low - 1
    var hi = high + 1
    
    while true {
        repeat { lo += 1 } while array[lo] < pivot
        repeat { hi -= 1 } while array[hi] > pivot
        
        if lo >= hi { return hi }
        array.swapAt(lo, hi)
    }
}


func quicksortHoare<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let pivot = partitionHoare(&array, low: low, high: high)
        quicksortHoare(&array, low: 0, high: pivot - 1)
        quicksortHoare(&array, low: pivot + 1, high: high)
    }
}

var hoareArray = generator()
quicksortHoare(&hoareArray, low: 0, high: hoareArray.count - 1)
print("\n---Hoare's result---")
print(hoareArray)

import Foundation

let graph: Graph = .init()

let n1 = Node(1)
let n2 = Node(2)
let n3 = Node(3)
let n4 = Node(4)
let n5 = Node(5)
let n6 = Node(6)


let routesMatrix: Matrix<Int> = .init(6, 6, defaultValue: -1)
//
routesMatrix[0,1] = 5
routesMatrix[0,2] = 5
routesMatrix[0,3] = 7
routesMatrix[0,4] = 10
routesMatrix[0,5] = 15
routesMatrix[1,0] = 5
routesMatrix[1,2] = 4
routesMatrix[1,3] = 12
routesMatrix[1,4] = 5
routesMatrix[1,5] = 6
routesMatrix[2,0] = 4
routesMatrix[2,1] = 4
routesMatrix[2,3] = 2
routesMatrix[2,4] = 4
routesMatrix[2,5] = 3
routesMatrix[3,0] = 7
routesMatrix[3,1] = 12
routesMatrix[3,2] = 2
routesMatrix[3,4] = -1
routesMatrix[3,5] = 14
routesMatrix[4,0] = 10
routesMatrix[4,1] = -1
routesMatrix[4,2] = 4
routesMatrix[4,3] = 2
routesMatrix[4,5] = 3
routesMatrix[5,0] = 15
routesMatrix[5,1] = 6
routesMatrix[5,2] = 3
routesMatrix[5,3] = 14
routesMatrix[5,4] = 3

routesMatrix.description

let supplementaryMatrix = Matrix(6, 6, defaultValue: 1)
(0...5).forEach { (i) in
    (0...5).forEach { (j) in
        supplementaryMatrix[i,j] = i + 1
    }
}
supplementaryMatrix.description


(0..<6).forEach { (i) in
    (0..<6).forEach { (j) in
        (0..<6).forEach { (k) in
            let ijVal = routesMatrix[i,j]
            let ikVal = routesMatrix[i,k]
            let kjVal = routesMatrix[k,j]
            guard ijVal > 0, ikVal > 0, kjVal > 0 else { return }
            if ijVal > ikVal + kjVal {
                routesMatrix[i,j] = ikVal + kjVal
                supplementaryMatrix[i,j] = k + 1
            }
        }
    }
}

print(routesMatrix)
print(supplementaryMatrix)


/// 1
(0..<6).forEach { (row) in
    if let min = routesMatrix[row].filter({ $0 >= 0 }).min() {
        (0..<6).forEach { (col) in routesMatrix[row, col] -= min }
    }
}

print(routesMatrix)

/// 2
(0..<6).forEach { (col) in
    if let min = routesMatrix.col(col).filter({ $0 >= 0 }).min() {
        (0..<6).forEach { (row) in routesMatrix[row, col] -= min }
    }
}

print(routesMatrix)

/// 3
let grades1 = Matrix(6, 6, defaultValue: 0)

(0..<6).forEach { (row) in
    (0..<6).forEach { (col) in
        if routesMatrix[row, col] == 0 {
            if let rowMin = routesMatrix[row].filter({ $0 > 0 }).min(),
               let colMin = routesMatrix.col(col).filter({ $0 > 0 }).min() {
                grades1[row, col] = rowMin + colMin
            }
        }
    }
}

print(grades1)

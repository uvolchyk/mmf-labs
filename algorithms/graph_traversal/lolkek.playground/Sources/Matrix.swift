import Foundation

public final class Matrix<T>: CustomStringConvertible {
    let rows: Int
    let columns: Int
    var grid: [T]
    
    public init(_ rows: Int, _ columns: Int, defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = .init(repeating: defaultValue, count: rows * columns)
    }
    
    public subscript(row: Int, col: Int) -> T {
        get { grid[row * columns + col] }
        set { grid[row * columns + col] = newValue }
    }
    
    public subscript(row: Int) -> [T] {
        get {
            (0..<columns).map({ self[row, $0] })
        }
    }
    
    public func col(_ col: Int) -> [T] {
        (0..<rows).compactMap { (row) -> T? in self[row, col] }
    }
    
    public var description: String {
        var description = ""
        
        for i in 0..<rows {
            let contents = (0..<columns)
                .map{ "\(self[i, $0])" }
                .joined(separator: " ")
            
            switch (i, rows) {
            case (0, 1):
                description += "( \(contents) )\n"
            case (0, _):
                description += "⎛ \(contents) ⎞\n"
            case (rows - 1, _):
                description += "⎝ \(contents) ⎠\n"
            default:
                description += "⎜ \(contents) ⎥\n"
            }
        }
        return description
    }
}

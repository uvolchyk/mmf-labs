import Foundation

public final class Node: Hashable, CustomStringConvertible {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    public var description: String { "\(value)" }
    
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
}

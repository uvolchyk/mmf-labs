import Foundation

public final class Edge: Hashable {
    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.nodes == rhs.nodes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(nodes)
    }
    
    public let nodes: [Node]
    
    public init(_ n1: Node, n2: Node) {
        nodes = [n1, n2]
    }
}

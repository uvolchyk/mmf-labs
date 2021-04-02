import Foundation

public final class Graph {
    public enum `Type` {
        case directed
        case undirected
    }
    
    public init() {}
    
    public var type: Type = .undirected
    
    public var nodes: Set<Node> = .init()
    public var edges: Set<Edge> = .init()
}

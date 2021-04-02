import Foundation

public func treeLines(_ nodeIndent: String = "", _ childIndent: String = "", node: Node, adj: [Node: [Node]]) -> [String] {
    guard let children = adj[node] else { return [] }
    return [nodeIndent + "\(node.value)"]
        + children.enumerated()
        .map({ (enumer) -> (Bool, Node) in
            (enumer.offset < children.count - 1, enumer.element)
        })
        .flatMap({ (cort) -> [String] in
            cort.0 ? treeLines("┣╸", "┃ ", node: cort.1, adj: adj) : treeLines("┣╸", "┃ ", node: cort.1, adj: adj)
        })
        .map({ childIndent + $0 })
}

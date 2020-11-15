// MARK: Node

class BTreeNode<Key: Comparable, Value: CustomStringConvertible> {
    
    let owner: BTree<Key, Value>
    
    var keys: Array<Key> = []
    var values: Array<Value> = []
    var children: Array<BTreeNode> = []
    
    var isLeaf: Bool { children.isEmpty }
    var numberOfKeys: Int { keys.count }
    
    init(owner: BTree<Key, Value>) {
        self.owner = owner
    }
    
    convenience init(owner: BTree<Key, Value>,
                     keys: Array<Key>,
                     values: Array<Value>,
                     children: Array<BTreeNode>? = nil) {
        self.init(owner: owner)
        self.keys += keys
        self.values += values
        self.children = children ?? []
    }
}

extension BTreeNode {
    
    func value(for key: Key) -> Value {
        var index = keys.startIndex
        while (index + 1) < keys.endIndex && keys[index] < key { index = (index + 1) }
        return values[index]
    }
}

extension BTreeNode {
    func insert(_ value: Value, for key: Key) {
        var index = keys.startIndex
        
        while (index + 1) < keys.endIndex && keys[index] < key { index = (index + 1) }
        
        if index < keys.endIndex && keys[index] == key {
            values[index] = value
            return
        }
        
        if isLeaf {
            keys.insert(key, at: index)
            values.insert(value, at: index)
            owner.numberOfKeys = (owner.numberOfKeys + 1)
        } else {
            children[index].insert(value, for: key)
            if children[index].numberOfKeys > owner.order {
                split(children[index], at: index)
            }
        }
    }
    
    func split(_ child: BTreeNode, at index: Int) {
        let middle = index / 2
        keys.insert(child.keys[middle], at: index)
        values.insert(child.values[middle], at: index)
        child.keys.remove(at: middle)
        child.values.remove(at: middle)
        
        let newSibling = BTreeNode(
            owner: owner,
            keys: Array(child.keys[child.keys.indices.suffix(from: middle)]),
            values: Array(child.values[child.values.indices.suffix(from: middle)])
        )
        child.keys.removeSubrange(child.keys.indices.suffix(from: middle))
        child.values.removeSubrange(child.values.indices.suffix(from: middle))
        
        children.insert(newSibling, at: index + 1)
        
        if !child.children.isEmpty {
            newSibling.children = Array(
                child.children[child.children.indices.suffix(from: middle + 1)]
            )
            child.children.removeSubrange(child.children.indices.suffix(from: middle + 1))
        }
    }
}

extension BTreeNode: CustomStringConvertible {
    var description: String { keys.description }
    
    func treeLines(_ nodeIndent:String = "", _ childIndent:String="") -> [String] {
        var result = ["\(nodeIndent)\(description)"]
        result.append(contentsOf: children.enumerated().map { ($0 < children.count - 1, $1) }
                                     .flatMap{ $0 ? $1.treeLines("┣╸","┃ ") : $1.treeLines("┗╸","  ") }
                                     .map{ childIndent + $0 })
        
        return result
       }

    func printTree() { print(treeLines().joined(separator:"\n")) }
}

extension BTreeNode {
    func traverseKeysPostOrder(_ process: (BTreeNode) -> Void) {
        children.last?.traverseKeysPostOrder(process)
        children.reversed().enumerated().forEach { (i, child) in
            if !child.children.isEmpty {
                child.traverseKeysPostOrder(process)
            }
            process(child)
        }
    }
}

// MARK: Tree

class BTree<Key: Comparable, Value: CustomStringConvertible> {
    let order: Int
    
    lazy var rootNode: BTreeNode<Key, Value> = BTreeNode<Key, Value>(owner: self)
    
    var numberOfKeys: Int = 0
    
    init(order: Int) {
        self.order = order
    }
    
    func insert(_ value: Value, for key: Key) {
        rootNode.insert(value, for: key)
        if rootNode.numberOfKeys > order { splitRoot() }
    }

    func splitRoot() {
        let middle = rootNode.numberOfKeys / 2

        let newRoot = BTreeNode<Key, Value>(
            owner: self,
            keys: [rootNode.keys[middle]],
            values: [rootNode.values[middle]],
            children: [rootNode]
        )
        rootNode.keys.remove(at: middle)
        rootNode.values.remove(at: middle)

        let newSibling = BTreeNode<Key, Value>(
            owner: self,
            keys: Array(rootNode.keys[rootNode.keys.indices.suffix(from: middle)]),
            values: Array(rootNode.values[rootNode.values.indices.suffix(from: middle)])
        )

        rootNode.keys.removeSubrange(rootNode.keys.indices.suffix(from: middle))
        rootNode.values.removeSubrange(rootNode.values.indices.suffix(from: middle))

        if !rootNode.children.isEmpty {
            newSibling.children = Array(
                rootNode.children[rootNode.children.indices.suffix(from: middle + 1)]
            )
            rootNode.children.removeSubrange(rootNode.children.indices.suffix(from: middle + 1))
        }

        newRoot.children.append(newSibling)
        rootNode = newRoot
    }
    
}


let tree = BTree<Int, Int>(order: 5)

let initialMeta = (1...16).map { _ -> Int in Int.random(in: 0...150) }.sorted()
let testMeta = Array(initialMeta.suffix(from: 8)) + Array(initialMeta.prefix(upTo: 8))
print("Сгенерированные данные")
print(testMeta.enumerated().map { "\($0) - \($1)"})
testMeta.enumerated().forEach { (n, x) in
    tree.insert(x, for: n)
}

print("Представление дерева")
tree.rootNode.printTree()

print("Результат поиска снизу\n \(tree.rootNode.value(for: 4)) <- value")

print("Результат обратного обхода")
tree.rootNode.traverseKeysPostOrder({ (node) in
    print(node.keys)
})

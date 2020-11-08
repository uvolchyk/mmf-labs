
// MARK: -

class Node<Value: Comparable> {
    var left: Node?
    var right: Node?
    var parent: Node?
    var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    convenience init(left: Node?, right: Node?, value: Value) {
        self.init(value: value)
        self.left = left
        self.right = right
    }
}

extension Node: CustomStringConvertible {
    var description: String { "\(value)" }
}

// MARK: -

extension Node {
    var inorder: String {
        var result = ""
        result.append("(\(left?.inorder ?? "")) <- ")
        result.append(description)
        result.append(" -> (\(right?.inorder ?? ""))")
        return result
    }
    
    var preorder: String {
        var result = ""
        result.append(description)
        result.append(left?.preorder ?? "")
        result.append(right?.preorder ?? "")
        return result
    }
    
    var postorder: String {
        var result = ""
        result.append("\n\(left?.postorder ?? "") ")
        result.append(" \(right?.postorder ?? "")  ")
        result.append("   \(description)")
        return result
    }
    
    func postorder(node: Node?, padding: Int = 0) {
        if let node = node {
            postorder(node: node.left, padding: padding + 1)
            postorder(node: node.right, padding: padding + 1)
            print(String(repeating: " ", count: padding) + " \(node.value) \n")
            
        }
    }
}

// MARK: -

extension Node {
    func searchBelow(for value: Value) -> Node? {
        var node: Node? = self
        while let n = node {
            if value < n.value, let left = n.left {
            node = left
            } else if value > n.value, let right = n.right {
            node = right
          } else {
            break
          }
        }
        return node?.parent
    }
}

extension Node {
    public func insert(value: Value) {
      if value < self.value {
        if let left = left {
          left.insert(value: value)
        } else {
          left = Node(value: value)
            left?.parent = self
        }
      } else {
        if let right = right {
          right.insert(value: value)
        } else {
          right = Node(value: value)
            right?.parent = self
        }
      }
    }
}

var testMeta = (1...16).map { _ -> Int in Int.random(in: 0...150) }.sorted()
print(testMeta)
let root = Node<Int>(value: testMeta[8])
testMeta.remove(at: 8)
testMeta.forEach { root.insert(value: $0) }

root.postorder(node: root)

print("\(root.searchBelow(for: 20)?.value ?? 0) <-")

import Foundation
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
            postorder(node: node.right, padding: padding + 4)
            if padding != 0 {
                print("")
            }
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
print("Сгенерированный массив: \(testMeta)")
print("Корневой элемент: \(testMeta[8])")
let root = Node<Int>(value: testMeta[8])
testMeta.remove(at: 8)
testMeta.forEach { root.insert(value: $0) }


func treeString<T>(_ node:T, reversed:Bool=false, isTop:Bool=true, using nodeInfo:(T)->(String,T?,T?)) -> String
{
   let (stringValue, leftNode, rightNode) = nodeInfo(node)

   let stringValueWidth  = stringValue.count

   let leftTextBlock     = leftNode  == nil ? []
                         : treeString(leftNode!,reversed:reversed,isTop:false,using:nodeInfo)
                           .components(separatedBy:"\n")

   let rightTextBlock    = rightNode == nil ? []
                         : treeString(rightNode!,reversed:reversed,isTop:false,using:nodeInfo)
                           .components(separatedBy:"\n")

   let commonLines       = min(leftTextBlock.count,rightTextBlock.count)
   let subLevelLines     = max(rightTextBlock.count,leftTextBlock.count)

   let leftSubLines      = leftTextBlock
                         + Array(repeating:"", count: subLevelLines-leftTextBlock.count)
   let rightSubLines     = rightTextBlock
                         + Array(repeating:"", count: subLevelLines-rightTextBlock.count)

   let leftLineWidths    = leftSubLines.map{$0.count}
   let rightLineIndents  = rightSubLines.map{$0.prefix{$0==" "}.count  }

   let firstLeftWidth    = leftLineWidths.first   ?? 0
   let firstRightIndent  = rightLineIndents.first ?? 0

   let linkSpacing       = min(stringValueWidth, 2 - stringValueWidth % 2)
   let leftLinkBar       = leftNode  == nil ? 0 : 1
   let rightLinkBar      = rightNode == nil ? 0 : 1
   let minLinkWidth      = leftLinkBar + linkSpacing + rightLinkBar
   let valueOffset       = (stringValueWidth - linkSpacing) / 2

   let minSpacing        = 2
   let rightNodePosition = zip(leftLineWidths,rightLineIndents[0..<commonLines])
                           .reduce(firstLeftWidth + minLinkWidth)
                           { max($0, $1.0 + minSpacing + firstRightIndent - $1.1) }

   let linkExtraWidth    = max(0, rightNodePosition - firstLeftWidth - minLinkWidth )
   let rightLinkExtra    = linkExtraWidth / 2
   let leftLinkExtra     = linkExtraWidth - rightLinkExtra

   let valueIndent       = max(0, firstLeftWidth + leftLinkExtra + leftLinkBar - valueOffset)
   let valueLine         = String(repeating:" ", count:max(0,valueIndent))
                         + stringValue
   let slash             = reversed ? "\\" : "/"
   let backSlash         = reversed ? "/"  : "\\"
   let uLine             = reversed ? "¯"  : "_"
   
   let leftLink          = leftNode == nil ? ""
                         : String(repeating: " ", count:firstLeftWidth)
                         + String(repeating: uLine, count:leftLinkExtra)
                         + slash
    
   let rightLinkOffset   = linkSpacing + valueOffset * (1 - leftLinkBar)
   let rightLink         = rightNode == nil ? ""
                         : String(repeating:  " ", count:rightLinkOffset)
                         + backSlash
                         + String(repeating:  uLine, count:rightLinkExtra)

   let linkLine          = leftLink + rightLink

   let leftIndentWidth   = max(0,firstRightIndent - rightNodePosition)
   let leftIndent        = String(repeating:" ", count:leftIndentWidth)
   let indentedLeftLines = leftSubLines.map{ $0.isEmpty ? $0 : (leftIndent + $0) }

   let mergeOffsets      = indentedLeftLines
                           .map{$0.count}
                           .map{leftIndentWidth + rightNodePosition - firstRightIndent - $0 }
                           .enumerated()
                           .map{ rightSubLines[$0].isEmpty ? 0  : $1 }

   let mergedSubLines    = zip(mergeOffsets.enumerated(),indentedLeftLines)
                           .map{ ( $0.0, $0.1, $1 + String(repeating:" ", count:max(0,$0.1)) ) }
                           .map{ $2 + String(rightSubLines[$0].dropFirst(max(0,-$1))) }

   let treeLines = [leftIndent + valueLine]
                 + (linkLine.isEmpty ? [] : [leftIndent + linkLine])
                 + mergedSubLines

   return (reversed && isTop ? treeLines.reversed(): treeLines)
          .joined(separator:"\n")
}

print(treeString(root) { (node) -> (String, Node<Int>?, Node<Int>?) in return ("\(node.description)", node.left, node.right)})

print("\(root.searchBelow(for: 97)!.value)")

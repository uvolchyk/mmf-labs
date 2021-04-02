import Foundation

public final class Queue<T: Hashable> {
    private var items: [T]
    
    public var isEmpty: Bool { items.isEmpty }
    public var count: Int { items.count }
    public init() {
        items = []
    }
    
    public func enqueue(_ item: T) { items.append(item) }
    public func dequeue() -> T? { items.removeLast() }
    public func shift() -> T? { items.removeFirst() }
}

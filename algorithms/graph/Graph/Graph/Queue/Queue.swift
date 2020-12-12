//
//  Queue.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 12.12.20.
//

import Foundation

protocol QueueType {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct Queue<T>: QueueType {
    
    typealias Element = T
    private var queue = [T]()
    
    var isEmpty: Bool { queue.isEmpty }
    var peek: T? { queue.first }
    mutating func enqueue(_ element: T) { queue.append(element) }
    mutating func dequeue() -> T? { queue.isEmpty ? nil : queue.removeFirst() }
}

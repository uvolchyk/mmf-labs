//
//  GraphExtensions.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 11.12.20.
//

import Foundation
import Graphite

extension Graph {
    func copy() -> Graph {
        return Graph(nodes: nodes, edges: edges)        
    }
    
    mutating func addNode(_ node: Int) {
        nodes.insert(node)
    }
    
    mutating func removeNode(_ node: Int) {
        nodes.remove(node)
    }
    
    mutating func addEdge(_ edge: Edge) {
        edges.insert(edge)
    }
    
    mutating func removeEdge(_ edge: Edge) {
        edges.remove(edge)
    }
}

// MARK: -

extension Graph.Edge {
    func next(to node: Int) -> Int? { nodes.filter({ $0 != node }).first }
}

// MARK: - BFS with inner queue

struct BFS {
    var markCompletion: ((Int) -> ())?
    
    private var graph: Graph
    private var nodes: [Int:Bool]
    
    var pq = Queue<Int>()
    
    init(_ graph: Graph) {
        self.graph = graph
        nodes = graph.nodes
            .reduce([Int:Bool](), { (dict, node) -> [Int:Bool] in
                var dict = dict
                dict[node] = false
                return dict
            })
    }
    
    mutating func settle(_ node: Int) {
        markCompletion?(node)
        nodes[node] = true
    }
    
    func isSettled(_ node: Int) -> Bool { nodes[node] ?? false }
    
    mutating func bfs(start: Int, goal: Int, completion: (Bool) -> ()) {
        pq.enqueue(start)
        settle(start)
        while(!pq.isEmpty) {
            if let q = pq.dequeue() {
                graph.edges
                    .filter { edge -> Bool in edge.nodes.sorted()[0] == q }
                    .map { edge -> Int in edge.nodes.sorted()[1] }
                    .forEach { vertex in
                        if (vertex == goal) {
                            settle(goal)
                            completion(true)
                            return
                        }
                        if (!isSettled(vertex)) {
                            pq.enqueue(vertex)
                            settle(vertex)
                        }
                    }
                
            }
        }
        completion(false)
    }
}

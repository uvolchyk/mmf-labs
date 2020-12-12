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

// MARK: - Bron-Kerbosch

struct BK {
    private var graph: Graph
    private var compsub = Set<Int>()
    var clicques = Set<Set<Int>>()
    
    init(_ graph: Graph) {
        self.graph = graph
    }
    
    mutating func dothings() {
        var candidates = Set(graph.nodes)
        var not = Set<Int>()
        var clicque = Set<Int>()
        extends(clicque: &clicque, candidates: &candidates, excluded: &not)
    }
    
//    mutating func extends(clicque: Set<Int>, candidates: inout Set<Int>, not: inout Set<Int>) {
//        if (!candidates.isEmpty && !not.isEmpty) {
//            if (!clicque.isEmpty) {
//                self.clicques.insert(clicque)
//            }
////            return
//        }
//
//        var innerCandidates = Set(candidates)
//        var innerNot = Set(not)
//
//        candidates.forEach { (vertex) in
//            let neighbours = graph.edges
//                                .filter { $0.nodes.sorted()[0] == vertex }
//                                .map { $0.nodes.sorted()[1] }
//            candidates = candidates.intersection(neighbours)
//            not = not.intersection(neighbours)
//            extends(clicque: clicque.union([vertex]), candidates: &candidates, not: &not)
//            candidates.remove(vertex)
//            not.insert(vertex)
//        }
//    }
    
    mutating func extends(clicque: inout Set<Int>, candidates: inout Set<Int>, excluded: inout Set<Int>) {
        let isEnd = !excluded.filter { (vertex) -> Bool in
            graph.edges
                .filter({ !$0.nodes.intersection(candidates).isEmpty && $0.nodes.contains(vertex) })
                .count == candidates.count
            }.isEmpty
        while(!candidates.isEmpty && !isEnd) {
            candidates.forEach { (vertex) in
                clicque.insert(vertex)
                candidates.remove(vertex)
                let neighbours = graph.edges
                    .filter({ $0.nodes.contains(vertex) })
                    .map({ $0.nodes.subtracting([vertex]).first! })
                var newCandidates = candidates.intersection(neighbours)
                var newExcluded = excluded.intersection(neighbours)
                if (newCandidates.isEmpty && newExcluded.isEmpty) {
                    clicques.insert(Set(clicque))
                } else {
                    extends(clicque: &clicque, candidates: &newCandidates, excluded: &newExcluded)
                }
                excluded.insert(vertex)
            }
        }
    }
    
//    func end(candidates: Set<Int>, excluded: Set<Int>) -> Bool {
//        var end = false
//        var edgecounter: Int = 0
//        excluded.forEach { (found) in
//            edgecounter = 0
//            candidates.forEach { (candidate) in
//                if (!graph.edges.filter({ $0.nodes.intersection([found, candidate]).count == 2 }).isEmpty) {
//                    edgecounter += 1
//                }
//            }
//            if (edgecounter == candidates.count) {
//                end = true
//            }
//        }
//        return end
//    }
}

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

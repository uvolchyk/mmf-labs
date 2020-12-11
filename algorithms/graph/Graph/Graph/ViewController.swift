//
//  ViewController.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 11.12.20.
//

import UIKit
import Graphite

extension Int {
    static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}

class ViewController: UIViewController {
    
    var flag = true

    var presenter: WeightedGraphPresenter!
    
//    var nodes: [Int: (name: String, color: UIColor)] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nodes = 1...20
//        let edges = (1..<20).map {
//            Graph.Edge(nodes: [$0, $0 + 1], weight: 0.1)
//        }
//        let edges = nodes.map {
////            Graph.Edge(nodes: [$0, Int(sqrt(Double($0)))], weight: 1)
//            Graph.Edge(nodes: [$0, Int.random(max: $0-1)], weight: 0.1)
////            Graph.Edge(nodes: [$0, $0 % 2], weight: 1)
//        }
        
        let edges: [Graph.Edge] = (1..<20).map { a in
            let b = max(min(100, Int.random(max: 8) - 4 + a), 0)
            return Graph.Edge(nodes: [a, b], weight: 0.1)
        }
        
        let graph = Graph(nodes: nodes, edges: edges)
        
        presenter = WeightedGraphPresenter(graph: Graph(nodes: [], edges: []), view: self.view)
        presenter.collisionDistance = 100
        presenter.delegate = self
        presenter.edgeColor = .yellow
        presenter.start()
        presenter.graph = graph
        presenter.backgroundColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flag {
            presenter.graph.edges.insert(.init(nodes: [4,10], weight: 3))
        } else {
            presenter.graph.edges.remove(.init(nodes: [4,10], weight: 3))
        }
        flag.toggle()
//        if let num1 = (1...20).randomElement() {
//            if let num2 = (1...20).filter({ $0 != num1 }).randomElement() {
//                presenter.graph.edges.insert(.init(nodes: [num1,num2], weight: 0.4))
//            }
//        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        presenter.graph.nodes.insert(.random(max: 400))
    }
}

extension ViewController: WeightedGraphPresenterDelegate {
    func view(for node: Int, presenter: WeightedGraphPresenter) -> UIView {
        let view = UIView()
        let length = 20
        view.frame = CGRect(x: 0, y: 0, width: length, height: length)
        view.layer.cornerRadius = CGFloat(length / 2)
        view.layer.backgroundColor = UIColor(hue: CGFloat(node) / 70, saturation: 1, brightness: 1, alpha: 1).cgColor
        return view
    }
    
    func configure(view: UIView, for node: Int, presenter: WeightedGraphPresenter) {
        
    }
    
    func visibleRange(for node: Int, presenter: WeightedGraphPresenter) -> ClosedRange<Float>? {
        return nil
    }
}

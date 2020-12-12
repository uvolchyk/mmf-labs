//
//  ThirdMISViewController.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 12.12.20.
//

import UIKit
import Graphite

class ThirdMISViewController: UIViewController {

    var presenter: WeightedGraphPresenter!
    
    var bk: BK?
    
    var misses = Array<Set<Int>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(image: UIImage(systemName: "wand.and.stars"), style: .plain, target: self, action: #selector(dothings))
        navigationItem.rightBarButtonItem = button
        
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(resetGraph))
        let addVertextButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addVertex))
        let addEdgeButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(addEdge))
        
        let removeVertexButton = UIBarButtonItem(image: UIImage(systemName: "minus.circle"), style: .plain, target: self, action: #selector(removeVertex))
        let removeEdgeButton = UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .plain, target: self, action: #selector(removeEdge))
        navigationItem.leftBarButtonItems = [addVertextButton, removeVertexButton, addEdgeButton, removeEdgeButton, resetButton]
        
        let nodes = 1..<10
        let edges: [Graph.Edge] = [
            .init(nodes: [1,2], weight: 0.1),
            .init(nodes: [1,4], weight: 0.1),
            .init(nodes: [2,3], weight: 0.1),
            .init(nodes: [3,5], weight: 0.1),
            .init(nodes: [5,6], weight: 0.1),
            .init(nodes: [4,8], weight: 0.1),
            .init(nodes: [3,9], weight: 0.1),
            .init(nodes: [1,7], weight: 0.1),
            .init(nodes: [7,8], weight: 0.1),
        ]
        
        let graph = Graph(nodes: nodes, edges: edges)
        
        presenter = WeightedGraphPresenter(graph: Graph(nodes: [], edges: []), view: self.view)
        presenter.collisionDistance = 400
        presenter.delegate = self
        presenter.edgeColor = .yellow
        presenter.start()
        presenter.graph = graph
        presenter.backgroundColor = .black
        
        
    }
}

extension ThirdMISViewController {
    @objc func dothings() {
        bk = BK(self.presenter.graph)
        bk?.mis({ (misses) in
            self.misses.removeAll()
            self.misses.append(contentsOf: misses)
            self.presenter.graph.nodes.subtract(self.misses.first!)
            self.presenter.graph.nodes.formUnion(self.misses.first!)
        })
    }
    
    @objc func resetGraph() {
        if let setToSubtract = self.misses.first {
            self.misses.removeAll()
            self.presenter.graph.nodes.subtract(setToSubtract)
            self.presenter.graph.nodes.formUnion(setToSubtract)
        }
    }
    
    @objc func addVertex() {
        let controller = UIAlertController(title: "Add vertex", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "Vertex"
        }
        controller.addAction(.init(title: "Add", style: .cancel, handler: { (action) in
            if let fields = controller.textFields,
               let fieldText = fields[0].text,
               let vertex = Int(fieldText) {
                self.presenter.graph.nodes.insert(vertex)
            }
        }))
        present(controller, animated: true)
    }
    
    @objc func addEdge() {
        let controller = UIAlertController(title: "Add edge", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "Origin"
        }
        controller.addTextField { (textField) in
            textField.placeholder = "Finish"
        }
        controller.addAction(.init(title: "Add", style: .cancel, handler: { (action) in
            if let fields = controller.textFields,
               let originText = fields[0].text,
               let finishText = fields[1].text,
               let origin = Int(originText),
               let finish = Int(finishText) {
                let edge = Graph.Edge(nodes: [origin, finish], weight: 0.1)
                self.presenter.graph.edges.insert(edge)
            }
        }))
        present(controller, animated: true)
    }
    
    @objc func removeVertex() {
        let controller = UIAlertController(title: "Remove vertex", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "Vertex"
        }
        controller.addAction(.init(title: "Remove", style: .cancel, handler: { (action) in
            if let fields = controller.textFields,
               let fieldText = fields[0].text,
               let vertex = Int(fieldText) {
                self.presenter.graph.nodes.remove(vertex)
            }
        }))
        present(controller, animated: true)
    }
    
    @objc func removeEdge() {
        let controller = UIAlertController(title: "Remove edge", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "Origin"
        }
        controller.addTextField { (textField) in
            textField.placeholder = "Finish"
        }
        controller.addAction(.init(title: "Remove", style: .cancel, handler: { (action) in
            if let fields = controller.textFields,
               let originText = fields[0].text,
               let finishText = fields[1].text,
               let origin = Int(originText),
               let finish = Int(finishText) {
                let edge = Graph.Edge(nodes: [origin, finish], weight: 0.1)
                self.presenter.graph.edges.remove(edge)
            }
        }))
        present(controller, animated: true)
    }
}

extension ThirdMISViewController: WeightedGraphPresenterDelegate {
    func view(for node: Int, presenter: WeightedGraphPresenter) -> UIView {
        let view = UIView()
        let length = 40
        view.frame = CGRect(x: 0, y: 0, width: length, height: length)
        view.layer.cornerRadius = CGFloat(length / 2)
        let randomColor = UIColor(hue: CGFloat(node) / 20, saturation: 1, brightness: 1, alpha: 1).cgColor
        
        if let misses = self.misses.first, misses.contains(node) {
            view.layer.backgroundColor = UIColor.white.cgColor
        } else {
            view.layer.backgroundColor = randomColor
        }
        
        let label = UILabel(frame: view.frame)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "\(node)"
        view.addSubview(label)
        return view
    }
    
    func configure(view: UIView, for node: Int, presenter: WeightedGraphPresenter) {
        
    }
    
    func visibleRange(for node: Int, presenter: WeightedGraphPresenter) -> ClosedRange<Float>? {
        return nil
    }
}

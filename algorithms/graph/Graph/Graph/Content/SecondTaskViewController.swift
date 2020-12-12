//
//  ViewController.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 11.12.20.
//

import UIKit
import Graphite

class SecondTaskViewController: UIViewController {
    
    var settledVertices = Set<Int>()
    
    lazy var compl: (Int) -> () = { vertex in
        self.presenter.graph.removeNode(vertex)
        self.settledVertices.insert(vertex)
        self.presenter.graph.addNode(vertex)
    }

    var bfs: BFS?
    var bk: BK?
    
    var presenter: WeightedGraphPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIBarButtonItem(image: UIImage(systemName: "wand.and.stars"), style: .plain, target: self, action: #selector(showDialog))
        navigationItem.rightBarButtonItem = button
        
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(resetGraph))
        let addVertextButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addVertex))
        let addEdgeButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(addEdge))
        
        let removeVertexButton = UIBarButtonItem(image: UIImage(systemName: "minus.circle"), style: .plain, target: self, action: #selector(removeVertex))
        let removeEdgeButton = UIBarButtonItem(image: UIImage(systemName: "minus.square"), style: .plain, target: self, action: #selector(removeEdge))
        navigationItem.leftBarButtonItems = [addVertextButton, removeVertexButton, addEdgeButton, removeEdgeButton, resetButton]
        
        
        let nodes = 1..<14
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
        presenter.collisionDistance = 300
        presenter.delegate = self
        presenter.edgeColor = .yellow
        presenter.start()
        presenter.graph = graph
        presenter.backgroundColor = .black
    }
}

extension SecondTaskViewController {
    @objc func showDialog() {
        let controller = UIAlertController(title: "Choose vertices", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "Origin"
        }
        controller.addTextField { (textField) in
            textField.placeholder = "Finish"
        }
        controller.addAction(.init(title: "Find path", style: .cancel, handler: { (action) in
            if let fields = controller.textFields,
               let originText = fields[0].text,
               let finishText = fields[1].text,
               let origin = Int(originText),
               let finish = Int(finishText) {
                self.bfs = BFS(self.presenter.graph)
                self.bfs?.markCompletion = self.compl
                self.bfs?.bfs(start: origin, goal: finish, completion: { (isok) in
                    
                })
            }
        }))
        present(controller, animated: true)
    }
    
    @objc func resetGraph() {
        self.bfs = nil
        let copy = Set(self.settledVertices)
        copy.forEach { (vertex) in
            self.presenter.graph.removeNode(vertex)
            self.settledVertices.remove(vertex)
            self.presenter.graph.addNode(vertex)
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

extension SecondTaskViewController: WeightedGraphPresenterDelegate {
    func view(for node: Int, presenter: WeightedGraphPresenter) -> UIView {
        let view = UIView()
        let length = 30
        view.frame = CGRect(x: 0, y: 0, width: length, height: length)
        view.layer.cornerRadius = CGFloat(length / 2)
        let randomColor = UIColor(hue: CGFloat(node) / 100, saturation: 1, brightness: 1, alpha: 1).cgColor
        view.layer.backgroundColor = self.settledVertices.contains(node) ? UIColor.white.cgColor : randomColor
        
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

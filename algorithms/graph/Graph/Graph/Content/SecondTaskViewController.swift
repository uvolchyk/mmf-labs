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
        
        
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showDialog))
        navigationItem.rightBarButtonItem = button
        
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(resetGraph))
        navigationItem.leftBarButtonItem = resetButton
        
        let nodes = 1..<20
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

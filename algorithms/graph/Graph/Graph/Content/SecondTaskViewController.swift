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

class SecondTaskViewController: UIViewController {
    
    var flag = true
    
    var settledVertices = Set<Int>()
    
    lazy var compl: (Int) -> () = { vertex in
        self.presenter.graph.removeNode(vertex)
        self.settledVertices.insert(vertex)
        self.presenter.graph.addNode(vertex)
        
    }

    var bfs: BFS?
    var bk: BK?
    
    var presenter: WeightedGraphPresenter!
    
//    var nodes: [Int: (name: String, color: UIColor)] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nodes = 1..<10
//        let edges = (1..<20).map {
//            Graph.Edge(nodes: [$0, $0 + 1], weight: 0.1)
//        }
//        let edges = nodes.map {
////            Graph.Edge(nodes: [$0, Int(sqrt(Double($0)))], weight: 1)
//            Graph.Edge(nodes: [$0, Int.random(max: $0-1)], weight: 0.1)
////            Graph.Edge(nodes: [$0, $0 % 2], weight: 1)
//        }
        
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showDialog))
        navigationItem.rightBarButtonItem = button
        
        let resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(resetGraph))
        navigationItem.leftBarButtonItem = resetButton
        
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
//        let edges: [Graph.Edge] = (1..<10).map { a in
//            let b = max(min(100, Int.random(max: 8) - 4 + a), 0)
//            return Graph.Edge(nodes: [a, b], weight: 0.1)
//        }
        
        let graph = Graph(nodes: nodes, edges: edges)
        
        presenter = WeightedGraphPresenter(graph: Graph(nodes: [], edges: []), view: self.view)
        presenter.collisionDistance = 400
        presenter.delegate = self
        presenter.edgeColor = .yellow
        presenter.start()
        presenter.graph = graph
        presenter.backgroundColor = .black
        
        
        bk = BK(graph)
        
//        bk?.dothings()
//        bk?.clicques.forEach({ (set) in
//            print(set)
//        })
//
//        print("And biggest")
//        bk?.biggestMaximalCliques()
        bk?.mis()
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
        let length = 40
        view.frame = CGRect(x: 0, y: 0, width: length, height: length)
        view.layer.cornerRadius = CGFloat(length / 2)
        let randomColor = UIColor(hue: CGFloat(node) / 20, saturation: 1, brightness: 1, alpha: 1).cgColor
        view.layer.backgroundColor = self.settledVertices.contains(node) ? UIColor.white.cgColor : randomColor
        
        let label = UILabel(frame: view.frame)
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

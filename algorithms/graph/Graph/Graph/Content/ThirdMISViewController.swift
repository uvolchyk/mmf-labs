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
        navigationItem.leftBarButtonItem = resetButton
        
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
        
        bk = BK(graph)
    }
}

extension ThirdMISViewController {
    @objc func dothings() {
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

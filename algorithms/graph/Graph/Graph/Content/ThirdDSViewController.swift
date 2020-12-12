//
//  ThirdDSViewController.swift
//  Graph
//
//  Created by Uladzislau Volchyk on 12.12.20.
//

import UIKit
import Graphite

class ThirdDSViewController: UIViewController {

    var presenter: WeightedGraphPresenter!
    var bk: BK?
    var dks = Array<Set<Int>>()
    
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

extension ThirdDSViewController {
    @objc func dothings() {
        bk?.ds({ (dks) in
            var maxSize = 0
            dks.forEach({ maxSize = maxSize < $0.count ? $0.count : maxSize })
            let newDks = dks.filter({ $0.count == maxSize })
            self.dks.removeAll()
            self.dks.append(contentsOf: newDks)
            self.presenter.graph.nodes.subtract(self.dks.first!)
            self.presenter.graph.nodes.formUnion(self.dks.first!)
        })
    }
    
    @objc func resetGraph() {
    }
}

extension ThirdDSViewController: WeightedGraphPresenterDelegate {
    func view(for node: Int, presenter: WeightedGraphPresenter) -> UIView {
        let view = UIView()
        let length = 40
        view.frame = CGRect(x: 0, y: 0, width: length, height: length)
        view.layer.cornerRadius = CGFloat(length / 2)
        let randomColor = UIColor(hue: CGFloat(node) / 20, saturation: 1, brightness: 1, alpha: 1).cgColor
        
        if let dks = self.dks.first, dks.contains(node) {
            view.layer.backgroundColor = UIColor.white.cgColor
        } else {
            view.layer.backgroundColor = randomColor
        }
//        view.layer.backgroundColor = self.settledVertices.contains(node) ? UIColor.white.cgColor : randomColor
        
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

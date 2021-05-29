//
//  ViewController.swift
//
//  Project: NeedleSearch
// 
//  Author:  Uladzislau Volchyk
//  On:      05.05.2021
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import SwiftRichString

class RabinKarpViewController: UIViewController {
    @IBOutlet weak var searchField: UITextView!
    @IBOutlet weak var resultField: UITextView!
}

// MARK: - UIViewController overrides

extension RabinKarpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Private methods

private extension RabinKarpViewController {
    private func setupBindings() {
        searchField.reactive
            .continuousTextValues
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .map({ (self.resultField.text, $0) })
            .throttle(0.1, on: QueueScheduler.init(qos: .background, name: "lol", targeting: nil))
            .map({ (rabinSearch(text: $0.0, pattern: $0.1), $0.1) })
//            .map({ (self.rk.search($0.0, pattern: $0.1), $0.1) })
            .throttle(0.2, on: QueueScheduler.main)
            .observeValues { [self] indexes, token in
                
                let style = Style({
                    $0.backColor = UIColor.yellow
                    $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                })
                let attrString = AttributedString(string: resultField.text)
                indexes.forEach({ index in
                    _ = style.add(to: attrString, range: NSMakeRange(index, token.count))

                })
                
                _ = Style({ $0.font = UIFont.systemFont(ofSize: 18) }).add(to: attrString, range: NSMakeRange(0, attrString.length))
                resultField.attributedText = attrString
                
            }
    }
}


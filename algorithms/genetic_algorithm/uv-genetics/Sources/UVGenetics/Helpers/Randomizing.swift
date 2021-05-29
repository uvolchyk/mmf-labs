//
//  Randomizing.swift
//
//  Project: UVGenetics
// 
//  Author:  Uladzislau Volchyk
//  On:      03.04.2021
//

import Foundation

public extension Double {
    static func randomChance() -> Self {
        Double((0...100).randomElement() ?? 0) / 100
    }
}

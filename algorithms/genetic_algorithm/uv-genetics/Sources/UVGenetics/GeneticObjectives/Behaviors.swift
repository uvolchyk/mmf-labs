//
//  Behaviors.swift
//
//  Project: UVGenetics
// 
//  Author:  Uladzislau Volchyk
//  On:      03.04.2021
//


public protocol Mutable {
    func mutate(rate: Double, environment: GeneticEnvironment)
}

public protocol Crossoverable {
    func crossover(with mate: Self, environment: GeneticEnvironment) -> (Self, Self)
}

// MARK: -

public protocol Gen: Mutable {
    var allele: Int { get }
}

public protocol Genome: Mutable, Crossoverable {
    
}

// MARK: - Environment Globals

public enum MutationType {
    case byteFlip
    case randomFlip(ClosedRange<Int>)
}

public enum CrossoverType {
    case uniform(rate: Double)
}

public enum SelectionType {
    case fortune
}

public protocol GeneticEnvironmentConstants {
    var populationSize: Int { get }
    var mutationRate: Double { get }
    var crossoverRate: Double { get }
    var genomeSize: Int { get }
    var mutationType: MutationType { get }
    var crossoverType: CrossoverType { get }
    var selectionType: SelectionType { get }
}

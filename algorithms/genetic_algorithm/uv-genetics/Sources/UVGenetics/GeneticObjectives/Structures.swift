//
//  Structures.swift
//
//  Project: UVGenetics
// 
//  Author:  Uladzislau Volchyk
//  On:      03.04.2021
//


public struct GeneticEnvironment: GeneticEnvironmentConstants {
    public var populationSize: Int
    public var mutationRate: Double
    public var crossoverRate: Double
    public var genomeSize: Int
    public var mutationType: MutationType
    public var crossoverType: CrossoverType
    public var selectionType: SelectionType
    
    public init(population psize: Int,
                mutation mrate: Double,
                crossover crate: Double,
                genomeSize gsize: Int,
                mutationType mtype: MutationType,
                crossoverType ctype: CrossoverType,
                selectionType stype: SelectionType) {
        populationSize = psize
        mutationRate = mrate
        crossoverRate = crate
        genomeSize = gsize
        mutationType = mtype
        crossoverType = ctype
        selectionType = stype
    }
}

public final class ConcreteGen: Gen {
    
    public private(set) var allele: Int
    
    public init(_ allele: Int) {
        self.allele = allele
    }
    
    public func mutate(rate: Double, environment: GeneticEnvironment) {
        guard Double.randomChance() <= rate else { return }
        switch environment.mutationType {
        case .byteFlip:
            allele = allele == 0 ? 1 : 0
        case .randomFlip(let range):
            allele = range.randomElement() ?? allele
        }
    }
}

public final class ConcreteGenome: Genome, CustomStringConvertible {
    
    public var description: String { "\(genes.map({ $0.allele }))" }
    public var genes: [Gen]
    
    public init(genes: [Gen] = []) {
        self.genes = genes
    }
    
    public func mutate(rate: Double, environment: GeneticEnvironment) {
        guard Double.randomChance() < rate else { return }
        genes.forEach({ $0.mutate(rate: rate, environment: environment) })
    }
    
    public func crossover(with mate: ConcreteGenome, environment: GeneticEnvironment) -> (ConcreteGenome, ConcreteGenome) {
        let child1 = ConcreteGenome()
        let child2 = ConcreteGenome()
        
        switch environment.crossoverType {
        case .uniform(let rate):
            genes.enumerated().forEach { (i, element) in
                if Double.randomChance() <= rate {
                    child1.genes.append(mate.genes[i])
                    child2.genes.append(element)
                } else {
                    child2.genes.append(mate.genes[i])
                    child1.genes.append(element)
                }
            }
        }
        return (child1, child2)
    }
}

public final class Organism<G: Genome>: Comparable, CustomStringConvertible {
    
    public var description: String { "\(fitnessValue)" }
    
    public var genome: G
    public var initialGeneration: Int
    public var fitnessValue: Double
    
    public init(genome g: G, generation: Int, fitness: Double = 0.0) {
        genome = g
        initialGeneration = generation
        fitnessValue = fitness
    }
    
    public static func < (lhs: Organism<G>, rhs: Organism<G>) -> Bool { lhs.fitnessValue < rhs.fitnessValue }
    public static func == (lhs: Organism<G>, rhs: Organism<G>) -> Bool { lhs.fitnessValue == rhs.fitnessValue }
}

public final class Population<G: Genome> {
    
    public var totalFitness: Double = 0
    public let environment: GeneticEnvironment
    public var organisms: [Organism<G>]
    
    public init(env: GeneticEnvironment, organisms: [Organism<G>] = []) {
        environment = env
        self.organisms = organisms
    }
    
    public func epoch(fitnessCalc: ([Organism<G>]) -> ()) {
        organisms.sort()
        
        fitnessCalc(organisms)
        
        var newGeneration = [Organism<G>]()
        var parents = [Organism<G>]()
        switch environment.selectionType {
        case .fortune:
            parents = (0..<environment.populationSize / 2).compactMap({ (i) -> Organism<G>? in
                let slice = totalFitness > 0 ? Double.randomChance() * totalFitness : 0.0
                var cumulativeFitness = 0.0
                for organism in organisms {
                    cumulativeFitness += organism.fitnessValue
                    if cumulativeFitness >= slice {
                        return organism
                    }
                }
                return organisms.first
            })
        }
        
        let matings: [(Organism<G>, Organism<G>)] = (0..<parents.count / 2).map { (parents[$0*2], parents[$0*2+1]) }
        
        for (firstMate, secondMate) in matings {
            let genomeA = firstMate.genome
            let genomeB = secondMate.genome
            let (genomeChildA, genomeChildB) = genomeA.crossover(with: genomeB, environment: environment)
            newGeneration.append(Organism<G>(genome: genomeChildA, generation: 0, fitness: 0))
            newGeneration.append(Organism<G>(genome: genomeChildB, generation: 0, fitness: 0))
        }
        
        // MARK: - Mutation
        
        fitnessCalc(newGeneration)
        
        newGeneration.sort()
        newGeneration.reverse()
        
        newGeneration[0..<newGeneration.count / 2].forEach { (organism) in
            if Double.randomChance() < environment.mutationRate {
                organism.genome.mutate(rate: environment.mutationRate, environment: environment)
            }
        }
        
        fitnessCalc(newGeneration)
        newGeneration.sort()
        
        // MARK: - Replacement
        
        organisms.sort()
//        organisms.reverse()
        
        let replacement = newGeneration.sorted()[newGeneration.count..<newGeneration.count]
        organisms.replaceSubrange(0..<replacement.count, with: replacement)
        
        totalFitness = organisms.reduce(0, { $0 + $1.fitnessValue })
    }
}

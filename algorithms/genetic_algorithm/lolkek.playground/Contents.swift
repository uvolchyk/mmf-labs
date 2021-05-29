
let n = 2

Population()

//import Foundation
//
//public protocol Mutatable {
//    func mutate(_ rate: Double)
//}
//

//public protocol Crossoverable {
//    func crossover(with partner: Self, rate: Double) -> (Self, Self)
//}
//
//public protocol Gen: Mutatable {
//    
//}
//
//public protocol Genome: Mutatable, Crossoverable {
//    
//}
//
//public class RealGen: Gen {
//    public var allele: Int!
//    
//    public func mutate(_ rate: Double) {
//        guard Double((0..<10).randomElement()!) / 10 <= rate else { return }
//        allele = (-200...200).randomElement()!
//    }
//}
//
//public final class RealGenome: Genome {
//    
//    public var genes: [Gen] = []
//    
//    public func mutate(_ rate: Double) {
//        guard Double((0..<10).randomElement()!) / 10 < rate else { return }
//        genes.forEach({ $0.mutate(rate) })
//    }
//    
//    public func crossover(with partner: RealGenome, rate: Double = 0) -> (RealGenome, RealGenome) {
//        let child1 = RealGenome()
//        let child2 = RealGenome()
//        genes.enumerated().forEach { (enumer) in
//            let flip = (0...1).randomElement()!
//            if flip == 1 {
//                child2.genes.append(enumer.element)
//                child1.genes.append(partner.genes[enumer.offset])
//            } else {
//                child1.genes.append(enumer.element)
//                child2.genes.append(partner.genes[enumer.offset])
//            }
//        }
//        
//        return (child1, child2)
//    }
//    
//    public static func randomMember(gens count: Int) -> RealGenome {
//        let genome = RealGenome()
//        genome.genes = (0..<count).map({ (i) -> RealGen in
//            let gen = RealGen()
//            gen.mutate(1)
//            return gen
//        })
//        return genome
//    }
//    
//}
//
//public class Population<G: Genome> {
//    
//    public struct Constants {
//        static var populationSize: Int { 40 }
//        static var mutationRate: Double { 0.2 }
//        static var crossoverRate: Double { 0.4 }
//    }
//    
//    public var organisms: [Organism<G>] = []
//    public var totalFitness: Double!
//    
//    private var generation: Int = 0
//    
//    public func epoch() {
//        organisms.sort()
//        
//        var newOrganisms = [Organism<G>]()
//        
//        // Elites preselection
//        newOrganisms.append(contentsOf: organisms.suffix(4))
//        
//        let numberOfParents = (Constants.populationSize - newOrganisms.count) + ((Constants.populationSize - newOrganisms.count) % 2)
//        let parents = (0..<numberOfParents).map({ _ in rouletteOrganism() })
//        let matings: [(Organism<G>, Organism<G>)] = (0..<parents.count/2).map { (parents[$0*2], parents[$0*2+1]) }
//        
//        for mating in matings {
//            // Perform sampling.
//            let progenitorA = mating.0
//            let progenitorB = mating.1
//            // Perform crossover.
//            let (progenyGenomeA, progenyGenomeB) = progenitorA.genotype.crossover(with: progenitorB.genotype, rate: Constants.crossoverRate)
//            // Perform mutation.
//            progenyGenomeA.mutate(Constants.mutationRate)
//            progenyGenomeB.mutate(Constants.mutationRate)
//            // Add children to the population.
//            newOrganisms.append(Organism<G>(fitness: nil, genotype: progenyGenomeA, birthGeneration: generation))
//            newOrganisms.append(Organism<G>(fitness: nil, genotype: progenyGenomeB, birthGeneration: generation))
//        }
//        
//        organisms = newOrganisms
//        generation += 1
//    }
//    
//    private func rouletteOrganism() -> Organism<G> {
//        guard totalFitness != 0 else { return organisms.randomElement()! }
//        let slice = totalFitness > 0 ? (Double(arc4random()) / Double(UINT32_MAX)) * totalFitness : 0.0
//        var cumulativeFitness = 0.0
//        for organism in organisms {
//            cumulativeFitness += organism.fitness
//            if cumulativeFitness >= slice {
//                return organism
//            }
//        }
//        return organisms.first!
//    }
//    
////    private func updateFit
//}
//
//public class Organism<G: Genome>: Comparable {
//    public static func < (lhs: Organism<G>, rhs: Organism<G>) -> Bool { lhs.fitness < rhs.fitness }
//    
//    public static func == (lhs: Organism<G>, rhs: Organism<G>) -> Bool { lhs.fitness == rhs.fitness }
//    
//    
//    public var birthGeneration: Int
//    public var genotype: G
//    public var fitness: Double!
//    
//    public init(fitness: Double!, genotype: G, birthGeneration: Int) {
//        self.birthGeneration = birthGeneration
//        self.genotype = genotype
//        self.fitness = fitness
//    }
//}
//
//let population = Population<RealGenome>()
//population.organisms = (0..<40).map({ (i) -> Organism<RealGenome> in
//    Organism(fitness: nil, genotype: RealGenome.randomMember(gens: 5), birthGeneration: 0)
//})
//

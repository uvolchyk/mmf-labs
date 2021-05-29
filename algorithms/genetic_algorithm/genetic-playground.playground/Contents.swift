import UVGenetics
import Foundation

//let gen = ConcreteGen(123)
//
let environment = GeneticEnvironment(population: 20,
                                     mutation: 0.5,
                                     crossover: 0.8,
                                     genomeSize: 5,
                                     mutationType: .randomFlip(-200...200),
                                     crossoverType: .uniform(rate: 0.5),
                                     selectionType: .fortune)


let genome1 = ConcreteGenome()
let genome2 = ConcreteGenome()

(0..<environment.genomeSize)
    .forEach { (i) in
        genome1.genes.append(ConcreteGen((-200...200).randomElement()!))
        genome2.genes.append(ConcreteGen((-200...200).randomElement()!))
    }

let (gg1, gg2) = genome1.crossover(with: genome2, environment: environment)
gg1.description
gg2.description


genome1.description
genome2.description


let org1 = Organism<ConcreteGenome>(genome: genome1, generation: 0)
let org2 = Organism<ConcreteGenome>(genome: genome2, generation: 0)
//
//
let population = Population<ConcreteGenome>(env: environment, organisms: [org1, org2])

let grades: [[Double]] = [
    [0,2,1,2,1],
    [0,2,2,2,1],
    [2,1,1,0,0],
    [0,2,2,2,2],
    [0,0,0,1,1]
]

(0...5).forEach { (_) in
    
    population.epoch { (organisms) in
        organisms.forEach { (organism) in
            
            let alleles = organism.genome.genes.map({ $0.allele })
            
            let result = grades.reduce(0) { (result, row) -> Double in
                var member: Double = 1
                row.enumerated().forEach { (i, grade) in
                    member *= pow(Double(alleles[i]), grade)
                }
                return result + member
            }
            organism.fitnessValue = 1 / (result + 5)
        }
        print(organisms)
    }
}



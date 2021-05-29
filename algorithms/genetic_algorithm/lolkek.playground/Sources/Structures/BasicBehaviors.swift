public protocol Gen {
    
}

public protocol Genome {
    
}

public protocol GeneticEnvironment {
    var populationSize: Int { get }
    var mutationRate: Double { get }
    var conversionRate: Double { get }
}

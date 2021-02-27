import Foundation

struct Rule {
    let survive: Int
    let born: Int
    let fadingSteps: Int
}

fileprivate func makeRule(_ ruleString: String) -> Rule {
    let components = ruleString.components(separatedBy: "/")
    
    /**
     *
     * 0123
     *
     * 1 << 0 == 1
     * 1 << 1 == 2
     * 1 << 2 == 4
     * 1 << 3 == 8
     *
     * 1 + 2 + 4 + 8 == 15
     *
     * 0000000000001111 == 15
     */
    
    var survive = 0
    components[0].forEach({ survive += 1 << Int(String($0))! })
    
    var born = 0
    components[1].forEach({ born += 1 << Int(String($0))! })
    
    let numConditions = Int(components[2])!
    return Rule(survive: survive, born: born, fadingSteps: numConditions)
}

class CellularAutomata {
    let width, height: Int
    var rule: Rule
    var cells: [Int]
    var mode: Int = 1
    var seed: Int = 16
    
    init(width: Int, height: Int, ruleString: String) {
        self.width = width
        self.height = height
        self.rule = makeRule(ruleString)
        self.cells = Array(repeating: 0, count: width * height)
    }
    
    func setRule(_ ruleString: String) {
        rule = makeRule(ruleString)
    }
    
    func refresh() {
        for i in 0..<self.cells.count {
            cells[i] = 0
        }
    }
    
    func setup() {
        switch mode {
        case 0:
            self.cells[(height / 2) * width + width / 2] = self.rule.fadingSteps - 1
        default:
            for i in 0..<self.cells.count {
                self.cells[i] = Int(arc4random()) % seed == 0 ? rule.fadingSteps - 1 : 0
            }
        }
    }
    
    func tick() {
        var nextCells = Array(repeating: 0, count: width * height)
        let condMax = self.rule.fadingSteps - 1
        
        func index(_ x: Int, _ y: Int) -> Int {
            /**
             *
             *  ----
             *  ----
             *  -*--
             *  ----
             *
             *  '*' element has index of 10
             *  which is the 3rd row and 2nd column (pos - 1 for arrays)
             *  so.. 2 * 4 + 2 = 10
             */
            let adjustX = (x + self.width) % self.width
            let adjustY = (y + self.height) % self.height
            return adjustY * self.width + adjustX
        }
        
        for y in 0..<self.height {
            for x in 0..<self.width {
                // MARK: - Moore neighborhood
                                let indexes = [
                                    (x - 1, y - 1), (x, y - 1), (x + 1, y - 1),
                                    (x - 1, y    ),             (x + 1, y    ),
                                    (x - 1, y + 1), (x, y + 1), (x + 1, y + 1),
                                ]
                
                // MARK: - Von Neumann neighborhood
//                let indexes = [
//                    (x, y - 1),
//                    (x - 1, y   ),              (x + 1, y    ),
//                    (x, y + 1),
//                ]
                /**
                 * evaluating an amount of 'alive' cells
                 */
                let count = indexes.map{ self.cells[index($0.0, $0.1)] == condMax ? 1 : 0 }.reduce(0){ $0 + $1 }
                
                /**
                 * translating into a compliant form corresponding
                 * to the defined previously rule
                 */
                let env = count == 0 ? 0 : 1 << (count - 1)
                let idx = index(x, y)
                let prevCond = self.cells[idx]
                
                /**
                 the born rule is fulfilled
                 */
                if prevCond == 0 && (self.rule.born & env) > 0 ||
                    /**
                    the survival rule is fulfilled
                    */
                    prevCond == condMax && (self.rule.survive & env) > 0 {
                    nextCells[idx] = condMax
                } else {
                    /**
                     in other case a cell is fading away
                     */
                    if prevCond > 0 {
                                            nextCells[idx] = prevCond - 1
                                        }
//                    nextCells[idx] = prevCond > 0 ? prevCond - 1 : prevCond
                }
            }
        }
        self.cells = nextCells
    }
}

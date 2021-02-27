import UIKit

class CAView : UIView {
    let tileSize: CGFloat = 8.0
    var automaton: CellularAutomata?

    override func draw(_ rect: CGRect) {
        let ctx  = UIGraphicsGetCurrentContext()!
        let colorSpace = CGColorSpaceCreateDeviceCMYK()
        let horizontalTiles = ceil(self.bounds.size.width / tileSize)
        let verticalTiles = ceil(self.bounds.size.height / tileSize)
        if let automaton = automaton {
            let numConditions = automaton.rule.fadingSteps
            let cells = automaton.cells
            for y in 0..<Int(verticalTiles) {
                for x in 0..<Int(horizontalTiles) {
                    let condition = cells[Int(y * Int(horizontalTiles) + x)]
                    let magenta = 1.0 - (1.0 / CGFloat(numConditions - 1) * CGFloat(condition))
                    let components: [CGFloat] = condition == 0 ? [0.0, 0.0, 0.0, 1.0, 1.0] : [0.0, magenta, 1.0, 0.0, 1.0]
                    let color = CGColor(colorSpace: colorSpace, components: components)!

                    ctx.setFillColor(color)
                    ctx.fill(CGRect(x: x * Int(tileSize), y: y * Int(tileSize), width: Int(tileSize), height: Int(tileSize)))
                }
            }
        }

        
    }
}

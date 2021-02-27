import UIKit

@available(iOS 13.0, *)
class ViewController: UIViewController, ConfigViewDelegate {
    var timer: Timer?
    
    var ticks: Double = 0.1
    var seed: Double = 16
    var mode: Int = 0
    
    lazy var configController: UINavigationController = {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let controller: ConfigViewController = sb.instantiateViewController(identifier: "lolkek")
        controller.delegate = self
        return .init(rootViewController: controller)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w = Int(ceil(self.view.bounds.size.width / 8.0))
        let h = Int(ceil(self.view.bounds.size.height / 8.0))

        let caView = self.view as! CAView
        
        caView.automaton = CellularAutomata(width: w, height: h, ruleString: "23/12/5")
    }
    
    func setup(_ formula: String, _ ticks: Double, _ seed: Int, _ mode: Int) {
        let caView = self.view as! CAView
        caView.automaton?.setRule(formula)
        caView.automaton?.mode = mode
        caView.automaton?.seed = seed
        self.ticks = ticks
    }
    
    // MARK: - Private
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        let caView = self.view as! CAView
        caView.automaton?.refresh()
        tick()
    }
    
    @IBAction func configAction(_ sender: Any) {
        present(configController, animated: true, completion: nil)
    }
    
    
    @IBAction func stopAction(_ sender: Any) {
        self.timer?.invalidate()
    }
    
    @IBAction func fireAction(_ sender: Any) {
        if (self.timer?.isValid ?? false) {
            self.timer?.invalidate()
        }
        let caView = self.view as! CAView
        caView.automaton?.setup()
        self.timer = Timer.scheduledTimer(timeInterval: self.ticks, target: self,
                                          selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        let caView = self.view as! CAView
        DispatchQueue.global(qos: .background).async {
            caView.automaton!.tick()
            DispatchQueue.main.async {
                caView.setNeedsDisplay()
            }
        }
    }
}

import UIKit

protocol ConfigViewDelegate: class {
    func setup(_ formula: String, _ ticks: Double, _ seed: Int, _ mode: Int)
}

class ConfigViewController: UIViewController {
    
    weak var delegate: ConfigViewDelegate?
    
    @IBOutlet weak var automataFormulaField: UITextField!
    @IBOutlet weak var ticksAmountField: UITextField!
    @IBOutlet weak var seedField: UITextField!
    @IBOutlet weak var seedLabel: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.4) {
            self.seedField.alpha = CGFloat(sender.selectedSegmentIndex)
            self.seedLabel.alpha = CGFloat(sender.selectedSegmentIndex)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if let formula = automataFormulaField.text,
           let ticks = Double(ticksAmountField.text ?? "0") {
            delegate?.setup(formula, ticks, Int(seedField.text ?? "16") ?? 16, segmentControl.selectedSegmentIndex)
        }
        dismiss(animated: true, completion: nil)
    }
}

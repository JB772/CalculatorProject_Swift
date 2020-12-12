//
//  ViewController.swift
//  CalculatorProject_Swift
//
//  Created by 洪展彬 on 2020/12/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields.first?.text = "洪展彬"
        textFields[1].text = "Justin"
    }

    
    @IBAction func touchReturn(_ sender: Any) {
    }
    
    @IBAction func tapTouch(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func goToCalculator(_ sender: Any) {
        let calculatorVC = CalculatorViewController()
        self.navigationController?.pushViewController(calculatorVC, animated: true)
    }
}


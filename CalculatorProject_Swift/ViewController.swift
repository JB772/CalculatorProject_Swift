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

        let myName = textFields.first?.text ?? ""
        if myName.isEmpty {
            let alertController = UIAlertController(title: "請填入姓名", message: "欄位不可空白", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        let calculatorVC = CalculatorViewController()
        calculatorVC.authorName = myName
        self.navigationController?.pushViewController(calculatorVC, animated: true)
    }
}


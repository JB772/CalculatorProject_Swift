//
//  CalculatorViewController.swift
//  CalculatorProject_Swift
//
//  Created by 洪展彬 on 2020/12/9.
//

import UIKit

class CalculatorViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    
    var labelNumber: Double = 0
    var operateNumber: Double = 0
    var tempNumber: Double = 0
    var calculateCount: Int = 0
    var operationType: OperationType = .stopping
    var priorType: OperationType = .stopping
    var isOperating: Bool = false
    var isNewRecord: Bool = true
    var beforFormatLabelStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zeroResultLabel()
    }

    //數字 & 小數點
    @IBAction func numbers(_ sender: UIButton) {
        print("opearationNumber~########\(operateNumber)")
        let inputKey = sender.tag
        var resultText = resultLabel.text
        if resultText!.count >= 3 {
            if beforFormatLabelStr.hasSuffix(".") {
                print("檢查before尾有. :\(beforFormatLabelStr)")
                resultText = formatDoubleStr2String(resultText!) + "."
                beforFormatLabelStr = ""
            }else{
                resultText = formatDoubleStr2String(resultText!)
            }
        }
        //判斷是否要重來
        if isNewRecord {
            isNewRecord = false
            operateNumber = 0
            if inputKey != 10 {
                resultLabel.text = "\(inputKey)"
                resultText = "\(inputKey)"
            }else{
                resultLabel.text = "0."
                resultText = "0."
            }
        }else{
            priorType = operationType
            if resultText == "0" || resultText == "+" || resultText == "-" || resultText == "x" || resultText == "÷" {
                if inputKey != 10 {
//                    resultLabel.text = "\(inputKey)"
                    resultLabel.text = formatDouble2String(Double(inputKey))
                    resultText = "\(inputKey)"
                }else{
                    print("I'm here~~~~~")
                    resultLabel.text = "0."
                    resultText! += "0."
                }
            }else{
                if inputKey != 10 {
//                    resultLabel.text = resultText! + "\(inputKey)"
                    resultLabel.text = formatDouble2String(Double(resultText! + "\(inputKey)")!)
                    resultText! += "\(inputKey)"
                }else{
                    if !(resultText?.contains("."))! {
//                        resultLabel.text = resultText! + "."
                        resultLabel.text = formatDouble2String(Double(resultText!)!) + "."
                        resultText! += "."
                        
                    }
                }
            }
        }
//        resultLabel.text = resultText
        labelNumber = Double(resultText!) ?? 0
        beforFormatLabelStr = resultText!
        print("beforFormatLabelStr: \(beforFormatLabelStr)")
        print("\(labelNumber)")
    }
    
    //清除
    @IBAction func clearLabel(_ sender: Any) {
        zeroResultLabel()
    }
    
    //正負號
    @IBAction func positiveNegativeButton(_ sender: Any) {
        
        let resultText = resultLabel.text
        if resultText != "0" {
            if !(resultText!.contains("-")) {
                resultLabel.text = "-\(resultText!)"
            }else{
                resultLabel.text = resultText?.replacingOccurrences(of: "-", with: "")
            }
        }
        labelNumber = Double(resultLabel.text!) ?? 0
    }
    
    //乘階
    @IBAction func factorialClick(_ sender: Any) {
        
    }
    
    //運算按鈕
    @IBAction func calculationClick(_ sender: UIButton) {
        
        if calculateCount < 1 {
            operateNumber = labelNumber
            print("opearationNumber~###\(operateNumber)")
            print("labelNumber~###\(labelNumber)")
            print("\(calculateCount)")
        }else {
            tempNumber = calculating(operationType: priorType, operateNumber: operateNumber, labelNumber: labelNumber)
            print("opearationNumber~#\(operateNumber)")
            print("labelNumber~#\(labelNumber)")
            print("tempNumber~#\(tempNumber)")
            print("\(calculateCount)")
            operateNumber = tempNumber
        }

        switch sender.tag {
        case 0:
            print("+")
            resultLabel.text = "+"
            operationType = .addtion
            
        case 1:
            print("-")
            resultLabel.text = "-"
            operationType = .subtraction
        case 2:
            print("x")
            resultLabel.text = "x"
            operationType = .multiplication
        case 3:
            print("÷")
            resultLabel.text = "÷"
            operationType = .division
        default:
            operationType = .stopping
            return
        }
        
        isOperating = true
        isNewRecord = false
        calculateCount += 1

        
    }
    
    
    //等於
    @IBAction func answerClick(_ sender: Any) {
//        var answerNumber: Double = 0
        if isOperating {
            tempNumber = calculating(operationType: priorType, operateNumber: operateNumber, labelNumber: labelNumber)
            resultLabel.text = formatDouble2String(tempNumber)
            print("###operateNumberFinal###~\(operateNumber)")
            print("###labelNumberFinal###~\(labelNumber)")
            print("~~~~~~~~finalTempNumber\(tempNumber)")
            operateNumber = tempNumber
        }
        labelNumber = tempNumber
        isOperating = false
        isNewRecord = true
        calculateCount = 0
    }
    
    func calculating(operationType: OperationType, operateNumber: Double, labelNumber: Double) -> Double {
        var theAnswer: Double = 0
        switch operationType {
        case .addtion:
            theAnswer = operateNumber + labelNumber
        case .subtraction:
            theAnswer = (operateNumber - labelNumber)
        case .multiplication:
            theAnswer = (operateNumber * labelNumber)
        case .division:
            theAnswer = (operateNumber / labelNumber)
        case .stopping:
            print("operationType is stopping")
        }
        return theAnswer
    }
    
    //歸零
    func zeroResultLabel() {
        resultLabel.text = "0"
        labelNumber = 0
        operateNumber = 0
        operationType = .stopping
        priorType = .stopping
        isOperating = false
        isNewRecord = true
        calculateCount = 0
    }
    
    //格式化
    func formatDouble2String(_ number: Double) -> String {
        print("formatNumber\(number)")
        var tempText :String = ""
        let numberDouble = NSNumber(value: number)
        let myFormater = NumberFormatter()
        myFormater.positiveFormat = "#,##0.##############"
        
        if floor(number) == number {
            //整數處理
            tempText = myFormater.string(from: numberDouble)!
            if tempText.count >= 15 {
                print("超過15位數count~~\(tempText.count)~~tempText:\(tempText)")
                tempText = "超過運算範圍"
            }
        }else {
            //小數處理
            tempText = myFormater.string(from: numberDouble)!
            if tempText.count >= 15 {
                tempText = String(tempText.prefix(15))
            }
        }
        
//        resultLabel.text = tempText
        return tempText
    }
    
    //去千分位格式
    func formatDoubleStr2String(_ text: String) -> String {
        print("formatDoubleStr2String~~~Before: \(text)")
        var formatStr: String = ""
        let myFormatter = NumberFormatter()
        myFormatter.positiveFormat = "#,##0.##############"
//        formatDouble = strFormater.number(from: text) as! Double

        if let number = myFormatter.number(from: text) {
//            formatStr = "\(number.decimalValue)"
            formatStr = "\(number.doubleValue)"
        }
        
        if formatStr.hasSuffix(".0") {
            let range = formatStr.index(formatStr.endIndex, offsetBy: -2)..<formatStr.endIndex
            formatStr.removeSubrange(range)
        }
        
        print("formatDoubleStr2String~~~:formatStr~~~~~~~  \(formatStr)")
        return formatStr
    }
    
    
    
}

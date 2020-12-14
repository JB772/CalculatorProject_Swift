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
        
        //去千分符號
        if resultText!.count > 3 {
            resultText = formatDoubleStr2String(resultText!)
        }
        
        //檢查小數點
        if beforFormatLabelStr.contains(".") {
            if floor(labelNumber) == labelNumber {
                //先把小數點前的字串取出
                let beforePointStr = "\(Int(labelNumber))"
                print("beforPointStr~~~Line47: \(beforePointStr)")
                let beforePointCount = beforePointStr.count
                //小數點及之後字串
                let afterStrRange = beforFormatLabelStr.index(beforFormatLabelStr.startIndex, offsetBy: beforePointCount)..<beforFormatLabelStr.endIndex
                let afterStr = beforFormatLabelStr[afterStrRange]
                print("afterStr~~~~Line52: \(afterStr)")
                resultText = formatDoubleStr2String(resultText!) + afterStr
//                resultText = formatDoubleStr2String(resultText!) + "."
            } else if beforFormatLabelStr.hasSuffix("0") {
                resultText = formatDoubleStr2String(resultText!) + "0"
            }
        }
        
        beforFormatLabelStr = ""
        
        //判斷是否要重來
        if isNewRecord {
            isNewRecord = false
            operateNumber = 0
            if inputKey != 10 {
                resultLabel.text = "\(inputKey)"
                resultText = "\(inputKey)"
            }else{
                resultLabel.text = resultText! + "."
                resultText! += "."
            }
        }else{
            priorType = operationType
            if resultText == "0" || resultText == "+" || resultText == "-" || resultText == "x" || resultText == "÷" {
                if inputKey != 10 {
                    resultLabel.text = formatDouble2String(Double(inputKey))
                    resultText = "\(inputKey)"
                }else{
                    resultLabel.text = resultText! + "."
                    resultText! += "."
                }
            }else{
                if inputKey != 10 {
                    if resultText!.contains(".") {
                        //先把小數點前的字串取出
                        let beforePointStr = "\(Int(labelNumber))"
                        print("beforPointStr~~~Line88: \(beforePointStr)")
                        let beforePointCount = beforePointStr.count
                        //小數點及之後字串
                        let afterStrRange = resultText!.index(resultText!.startIndex, offsetBy: beforePointCount)..<resultText!.endIndex
                        let afterStr = resultText![afterStrRange]
                        print("afterStr~~~~Line93: \(afterStr)")
                        
                        resultLabel.text = changeLabelTextSize(formatDouble2String(Double(beforePointStr)!) + afterStr + "\(inputKey)")
                        
                    }else {
                        resultLabel.text = changeLabelTextSize(formatDouble2String(Double(resultText! + "\(inputKey)")!))
                    }
                    resultText! += "\(inputKey)"
                }else{
                    if !(resultText?.contains("."))! {
//                        resultLabel.text = resultText! + "."
                        resultLabel.text = changeLabelTextSize(formatDouble2String(Double(resultText!)!) + ".")
                        resultText! += "."
                        
                    }
                }
            }
        }
        labelNumber = Double(resultText!) ?? 0
        beforFormatLabelStr = resultText!
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
        operateNumber = labelNumber
    }
    
    //乘階
    @IBAction func factorialClick(_ sender: Any) {
        var factoriaNumber: Double = 1
        //判斷是否為正整數
        if floor(labelNumber) == labelNumber && labelNumber >= 0 && labelNumber <= 20 {
            if labelNumber == 0 {
                factoriaNumber = 0
            }else {
                for i in stride(from: labelNumber, to: 0, by: -1) {
                    factoriaNumber = factoriaNumber * i
                }
            }
            zeroResultLabel()
            labelNumber = factoriaNumber
            resultLabel.text = changeLabelTextSize(formatDouble2String(factoriaNumber))
        }else if labelNumber > 20 {
            useAlert(title: "超過運算範圍", message: "此功能只能運算小於20的數。")
        } else {
            useAlert(title: "該數值無法運算", message: "請輸入一個正整數。")
        }
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
            print("tempNumber: \(formatDouble2String(tempNumber))")
            resultLabel.text = changeLabelTextSize(formatDouble2String(tempNumber))
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
            if labelNumber != 0 {
                theAnswer = (operateNumber / labelNumber)
            }else {
                useAlert(title: "該數值無法運算", message: "除數不以為0喔！！")
                break
            }
        case .stopping:
            print("operationType is stopping")
            self.zeroResultLabel()
        }
        return theAnswer
    }
    
    //歸零
    func zeroResultLabel() {
        resultLabel.text = changeLabelTextSize("0")
        labelNumber = 0
        operateNumber = 0
        operationType = .stopping
        priorType = .stopping
        isOperating = false
        isNewRecord = true
        calculateCount = 0
        
    }
    
    //動態改label textSize
    func changeLabelTextSize(_ textString: String)-> String {
        let textStr = textString
        var labelTextSize: CGFloat = 10
        switch textStr.count {
        case 0..<9:
            labelTextSize = 60
        case 9..<18:
            labelTextSize = 40
        case 18..<26:
            labelTextSize = 30
        default:
            useAlert(title: "超過運算範圍", message: "您輸入的位數太多了，請輸入小一點的數。")
        }
        resultLabel.font = UIFont.systemFont(ofSize: labelTextSize)
        
        return textStr
    }
    
    //格式化
    func formatDouble2String(_ number: Double) -> String {
        print("formatNumber\(number)")
        var tempText :String = ""
        var pointNumberStr: String = ""
        let myFormater = NumberFormatter()
        myFormater.positiveFormat = "#,##0.###############"
        
        
        //整數字串
        let integerOfNumber: Double = floor(number)
//        let integerOfNumberStr = String(Int(integerOfNumber))
        let integerOfNumberStr = myFormater.string(from: NSNumber(value: Int(integerOfNumber))) ?? "0"
        print("integerOfNumberStr: \(integerOfNumberStr)")
        
        //小數位數處理 -> 字串
        if floor(number) != number {
            let currentStr = myFormater.string(from: NSNumber(value: number)) ?? "0"
            pointNumberStr = currentStr.replacingOccurrences(of: integerOfNumberStr, with: "0")
            pointNumberStr.remove(at: pointNumberStr.startIndex)
            print("RemoveStarIndexPointNumberStr: \(pointNumberStr)")
            if pointNumberStr.count >= 17 {
                pointNumberStr = String(pointNumberStr.prefix(16))
            }
        }
        
        tempText = integerOfNumberStr + pointNumberStr
        print("tempText: \(tempText)")
        
        return tempText
    }
    
    //去千分位格式
    func formatDoubleStr2String(_ text: String) -> String {
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
        return formatStr
    }
    
    func useAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (actionOk) in
            self.zeroResultLabel()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

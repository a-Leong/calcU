//
//  ViewController.swift
//  Calculator
//
//  Created by Alex Leong on 10/12/18.

import UIKit

class ViewController: UIViewController {
    
    enum operation {
        case multiply
        case divide
        case subtract
        case add
        case evaluate
    }
    
    @IBOutlet weak var output: UILabel!
    
    var outputText : String = ""
    
    var previousValue : Double = 0
    var currentValue : Double = 0
    var result : Double = 0
    var curOp : operation = .evaluate
    var notDecimalValue : Bool = true
    var operatorSelected : Bool = false
    var hasError : Bool = false
    var inputChanged : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        output.text = "0"
    }

    @IBAction func numberButtonPressed(_ sender: Any) {
        // add digit to input
        if !hasError {
            
            inputChanged = true
            
            let input = (sender as AnyObject).tag ?? -1 // digit pressed
            
            if input > 0 && input < 12 && outputText.count < 13 {
                let input = String((sender as AnyObject).tag)
                if input.count == 1 {
                    outputText += input
                } else if input == "11" && notDecimalValue {
                    if outputText == "" {
                        outputText += "0."
                    } else {
                        outputText += "."
                    }
                    notDecimalValue = false
                } else if input == "10" && (Double(outputText) != 0 || !notDecimalValue) {
                    outputText += "0"
                }
                output.text = outputText
                if outputText == "." {
                    currentValue = 0.0
                } else {
                    currentValue = Double(outputText)!
                }
            }
        }
    }
    
    @IBAction func inputModPressed(_ sender: Any) {
        
        let input = (sender as AnyObject).tag ?? -1
        
        // clear
        if input == 1 {
            output.text = "0"
            outputText = ""
            currentValue = 0.0
            previousValue = 0.0
            result = 0.0
            curOp = .evaluate
            hasError = false
            notDecimalValue = true
            inputChanged = false
        }
        
        // negate
        if !hasError {
            if input == 2 {
                if inputChanged {
                    
                    // remove negative
                    if currentValue < 0 {
                        output.text?.removeFirst()
                        outputText.removeFirst()
                        currentValue = currentValue * -1.0
                        
                    // add negative
                    } else if currentValue > 0 {
                        output.text = "-" + output.text!
                        outputText = "-" + outputText
                        currentValue = currentValue * -1.0
                    }
                }
                
            // percentage
            } else if input == 3 {
                if inputChanged {
                    currentValue = currentValue * 0.01
                    output.text = formatNum(num: currentValue)
                    outputText = formatNum(num: currentValue)
                    
                }
            }
        }
    }
    
    @IBAction func operatorButtonPressed(_ sender: Any) {
        if !hasError {
            
            let input = (sender as AnyObject).tag ?? -1
            
            outputText = ""
            notDecimalValue = true
            
            // evaluate if user strings together operations
            if curOp != .evaluate && input != 5 && inputChanged {
                evalPresentResult(op: curOp)
            }
            
            // division
            if input == 1 {
                curOp = .divide
                previousValue = currentValue
                inputChanged = false
            
            // multiplication
            } else if input == 2 {
                curOp = .multiply
                previousValue = currentValue
                inputChanged = false
                
            // subtraction
            } else if input == 3 {
                curOp = .subtract
                previousValue = currentValue
                inputChanged = false
            
            // addition
            } else if input == 4 {
                curOp = .add
                previousValue = currentValue
                inputChanged = false
                
            // equal
            } else if input == 5 {
                if curOp == .evaluate {
                    result = currentValue
                }
                evalPresentResult(op: curOp)
                curOp = .evaluate
                inputChanged = true
            }
        }
    }
    
    func evalPresentResult(op : operation) {
        if inputChanged {
            if op == .divide {
                result = divide(a : previousValue, b : currentValue)
            } else if op == .multiply {
                result = previousValue * currentValue
            } else if op == .subtract {
                result = previousValue - currentValue
            } else if op == .add {
                result = previousValue + currentValue
            }
            
            previousValue = currentValue
            currentValue = result

            if !hasError {
                output.text = formatNum(num: result)
                outputText = ""
            }
        }
        
    }
    
    func formatNum(num : Double) -> String {
        // truncate screen output if too long (formatted to iPhone 7 dimensions)
        if String(num).count > 16 {
            return String(format: "%g", num)
            
        // remove zero decimal remainder
        } else if num.truncatingRemainder(dividingBy: 1) == 0 {
            return String(String(num).dropLast(2))
        
        // output is appropriate as is
        } else {
            return String(num)
        }
    }
    
    func divide(a : Double, b : Double) -> Double {
        if b == 0.0 {
            output.text = "Error"
            hasError = true
            return 0.0
        } else {
            return a / b
        }
    }
}


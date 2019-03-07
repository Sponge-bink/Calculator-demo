//
//  ViewController.swift
//  Calculator
//
//  Created by spongebink on 2019/1/2.
//  Copyright © 2019 spongebink. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        display.text = "0"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func switchOnTitles(buttonCurrentTitle: String) -> String? {
        switch buttonCurrentTitle {
        case "+": return "Plus"
        case "−": return "Minus"
        case "×": return "Multiply"
        case "÷": return "Divide"
        default: return nil
        }
    }
    // geting names of operations for every button current tiltes for funcs
    
    
    func addComma(for numberInString: String, isInt: Bool) -> String {
        var stringToReturn = numberInString
        if isInt, Int(numberInString)!.commaIndex != nil {
            for indexes in Int(numberInString)!.commaIndex!.reversed() {
                stringToReturn.insert(",", at: stringToReturn.index(stringToReturn.startIndex, offsetBy: indexes))
            }
        } else {
            if let indexOfTheDecimalPoint = numberInString.index(of: ".") {
                let theDecimalPointAndStringAfterIt: String.SubSequence? = numberInString[indexOfTheDecimalPoint...]
                return addComma(for: String(Int(Double(numberInString)!)), isInt: true) + String(theDecimalPointAndStringAfterIt!)
            }
        }
        return stringToReturn
    }
    // comments wanted for this func
    
    var stringOnScreen: String? = "0" {
        didSet {
            if isResult, numberOnScreen == Double(Int(numberOnScreen)) {
                display.text = addComma(for: String(Int(numberOnScreen)), isInt: true)
                // Int results stored in a double will be converted to Int and displayed on screen
            }
            else if isResult {
                display.text = addComma(for: stringOnScreen!, isInt: false)
                // Double results will be displayed directly
            }
            else if isDouble {
                display.text = addComma(for: stringOnScreen!, isInt: false)
                // User inputing double, display directly
            } else {
                display.text = addComma(for: String(Int(numberOnScreen)), isInt: true)
                // Use inputing Ints, convert them
            }
            // really messy around here…
        }
    }
    
    var numberOnScreen: Double = 0.0 {
        didSet {
            if !numberOnScreen.isInfinite && !numberOnScreen.isNaN {
                stringOnScreen = String(numberOnScreen)
            } else {
                clear()
                display.text = "Error"
            }
        }
    }
    
    var previousNumberOrResult: Double?
    
    var isResult: Bool = true
    
    var isCalculating: Bool = false
    
    var isDouble: Bool = false
    
    var isRightAfterDecimalPoint = false {
        didSet {
            if isRightAfterDecimalPoint {
                display.text = display.text! + "."
            }
        }
    }
    
    var operation: String?
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func numberButtons(_ sender: UIButton) {
        isCalculating = false
        if isResult,!isDouble {
            isResult = false
            numberOnScreen = Double(sender.currentTitle!)!
        } else if isResult, isDouble {
            isResult = false
            numberOnScreen = 0.0 + Double(sender.currentTitle!)! / 10
        } else if !isResult, isDouble {
            if isRightAfterDecimalPoint {
                numberOnScreen = numberOnScreen + Double(sender.currentTitle!)! / 10
                isRightAfterDecimalPoint = false
            } else {
                stringOnScreen = stringOnScreen! + sender.currentTitle!
            }
        } else if !isResult, !isDouble {
            numberOnScreen = Double(String(Int(numberOnScreen)) + sender.currentTitle!)!
        }
    }
    
    @IBAction func fundamentalOperationButtons(_ sender: UIButton) {
        if !isResult, isDouble {
            numberOnScreen = Double(stringOnScreen!)!
        }
        // inputing double will be handled by adding directly to stringOnString, and this is to end with fundamentalOperationButtons or equals etc

        var newOperation: String = ""
        
        if !isCalculating {
            // no need to do operation correction
            newOperation = switchOnTitles(buttonCurrentTitle: sender.currentTitle!)!
            if operation != nil {
                // not the first operation in a equation, do math with the old operation
                if operation! == "Multiply" {
                    numberOnScreen = previousNumberOrResult! * numberOnScreen
                } else if operation! == "Minus" {
                    numberOnScreen = previousNumberOrResult! - numberOnScreen
                } else if operation! == "Plus" {
                    numberOnScreen = previousNumberOrResult! + numberOnScreen
                } else if operation! == "Divide" {
                    numberOnScreen = previousNumberOrResult! / numberOnScreen
                }
            }
            isResult = true
            isCalculating = true
            previousNumberOrResult = numberOnScreen
            isDouble = false
            isRightAfterDecimalPoint = false
            operation = newOperation
            // record the newly pressed button to be used next time. used in long equations
        } else {
            // fundamentalOperationButtons pushed when isCalculating == true. operation correction, by pressing the correct button right after the wrong one
            operation = switchOnTitles(buttonCurrentTitle: sender.currentTitle!)!
        }
    }
    
    @IBAction func clear() {
        isResult = true
        previousNumberOrResult = nil
        numberOnScreen = 0.0
        isCalculating = false
        isDouble = false
        isRightAfterDecimalPoint = false
        operation = nil
    }
    
    @IBAction func equals(_ sender: UIButton) {
        if !isResult, isDouble {
            numberOnScreen = Double(stringOnScreen!)!
        }
        // inputing double will be handled by adding directly to stringOnString, and this is to end with fundamentalOperationButtons or equals etc
        isResult = true
        if operation != nil {
            if operation! == "Multiply" {
                numberOnScreen = previousNumberOrResult! * numberOnScreen
            } else if operation! == "Plus" {
                numberOnScreen = previousNumberOrResult! + numberOnScreen
            } else if operation! == "Divide" {
                numberOnScreen = previousNumberOrResult! / numberOnScreen
            } else if operation! == "Minus" {
                numberOnScreen = previousNumberOrResult! - numberOnScreen
            }
            previousNumberOrResult = numberOnScreen
        } else {
            // something supposed to be done here?
        }
        operation = nil
        isDouble = false
    }
    
    @IBAction func decimalPoint(_ sender: UIButton) {
        if isResult || (!isResult && !isDouble) {
            // is it  the first time decimalPoint is pressed while inputing a double, if not, ignore
            if isCalculating {
                numberOnScreen = 0.0 // Is this OK?
                // input doubles which absolute values are less than 1, so no need to press 0 before
            }
            isCalculating = false
            isDouble = true
            isRightAfterDecimalPoint = true
            isResult = false
        }
        // something supposed to be done here?
    }
    @IBAction func minusOrNot(_ sender: UIButton) {
        if !isResult && !isCalculating && !isRightAfterDecimalPoint {
            if isDouble {
                numberOnScreen = Double(stringOnScreen!)!
            }
            // inputing double will be handled by adding directly to stringOnString, and this is to end with fundamentalOperationButtons or equals etc
            numberOnScreen = -numberOnScreen
        }
    }
}

extension Int {
    var commaIndex: [Int]? {
        if String(self).count < 4 {
            return nil
        } else {
            return Array(stride(from: String(self).count - 3, to: 0, by: -3)).reversed()
        }
    }
}

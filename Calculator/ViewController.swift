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
    
    var stringOnScreen: String? = "0" {
        didSet {
            if isResult, numberOnScreen == Double(Int(numberOnScreen)) {
                display.text = String(Int(numberOnScreen))
                // Int results stored in a double will be converted to Int and displayed on screen
            }
            else if isResult {
                display.text = stringOnScreen
                // Double results will be displayed directly
            }
            else if isDouble {
                display.text = stringOnScreen
                // User inputing double, display directly
            } else {
                display.text = String(Int(numberOnScreen))
                // Use inputing Ints, convert them
            }
            // really messy around here…
        }
    }
    
    var numberOnScreen: Double = 0.0 {
        didSet {
            stringOnScreen = String(numberOnScreen)
        }
    }
    
    var previousNumberOrResult: Double?
    
    var isResult: Bool = true
    
    var isCalculating: Bool = false
    
    var isDouble: Bool = false
    
    var isRightAfterDecimalPoint = false
    
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
        var newOperation: String = ""
        
        if !isCalculating {
            switch sender.currentTitle {
                case "×": newOperation = "Multiply"
                case "−": newOperation = "Minus"
                case "+": newOperation = "Plus"
                case "÷": newOperation = "Divide"
                default: break
            }
            if operation != nil {
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
        } else {
            switch sender.currentTitle {
                case "×": operation = "Multiply"
                case "−": operation = "Minus"
                case "+": operation = "Plus"
                case "÷": operation = "Divide"
                default: break
            }
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
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
            if isCalculating {
                numberOnScreen = 0.0 // Is this OK?
            }
            isCalculating = false
            isDouble = true
            isRightAfterDecimalPoint = true
            isResult = false
        }
        // something supposed to be done here?
    }
//    @IBAction func minusOrNot(_ sender: UIButton) {
//        numberOnScreen = -numberOnScreen
//    }
}


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
            }
                //            else if isDouble, isRightAfterPoint {
                //                display.text = stringOnScreen! + "."
                //            }
            else if isResult {
                display.text = stringOnScreen
            }
            else if isDouble {
                display.text = stringOnScreen
            } else {
                display.text = String(Int(numberOnScreen))
            }
            // really messy around here…
        }
    }
    
    //test message
    
    var numberOnScreen: Double = 0.0 {
        didSet {
            stringOnScreen = String(numberOnScreen)
        }
    }
    
    var previousNumberOrResult: Double?
    
    var isResult: Bool = true
    
    var isCalculating: Bool = false
    
    var isDouble: Bool = false
    
    var isRightAfterPoint = false
    
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
            if isRightAfterPoint {
                numberOnScreen = numberOnScreen + Double(sender.currentTitle!)! / 10
                isRightAfterPoint = false
            } else {
                numberOnScreen = Double(String(numberOnScreen) + sender.currentTitle!)!
            }
        } else if !isResult, !isDouble {
            numberOnScreen = Double(String(Int(numberOnScreen)) + sender.currentTitle!)!
        }
    }
    
    @IBAction func fundamentalOperationButtons(_ sender: UIButton) {
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
            isCalculating = true
            previousNumberOrResult = numberOnScreen
            isResult = true
            isDouble = false
            isRightAfterPoint = false
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
        isRightAfterPoint = false
        operation = nil
    }
    
    @IBAction func equals(_ sender: UIButton) {
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
            isRightAfterPoint = true
            isResult = false
        }
        // something supposed to be done here?
    }
//    @IBAction func minusOrNot(_ sender: UIButton) {
//        numberOnScreen = -numberOnScreen
//    }
}


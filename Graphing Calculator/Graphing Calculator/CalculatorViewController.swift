//
//  ViewController.swift
//  Calculator
//
//  Created by Sebastian Osiński on 11.04.2015.
//  Copyright (c) 2015 Sebastian Osinski. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var graphButton: UIButton!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var changeSignButton: UIButton!
    var userIsInTheMiddleOfTypingANumber: Bool = false
    let brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
                return number
            }
            return nil
        }
        set {
            display.text = newValue.map { $0.description } ?? " "
            
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphButton.enabled = false
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." && display.text!.rangeOfString(".") != nil {
                return
            }
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
            history.text = "\(brain)" + " ="
        }
        graphButton.enabled = brain.isProgramValid()
    }
    
    @IBAction func clear() {
        display.text = " "
        history.text = " "
        brain.clearOperationStack()
        brain.clearVariables()
        
        userIsInTheMiddleOfTypingANumber = false
        graphButton.enabled = false
    }
    
    @IBAction func undo() {
        if (display.text!).characters.count > 1 {
            display.text = String(display.text!.characters.dropLast())
        }else{
            display.text = " "
        }
    }
    
    @IBAction func changeSign() {
        if userIsInTheMiddleOfTypingANumber {
            if Array((display.text!).characters)[0] == "-" {
                display.text = String(display.text!.characters.dropFirst())
            }else {
                display.text = "-" + display.text!
            }
        }else {
            operate(changeSignButton)
        }
        graphButton.enabled = brain.isProgramValid()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let value = displayValue {
            if let result = brain.pushOperand(value) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        history.text = "\(brain)" + " ="
        graphButton.enabled = brain.isProgramValid()
    }

    @IBAction func setMemory() {
        if displayValue != nil {
            brain.variableValues["M"] = displayValue!
        }
        displayValue = brain.evaluate()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func getMemory() {
        enter()
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
        history.text = "\(brain)" + " ="
    }
    
    @IBAction func graph() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(brain.program, forKey: "CalculatorBrain.program")
        
        performSegueWithIdentifier("Show Graph", sender: nil)
    }
}


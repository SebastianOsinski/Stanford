//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sebastian Osiński on 16.04.2015.
//  Copyright (c) 2015 Sebastian Osinski. All rights reserved.
//

import Foundation

class CalculatorBrain: CustomStringConvertible {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double, Int)
        case Constant(String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let name):
                    return name
                }
            }
        }
        
        var precedence: Int {
            switch self {
            case .Operand, .Variable, .Constant, .UnaryOperation:
                return Int.max
            case .BinaryOperation(_, _, let precedence):
                return precedence
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String : Op]()
    var variableValues = [String : Double]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *, 2))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}, 2))
        learnOp(Op.BinaryOperation("+", +,1))
        learnOp(Op.BinaryOperation("−", {$1 - $0}, 1))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π", M_PI))
        learnOp(Op.UnaryOperation("±"){-$0})
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? [String] {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.Variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    var description: String {
        get {
            var remainingOps = opStack
            var desc = ""
            var temp: String?
            while !remainingOps.isEmpty {
                (temp, remainingOps, _) = descriptionHelper(remainingOps)
                desc = (temp ?? "")  + ", " + desc
            }
            
            if desc != "" {
                desc = desc.substringToIndex(desc.startIndex.advancedBy(desc.characters.count - 2))
            }
            
            return desc
        }
    }
    
    private func descriptionHelper(ops: [Op]) -> (result: String?, remainingOps: [Op], precedence: Int) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand, .Constant, .Variable:
                return ("\(op)", remainingOps, op.precedence)
            case .UnaryOperation:
                let operandEvaluation = descriptionHelper(remainingOps)
                let operand = operandEvaluation.result ?? "?"
                return ("\(op)(" + operand + ")", operandEvaluation.remainingOps, op.precedence)
            case .BinaryOperation:
                let op1Evaluation = descriptionHelper(remainingOps)
                let operand1 = op1Evaluation.result ?? "?"
                let op2Evaluation = descriptionHelper(op1Evaluation.remainingOps)
                let operand2 = op2Evaluation.result ?? "?"
                
                let left = op2Evaluation.precedence < op.precedence ? "(" + operand2 + ")" : operand2
                let right = op1Evaluation.precedence < op.precedence ? "(" + operand1 + ")" : operand1
                
                return(left + "\(op)" + right , op2Evaluation.remainingOps, op.precedence)
            }
        }
        
        return (nil, ops, Int.max)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation, _):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let operation):
                return (operation, remainingOps)
            case .Variable(let name):
                if let value = variableValues[name] {
                    return (value, remainingOps)
                }
                return (nil, ops)
            }
        }
    
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        //print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearOperationStack() {
        opStack = [Op]()
    }
    
    func clearVariables() {
        variableValues.removeAll()
    }
    
    func history() -> String {
        return opStack.map {"\($0)"}.joinWithSeparator(" ")
    }
    
}
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
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let name):
                    return name
                }
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
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷"){$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π", M_PI))
        learnOp(Op.UnaryOperation("±"){-$0})
    }
    
    var description: String {
        get {
            var remainingOps = opStack
            var desc = ""
            var temp: String?
            while !remainingOps.isEmpty {
                (temp, remainingOps) = descriptionHelper(remainingOps)
                desc = (temp ?? "")  + ", " + desc
            }
            
            if desc != "" {
                desc = desc.substringToIndex(advance(desc.startIndex, desc.characters.count - 2))
                desc += " ="
            }
            

            return desc
        }
    }
    
    private func descriptionHelper(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand:
                return ("\(op)", remainingOps)
            case .UnaryOperation:
                let operandEvaluation = descriptionHelper(remainingOps)
                let operand = operandEvaluation.result ?? "?"
                return ("\(op)(" + (operand) + ")", operandEvaluation.remainingOps)
            case .BinaryOperation:
                let op1Evaluation = descriptionHelper(remainingOps)
                let operand1 = op1Evaluation.result ?? "?"
                let op2Evaluation = descriptionHelper(op1Evaluation.remainingOps)
                let operand2 = op2Evaluation.result ?? "?"
                return ("(" + operand2 + "\(op)" + operand1 + ")", op2Evaluation.remainingOps)
            case .Constant:
                return ("\(op)", remainingOps)
            case .Variable:
                return ("\(op)", remainingOps)
            }
        }
        
        return (nil, ops)
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
            case .BinaryOperation(_, let operation):
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
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
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
        return " ".join(opStack.map {"\($0)"})
    }
    
}
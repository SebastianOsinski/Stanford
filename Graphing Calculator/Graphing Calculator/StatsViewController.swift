//
//  StatsViewController.swift
//  Graphing Calculator
//
//  Created by Sebastian Osiński on 22.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet private weak var minLabel: UILabel! {
        didSet {
            minLabel.text = "Local minimum value: \(round(minValue * 1000) / 1000.0)"
        }
    }
    @IBOutlet private weak var maxLabel: UILabel! {
        didSet {
            maxLabel.text = "Local minimum value: \(round(maxValue * 1000) / 1000.0)"
        }
    }
    
    var minValue: Double = 0 {
        didSet {
            minLabel?.text = "Local minimum value: \(round(minValue * 1000) / 1000.0)"
        }
    }
    
    var maxValue: Double = 0 {
        didSet {
            maxLabel?.text = "Local minimum value: \(round(maxValue * 1000) / 1000.0)"
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            if minLabel != nil && maxLabel != nil && presentingViewController != nil {
                let height = minLabel.bounds.size.height + maxLabel.bounds.size.height + 10
                let width = minLabel.bounds.size.width
                return CGSize(width: width, height: height)
            } else {
                return super.preferredContentSize
            }
        }
        set {
            super.preferredContentSize = newValue
        }
    }


}

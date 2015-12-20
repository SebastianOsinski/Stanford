//
//  SettingsViewController.swift
//  Breakout
//
//  Created by Sebastian Osiński on 20.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var numberOfRowsLabel: UILabel!
    @IBOutlet weak var bricksPerRowLabel: UILabel!
    @IBOutlet weak var paddleWidthLabel: UILabel!
    
    @IBOutlet weak var numberOfRowsStepper: UIStepper!
    @IBOutlet weak var bricksPerRowStepper: UIStepper!
    @IBOutlet weak var paddleWidthStepper: UIStepper!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let numberOfRows = defaults.integerForKey(SettingsConstants.NumberOfRows)
        numberOfRowsLabel.text = "Number of rows: \(numberOfRows)"
        numberOfRowsStepper.minimumValue = 2
        numberOfRowsStepper.maximumValue = 10
        numberOfRowsStepper.value = Double(numberOfRows)
        
        let bricksPerRow = defaults.integerForKey(SettingsConstants.BricksPerRow)
        bricksPerRowLabel.text = "Bricks per row: \(bricksPerRow)"
        bricksPerRowStepper.minimumValue = 2
        bricksPerRowStepper.maximumValue = 10
        bricksPerRowStepper.value = Double(bricksPerRow)
        
        let paddleWidth = defaults.doubleForKey(SettingsConstants.PaddleWidth)
        paddleWidthLabel.text = "Paddle width: \(paddleWidth)"
        paddleWidthStepper.minimumValue = 0.1
        paddleWidthStepper.maximumValue = 0.6
        paddleWidthStepper.value = paddleWidth
        paddleWidthStepper.stepValue = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberOfRowsChanged(sender: UIStepper) {
        defaults.setInteger(Int(sender.value), forKey: SettingsConstants.NumberOfRows)
        numberOfRowsLabel.text = "Number of rows: \(Int(sender.value))"
    }
    
    @IBAction func bricksPerRowChanged(sender: UIStepper) {
        defaults.setInteger(Int(sender.value), forKey: SettingsConstants.BricksPerRow)
        bricksPerRowLabel.text = "Bricks per row: \(Int(sender.value))"
    }
    
    @IBAction func paddleWidthChanged(sender: UIStepper) {
        defaults.setDouble(sender.value, forKey: SettingsConstants.PaddleWidth)
        paddleWidthLabel.text = "Paddle Width: \(sender.value)"
    }
}

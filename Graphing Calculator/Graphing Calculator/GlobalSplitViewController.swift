//
//  GlobalSplitViewController.swift
//  Graphing Calculator
//
//  Created by Sebastian Osiński on 22.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool{
        return true
    }
    
}
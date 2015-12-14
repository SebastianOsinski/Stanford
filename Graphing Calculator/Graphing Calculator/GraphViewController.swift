//
//  GraphViewController.swift
//  Graphing Calculator
//
//  Created by Sebastian Osiński on 22.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "zoom:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "moveGraph:"))
            
            let tapGesture = UITapGestureRecognizer(target: graphView, action: "moveOrigin:")
            tapGesture.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapGesture)
        }
    }

    private var graphingBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let programToGraph = defaults.objectForKey("CalculatorBrain.program") {
            graphingBrain.program = programToGraph
            
            let splitDescription = graphingBrain.description.componentsSeparatedByString(", ")
            title = splitDescription[splitDescription.endIndex - 1]
        }
    }
    
    func yForX(x: Double) -> Double? {
        graphingBrain.variableValues["M"] = x
        return graphingBrain.evaluate()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Stats" {
            if let svc = segue.destinationViewController as? StatsViewController {
                if let ppc = svc.popoverPresentationController {
                    ppc.delegate = self
                }
                svc.minValue = graphView.minimumValue
                svc.maxValue = graphView.maximumValue
            }
        }
    }
}

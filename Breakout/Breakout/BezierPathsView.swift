//
//  BezierPathsView.swift
//  Breakout
//
//  Created by Sebastian Osiński on 21.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {
    
    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        bezierPaths.values.forEach { $0.stroke() }
    }
}



//
//  GraphView.swift
//  Graphing Calculator
//
//  Created by Sebastian Osiński on 22.07.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func yForX(x: Double) -> Double?
}

@IBDesignable class GraphView: UIView {
    
    var origin: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var scale: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    var dataSource: GraphViewDataSource?
    
    override func drawRect(rect: CGRect) {
        if origin == nil {
            origin = convertPoint(center, fromView: superview)
        }
        
        let axesDrawer = AxesDrawer(color: UIColor.blackColor(), contentScaleFactor: self.contentScaleFactor)
        axesDrawer.drawAxesInRect(self.bounds, origin: origin!, pointsPerUnit: scale)
        
        bezierPathForData().stroke()
    }
    
    var maximumValue = -Double.infinity
    var minimumValue = Double.infinity
    
    private func bezierPathForData() -> UIBezierPath {
        let path = UIBezierPath()
        maximumValue = -Double.infinity
        minimumValue = Double.infinity
        if dataSource != nil {
            var startX: CGFloat = bounds.minX
            
            while (getYforX(startX) == nil) {
                startX += 1
            }
            
            path.moveToPoint(CGPoint(x: startX, y: getYforX(startX)!))
            
            var x = startX
            while x < bounds.maxX {
                if let y = getYforX(x) {
                    path.addLineToPoint(CGPoint(x: x, y: y))
                }
                x += 1
            }
        }
        return path
    }
    
    private func getYforX(x: CGFloat) -> CGFloat? {
        let xT = Double((x - origin!.x) / scale)
        let yT = dataSource?.yForX(Double(xT))
        
        if yT != nil && (yT!.isNormal || yT!.isZero) {
            maximumValue = yT! > maximumValue ? yT! : maximumValue
            minimumValue = yT! < minimumValue ? yT! : minimumValue
            
            return origin!.y - CGFloat(yT!) * scale
        } else {
            return nil
        }
    }
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func moveGraph(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Changed || gesture.state == .Ended {
            let translation = gesture.translationInView(self)
            origin = CGPoint(x: origin!.x + translation.x, y: origin!.y + translation.y)
            gesture.setTranslation(CGPointZero, inView: self)
        }
    }
    
    func moveOrigin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let newOrigin = gesture.locationInView(self)
            
            origin = newOrigin
        }
    }
    
}

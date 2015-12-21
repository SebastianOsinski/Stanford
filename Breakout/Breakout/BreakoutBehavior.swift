//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Sebastian Osiński on 21.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    lazy var collider: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        return behavior
    }()
    
    lazy var dynamic: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.friction = 0
        behavior.elasticity = 1
        behavior.resistance = 0
        behavior.allowsRotation = false
        return behavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(dynamic)
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        dynamic.addItem(ball)
        let velocity = CGPoint(x: 300, y: 300)
        dynamic.addLinearVelocity(velocity, forItem: ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        dynamic.removeItem(ball)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(named name: String) {
        collider.removeBoundaryWithIdentifier(name)
    }
}

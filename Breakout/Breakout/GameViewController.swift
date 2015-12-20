//
//  GameViewController.swift
//  Breakout
//
//  Created by Sebastian Osiński on 20.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var bricksPerRow: Int = 5
    var numberOfRows: Int = 4
    
    var paddleWidthRatio: CGFloat = 0.4
    var paddle: UIView?
    var paddleGestureRecogniser: UIPanGestureRecognizer!
    
    @IBOutlet weak var gameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paddleGestureRecogniser = UIPanGestureRecognizer(target: self, action: "paddleMoved:")
    }
    
    override func viewDidLayoutSubviews() {
        gameView.subviews.forEach { $0.removeFromSuperview() }
        
        let width = gameView.bounds.width
        let height = gameView.bounds.height
        
        let brickSpacing = width * 0.025
        let brickWidth = (width - brickSpacing * CGFloat(bricksPerRow + 1)) / CGFloat(bricksPerRow)
        let brickHeight: CGFloat = 20
        
        for row in 1...numberOfRows {
            for col in 1...bricksPerRow {
                let origin = CGPoint(x: brickSpacing * CGFloat(col) + brickWidth * CGFloat(col - 1),
                                    y: 10 + brickSpacing * CGFloat(row) + brickHeight * CGFloat(row - 1))
                let size = CGSize(width: brickWidth, height: brickHeight)
                
                let brickFrame = CGRect(origin: origin, size: size)
                let brick = UIView(frame: brickFrame)
                brick.backgroundColor = UIColor.blueColor()
                
                gameView.addSubview(brick)
            }
        }
        
        let paddleOrigin = CGPoint(x: width * (1 - paddleWidthRatio) / 2, y: height * 0.9)
        let paddleSize = CGSize(width: width * paddleWidthRatio, height: height * 0.05)
        let paddleRect = CGRect(origin: paddleOrigin, size: paddleSize)
        
        paddle = UIView(frame: paddleRect)
        paddle!.backgroundColor = UIColor.redColor()
        paddle!.addGestureRecognizer(paddleGestureRecogniser)
        gameView.addSubview(paddle!)
    }

   func paddleMoved(sender: UIPanGestureRecognizer) {
        if sender.state == .Changed || sender.state == .Ended {
            let translation = sender.translationInView(gameView)
            
            if let paddleView = sender.view {
                paddleView.center = CGPointMake(paddleView.center.x + translation.x, paddleView.center.y)
                sender.setTranslation(CGPoint.zero, inView: paddleView)
            }
        }
    }
}


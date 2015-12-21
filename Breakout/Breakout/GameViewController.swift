//
//  GameViewController.swift
//  Breakout
//
//  Created by Sebastian Osiński on 20.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    struct GameConstants {
        static let Paddle = "Paddle"
    }
    
    var bricksPerRow: Int = 5
    var numberOfRows: Int = 4
    
    var paddleWidthRatio: CGFloat = 0.4
    var paddle: UIView?
    var paddleGestureRecogniser: UIPanGestureRecognizer!
    
    var ball: UIView?
    
    @IBOutlet weak var gameView: BezierPathsView!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    lazy var animator: UIDynamicAnimator = { [unowned self] in
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        return animator
        }()

    let breakoutBehavior = BreakoutBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        paddleGestureRecogniser = UIPanGestureRecognizer(target: self, action: "paddleMoved:")
    }
    
    override func viewDidLayoutSubviews() {
        gameView.subviews.forEach { $0.removeFromSuperview() }
        
        configureBricks()
        configurePaddle()
        configureBall()
    }
    
    func configureBricks() {
        bricksPerRow = defaults.integerForKey(SettingsConstants.BricksPerRow)
        numberOfRows = defaults.integerForKey(SettingsConstants.NumberOfRows)
        let width = gameView.bounds.width
        
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
                breakoutBehavior.addBarrier(UIBezierPath(rect: brickFrame), named: "\(row)-\(col)")
            }
        }
    }
    
    func configurePaddle() {
        let width = gameView.bounds.width
        let height = gameView.bounds.height
        
        paddleWidthRatio = CGFloat(defaults.doubleForKey(SettingsConstants.PaddleWidth))
        
        let paddleOrigin = CGPoint(x: width * (1 - paddleWidthRatio) / 2, y: height * 0.9)
        let paddleSize = CGSize(width: width * paddleWidthRatio, height: height * 0.01)
        let paddleRect = CGRect(origin: paddleOrigin, size: paddleSize)
        
        paddle = UIView(frame: paddleRect)
        paddle!.backgroundColor = UIColor.redColor()
        paddle!.addGestureRecognizer(paddleGestureRecogniser)
        
        gameView.addSubview(paddle!)
        breakoutBehavior.addBarrier(UIBezierPath(rect: paddleRect), named: GameConstants.Paddle)
    }
    
    func configureBall() {
        if ball != nil {
            breakoutBehavior.removeBall(ball!)
        }
        
        let ballSize = CGSize(width: 20, height: 20)
        ball = UIView()
        ball!.backgroundColor = UIColor.greenColor()
        ball!.frame.size = ballSize
        ball!.center = gameView.center
        
        breakoutBehavior.addBall(ball!)
    }

    func paddleMoved(sender: UIPanGestureRecognizer) {
        if sender.state == .Changed || sender.state == .Ended {
            let translation = sender.translationInView(gameView)
            
            if let paddleView = sender.view {
                paddleView.center = CGPointMake(paddleView.center.x + translation.x, paddleView.center.y)
                breakoutBehavior.addBarrier(UIBezierPath(rect: paddleView.frame), named: GameConstants.Paddle)
                sender.setTranslation(CGPoint.zero, inView: paddleView)
            }
        }
    }
}


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
    
    @IBOutlet weak var gameView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        gameView.subviews.forEach { $0.removeFromSuperview() }
        
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
            }
        }
        
    }

}


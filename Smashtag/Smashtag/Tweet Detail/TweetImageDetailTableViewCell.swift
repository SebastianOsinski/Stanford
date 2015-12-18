//
//  TweetImageDetailTableViewCell.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 23.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetImageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tweetImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var tweetImage: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    var aspectRatio: Double = 1
    
    func updateUI() {
        tweetImageView?.image = nil
        
        if let image = tweetImage {
            tweetImageView.image = image
            spinner.stopAnimating()
        }
    }
}

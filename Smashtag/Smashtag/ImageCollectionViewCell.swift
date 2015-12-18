//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 26.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            spinner.stopAnimating()
        }
    }
}

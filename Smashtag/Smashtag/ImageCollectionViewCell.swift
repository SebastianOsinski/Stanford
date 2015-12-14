//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 26.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

    func updateUI() {
        imageView?.image = nil
        
        if let img = image {
            imageView?.image = img
            imageView?.sizeToFit()
            //spinner.stopAnimating()
            print(imageView?.frame.size)
        }
    }

}

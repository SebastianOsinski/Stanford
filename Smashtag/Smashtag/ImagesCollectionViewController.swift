//
//  ImagesCollectionViewController.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 26.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var mediaItems: [MediaItem]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SmashtagConstants.ImagesCollection.ImageCollectionViewCell, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if let url = mediaItems?[indexPath.row].url {
            cell.image = nil
            cell.spinner.startAnimating()
            ImageService.sharedInstance.fetchImageFromURL(url) { (image) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.image = image
                }
            }
            
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowZoomedImage, sender: indexPath)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.TweetDetails.ShowZoomedImage,
            let vc = segue.destinationViewController as? ZoomImageViewController,
            let indexPath = sender as? NSIndexPath,
            let url = mediaItems?[indexPath.row].url {
                
            ImageService.sharedInstance.fetchImageFromURL(url) { (image) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    vc.image = image
                }
            }
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        if width < height {
            return CGSizeMake(width * 0.33, width * 0.33)
        } else {
            return CGSizeMake(width * 0.2, width * 0.2)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionViewLayout.invalidateLayout()
    }
}

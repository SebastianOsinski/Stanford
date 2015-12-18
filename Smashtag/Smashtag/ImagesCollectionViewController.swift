//
//  ImagesCollectionViewController.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 26.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if let url = mediaItems?[indexPath.row].url {
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
        performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowZoomedImage, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.TweetDetails.ShowZoomedImage,
            let vc = segue.destinationViewController as? ZoomImageViewController,
            let indexPath = collectionView?.indexPathsForSelectedItems()?.first,
            let url = mediaItems?[indexPath.row].url {
                
            ImageService.sharedInstance.fetchImageFromURL(url) { (image) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    vc.image = image
                }
            }
        }
    }

}

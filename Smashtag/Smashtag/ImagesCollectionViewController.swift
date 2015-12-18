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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            fetchImageFromURL(url) { (image) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    print("cell")
                    cell.image = image
                }
            }
        }
        return cell
    }
    
    private func fetchImageFromURL(url: NSURL, handler: (UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            let cache = (UIApplication.sharedApplication().delegate as! AppDelegate).imageCache
            var image: UIImage? = nil
            if let cachedImage = cache.objectForKey(url) as? UIImage {
                print("cache")
                image = cachedImage
            } else {
                print("download")
                if let imageData = NSData(contentsOfURL: url) {
                    image = UIImage(data: imageData)
                    if image != nil {
                        cache.setObject(image!, forKey: url)
                    }
                }
            }
            handler(image)
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowZoomedImage, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.TweetDetails.ShowZoomedImage {
            if let vc = segue.destinationViewController as? ZoomImageViewController {
                if let indexPath = collectionView?.indexPathsForSelectedItems()?.first {
                    if let url = mediaItems?[indexPath.row].url {
                        fetchImageFromURL(url) { (image) -> Void in
                            dispatch_async(dispatch_get_main_queue()) {
                                vc.image = image
                            }
                        }
                    }
                }
            }
        }
    }

}

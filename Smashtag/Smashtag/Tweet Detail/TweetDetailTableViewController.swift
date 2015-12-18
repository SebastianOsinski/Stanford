//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 23.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit
import SafariServices

class TweetDetailTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    var tweet: Tweet? {
        didSet {
            media = tweet?.media
            URLs = tweet?.urls.map { $0.keyword }
            hashtags = tweet?.hashtags.map { $0.keyword }
            userMentions = tweet?.userMentions.map { $0.keyword }
            if tweet != nil {
                let user = "@" + tweet!.user.screenName
                if userMentions != nil {
                    userMentions!.insert(user, atIndex: 0)
                } else {
                    userMentions = [user]
                }
            }

        }
    }
    
    private var media: [MediaItem]?
    private var URLs: [String]?
    private var hashtags: [String]?
    private var userMentions: [String]?

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    private struct CellTypes {
        static let Images = 0
        static let URLs = 1
        static let Hashtags = 2
        static let Mentions = 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CellTypes.Images:
            return media?.count ?? 0
        case CellTypes.URLs:
            return URLs?.count ?? 0
        case CellTypes.Hashtags: //Hashtags
            return hashtags?.count ?? 0
        case CellTypes.Mentions: //Mentions
            return userMentions?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let item = indexPath.item
        
        switch section {
        case CellTypes.Images:
            let cell = tableView.dequeueReusableCellWithIdentifier(SmashtagConstants.TweetDetails.ImageDetailTableViewCell, forIndexPath: indexPath) as! TweetImageDetailTableViewCell
            if let url = media?[item].url {
                ImageService.sharedInstance.fetchImageFromURL(url) { (image) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        cell.tweetImage = image
                    }
                }
            }
            return cell
        case CellTypes.URLs:
            let cell = tableView.dequeueReusableCellWithIdentifier(SmashtagConstants.TweetDetails.TextDetailTableViewCell, forIndexPath: indexPath)
            cell.textLabel?.text = URLs?[item]
            return cell
        case CellTypes.Hashtags:
            let cell = tableView.dequeueReusableCellWithIdentifier(SmashtagConstants.TweetDetails.TextDetailTableViewCell, forIndexPath: indexPath)
            cell.textLabel?.text = hashtags?[item]
            return cell
        case CellTypes.Mentions:
            let cell = tableView.dequeueReusableCellWithIdentifier(SmashtagConstants.TweetDetails.TextDetailTableViewCell, forIndexPath: indexPath)
            cell.textLabel?.text = userMentions?[item]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        let item = indexPath.item
        switch section {
        case CellTypes.Images:
            let width = tableView.frame.width
            return width / CGFloat(media![item].aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CellTypes.Images:
            if media == nil || media!.count == 0 {
                return nil
            } else {
                return "Images"
            }
        case CellTypes.URLs:
            if URLs == nil || URLs!.count == 0 {
                return nil
            } else {
                return "URLs"
            }
        case CellTypes.Hashtags:
            if hashtags == nil || hashtags!.count == 0 {
                return nil
            } else {
                return "Hashtags"
            }
        case CellTypes.Mentions:
            if userMentions == nil || userMentions!.count == 0 {
                return nil
            } else {
                return "Users"
            }
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        
        switch section {
        case CellTypes.Images:
            performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowZoomedImage, sender: indexPath)
        case CellTypes.URLs:
            if let url = NSURL(string: URLs![item]) {
                let sfc = SFSafariViewController(URL: url)
                sfc.delegate = self
                presentViewController(sfc, animated: true, completion: nil)
            }
            
        case CellTypes.Hashtags:
            performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowSearchForDetails, sender: indexPath)
        case CellTypes.Mentions:
            performSegueWithIdentifier(SmashtagConstants.TweetDetails.ShowSearchForDetails, sender: indexPath)
        default:
            break
        }
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.TweetDetails.ShowZoomedImage,
            let vc = segue.destinationViewController as? ZoomImageViewController,
            let indexPath = sender as? NSIndexPath {
                
            ImageService.sharedInstance.fetchImageFromURL(media![indexPath.item].url) { (image) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    vc.image = image
                }
            }
        } else if segue.identifier == SmashtagConstants.TweetDetails.ShowSearchForDetails,
            let vc = segue.destinationViewController as? TweetTableViewController,
            let indexPath = sender as? NSIndexPath {
                
            var query: String? = nil
                
            switch indexPath.section {
            case CellTypes.Hashtags:
                query = hashtags![indexPath.item]
            case CellTypes.Mentions:
                query = userMentions![indexPath.item]
            default:
                break
            }
            
            vc.searchText = query
        }
    }
}

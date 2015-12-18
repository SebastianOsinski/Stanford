//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    private struct Colors {
        static let hashtagColor = UIColor(red: 0.93, green: 0.69, blue: 1.00, alpha: 1.00)
        static let mentionColor = UIColor(red: 0.33, green: 0.68, blue: 1.00, alpha: 1.00)
        static let urlColor = UIColor(red: 0.305, green: 0.620, blue: 0.241, alpha: 1.00)
    }
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            var tweetText = tweet.text
            
            //tweetTextLabel?.text = tweet.text
            if tweetText != nil  {
                for _ in tweet.media {
                    tweetText! += " 📷"
                }
            }
            
            let attributedTweetText = NSMutableAttributedString(string: tweetText)
            
            for hashtag in tweet.hashtags {
                attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: Colors.hashtagColor, range: hashtag.nsrange)
            }
            for mention in tweet.userMentions {
                attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: Colors.mentionColor, range: mention.nsrange)
            }
            for url in tweet.urls {
                attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: Colors.urlColor, range: url.nsrange)
            }
            
            tweetTextLabel?.attributedText = attributedTweetText
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                ImageService.sharedInstance.fetchImageFromURL(profileImageURL) { (image) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tweetProfileImageView?.image = image
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
}

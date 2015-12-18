//
//  SmashtagConstants.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 23.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

struct SmashtagConstants {
    
    struct UserDefaults {
        static let HistoryKey = "Smashtag.UserDefaults.History"
    }
    
    
    struct RecentSearches {
        static let SegueIdentifier = "Show Tweets For Search"
        static let ShowAllImages = "Show All Images"
    }
    
    struct TweetDetails {
        static let SegueIdentifier = "Show Tweet Details"
        static let ImageDetailTableViewCell = "TweetImageDetailTableViewCell"
        static let TextDetailTableViewCell = "TweetTextDetailTableViewCell"
        static let ShowSearchForDetails = "Show Tweets For Hashtag or User"
        static let ShowZoomedImage = "Show Zoomed Image"
    }
    
    struct ImagesCollection {
        static let ImageCollectionViewCell = "ImageCollectionViewCell"
    }
    
}
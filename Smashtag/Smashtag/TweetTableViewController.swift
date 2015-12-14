//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: - Public API
    
    private var defaults = NSUserDefaults.standardUserDefaults()

    var tweets = [[Tweet]]()

    var searchText: String? = "#stanford" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            if searchText != nil {
                saveToHistory(searchText!)
            }
            tweets.removeAll()
            tableView.reloadData() // clear out the table view
            refresh()
        }
    }
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Refreshing

    private var lastSuccessfulRequest: TwitterRequest?

    private var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    private func saveToHistory(search: String) {
        var history: [String] = defaults.objectForKey(SmashtagConstants.UserDefaults.HistoryKey) as? [String] ?? []

        if let index = history.indexOf(search) {
            history.removeAtIndex(index)
        }
        history.insert(search, atIndex: 0)
        
        if history.count > 100 {
            history.removeLast()
        }
        defaults.setObject(history, forKey: SmashtagConstants.UserDefaults.HistoryKey)
    }
    
    @IBAction private func refresh(sender: UIRefreshControl?) {
        if let request = nextRequestToAttempt {
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        self.lastSuccessfulRequest = request // oops, forgot this line in lecture
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    }
                    sender?.endRefreshing()
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    // MARK: - Storyboard Connectivity
    
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SmashtagConstants.TweetDetails.SegueIdentifier, sender: indexPath)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.TweetDetails.SegueIdentifier {
            if let vc = segue.destinationViewController as? TweetDetailTableViewController {
                let indexPath = sender as! NSIndexPath
                vc.tweet = tweets[indexPath.section][indexPath.item]
                navigationItem.backBarButtonItem = UIBarButtonItem(title: searchText, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            }
        } else if segue.identifier == SmashtagConstants.RecentSearches.ShowAllImages {
            if let vc = segue.destinationViewController as? ImagesCollectionViewController {
                let media = tweets.reduce([], combine: +).map { $0.media }.reduce([], combine: +)
                vc.mediaItems = media
            }
        }
    }
    
}

//
//  RecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by Sebastian Osiński on 23.07.2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    private var history: [String] = []

    override func viewWillAppear(animated: Bool) {
        history = defaults.objectForKey(SmashtagConstants.UserDefaults.HistoryKey) as? [String] ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyItem", forIndexPath: indexPath)
        cell.textLabel?.text = history[indexPath.item]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            history.removeAtIndex(indexPath.item)
            defaults.setObject(history, forKey: SmashtagConstants.UserDefaults.HistoryKey)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        }

    }
    
    // MARK: - Navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SmashtagConstants.RecentSearches.SegueIdentifier, sender: indexPath)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SmashtagConstants.RecentSearches.SegueIdentifier,
            let vc = segue.destinationViewController as? TweetTableViewController,
            let indexPath = sender as? NSIndexPath {
                
            vc.searchText = history[indexPath.item]
        }
    }
}

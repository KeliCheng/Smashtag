//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by ❤ on 12/25/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    //    MODEL
    var managedObjectContext: NSManagedObjectContext?
        = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var historyArray = UserDefaults.standard.array(forKey: "history")
        {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adjust height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyArray == nil {
            self.refreshControl?.endRefreshing()
            return 0
        } else {
            return historyArray!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history cell", for: indexPath)
        let history = historyArray?[indexPath.row]
        
        //        cell.textLabel?.text = "#" + (history as! String?)!
        if let historyCell = cell as? HistoryTableViewCell {
            historyCell.infoButton.tag = indexPath.row
            historyCell.history = history as! String?
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "show popularity" {
            if let popularityVC = segue.destination as? PopularityTableViewController {
                if let sender = sender as? UIButton {
                    popularityVC.history = historyArray?[sender.tag] as! String?
                    popularityVC.managedObjectContext = managedObjectContext
                }
            }
        } else if segue.identifier == "history search" {
            if let tweetVC = segue.destination as? TweetTableViewController {
                if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                    let history = historyArray?[indexPathForSelectedRow.row]
                    tweetVC.searchText = history as! String?
                    tweetVC.searchForTweets()
                }
            }
            
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
    }
    
    @IBAction func clearHistory(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "history")
        tableView.reloadData()
    }
    
}


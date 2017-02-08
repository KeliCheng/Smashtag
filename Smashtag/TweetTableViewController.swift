//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by ❤ on 12/23/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate{
    
    // MODEL: array of array of tweet for sections and rows
    
    var managedObjectContext: NSManagedObjectContext?
        = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // SEARCHING
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            addHistory(text: searchText!)
            title = searchText
        }
    }
    
    var history = [" "]
    private func addHistory(text: String) {
        if UserDefaults.standard.array(forKey: "history") != nil {
            history = UserDefaults.standard.array(forKey: "history") as! Array<String>
        }
        if history.count >= 100 {
            history.removeLast()
        }
        if !history.contains(text){
            history.insert(text, at: 0)
            UserDefaults.standard.setValue(history, forKey: "history")
            UserDefaults.standard.synchronize()
        }
    }
    
    // calcuated variable is optional
    private var twitterRequest: Twitter.Request? {
        if let query = searchText, !query.isEmpty { // check is not nil nor empty
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    private var lastTwitterRequest: Twitter.Request?
    
    // DISPATCH, BREAK MEM. CYCLE
    func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{ [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    // threads take time, they may not be the same when they come back; thus check requests are identical
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(newKeyword: self.searchText!, newTweets: newTweets)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newKeyword: String, newTweets: [Twitter.Tweet]) {
        managedObjectContext?.perform({
            _ = Keyword.keywordWithTweets(keywordText: newKeyword, tweetsInfo: newTweets, inManagedObjectContext: self.managedObjectContext!)
            
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error:\(error)")
            }
        })
        
        printDatabaseStatistics()
        
    }
    
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform({
            if let keywordCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Keyword")) {
                print("\(keywordCount) Keywords.")
            }
            if let tweetCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Tweet")) {
                print("\(tweetCount) Tweets.")
            }
            if let mentionCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Mention")) {
                print("\(mentionCount) Mentions.")
            }
            
        })
    }
    
    
    
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adjust height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    private struct storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.TweetCellIdentifier, for: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    
    // SELECT TWEET AND SHOW
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if segue.identifier == "TweetersMentioningSearchTerm" {
            if let tweetersTVC = destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        } else if segue.identifier == "tweet detail" {
            if let mentionVC = destination as? MentionTableViewController {
                mentionVC.navigationItem.title = "Mentions"
                if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                    mentionVC.tweet = tweets[indexPathForSelectedRow.section][indexPathForSelectedRow.row]
                }
            }
            
        }
        
        
        //        if let navcon = destination as? UINavigationController {
        //            destination = navcon.visibleViewController ?? destination
        //        }
    }
    
    // TEXTFIELD FOR SEARCHING
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
}

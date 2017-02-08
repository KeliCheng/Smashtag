//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by ❤ on 12/30/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController {
    // MODEL
    var mention: String? { didSet {updateUI()}}
    var managedObjectContext: NSManagedObjectContext? { didSet {updateUI()}}
    
    private func updateUI() {
        // fetch result from DB
        // make sure mention is not nil
        
//        if let context = managedObjectContext, (mention?.characters.count)! > 0 {
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
//            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "darkside") // [c] for case sensitive
//            request.sortDescriptors = [NSSortDescriptor(key: "screenName", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
//            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        } else {
//            fetchedResultsController = nil
//        }
//        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
//        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
//            // use a var in case of multi-thread
//            var screenName: String?
//            // accessing DB needs to perform in block, wait for the response to set textLabel
//        twitterUser.managedObjectContext?.performAndWait({
//                screenName = twitterUser.screenName
//            })
//            cell.textLabel?.text = screenName // UI is in main queue
//            if let count = tweetCountWithMentionByTwitterUser(user: twitterUser) {
//                cell.detailTextLabel?.text = (count == 1) ? "1 tweet":"\(count) tweets"
//            } else {
//                cell.detailTextLabel?.text = ""
//            }
//        }
        return cell
    }
    
//    private func tweetCountWithMentionByTwitterUser(user: TwitterUser) -> Int? {
//        var count: Int?
//        user.managedObjectContext?.performAndWait({
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
//            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
//            count = try! user.managedObjectContext?.count(for: request)
//        })
//        return count
//    }
}

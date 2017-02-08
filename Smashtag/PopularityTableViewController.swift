//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by ❤ on 12/31/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: CoreDataTableViewController {
    // MODEL
    var managedObjectContext: NSManagedObjectContext? { didSet {updateUI()}}
    var history: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mention")
            //            request.predicate = NSPredicate(format: "any relatedTweets.keywords = %@ and popularity > %d", history!, 1)
            request.predicate = NSPredicate(format: "any relatedTweets.text contains %@ and popularity > %d", history!, 1)
            let sortDescriptor1 = NSSortDescriptor(
                key: "popularity",
                ascending: false
            )
            let sortDescriptor2 = NSSortDescriptor(
                key: "text",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare(_:))
            )
            
            request.sortDescriptors = [sortDescriptor1, sortDescriptor2]
            //            request.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mention cell", for: indexPath)
        if let mention = fetchedResultsController?.object(at: indexPath) as? Mention {
            var mentionContent: String?
            var popularity: Int?
            mention.managedObjectContext?.performAndWait({
                popularity = Int(mention.popularity)
                mentionContent = mention.text
            })
            
            cell.textLabel?.text = mentionContent
            cell.detailTextLabel?.text = "mentioned " + String(popularity!) + " times"
        }
        
        return cell
    }
    
    
}

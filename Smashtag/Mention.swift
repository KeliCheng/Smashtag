//
//  Mention+CoreDataClass.swift
//  
//
//  Created by ❤ on 1/2/17.
//
//

import Foundation
import CoreData
import Twitter

@objc(Mention)
public class Mention: NSManagedObject {
    class func mentionWithMentionInfo(mentionInfo: Twitter.Mention, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mention")
        request.predicate = NSPredicate(format: "text = %@", mentionInfo.keyword)
        if let mention = (try?context.fetch(request))?.first as? Mention {
            mention.popularity += 1
            return mention
        } else if let mention = NSEntityDescription.insertNewObject(forEntityName: "Mention", into: context) as? Mention {
            mention.text = mentionInfo.keyword
            mention.type = mentionInfo.description
            mention.popularity = 1
            return mention
        }
        
        return nil
    }
    
}

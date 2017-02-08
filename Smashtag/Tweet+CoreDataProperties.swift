//
//  Tweet+CoreDataProperties.swift
//  
//
//  Created by ❤ on 1/2/17.
//
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var keywords: NSSet?
    @NSManaged public var mentions: NSSet?

}

// MARK: Generated accessors for keywords
extension Tweet {

    @objc(addKeywordsObject:)
    @NSManaged public func addToKeywords(_ value: Keyword)

    @objc(removeKeywordsObject:)
    @NSManaged public func removeFromKeywords(_ value: Keyword)

    @objc(addKeywords:)
    @NSManaged public func addToKeywords(_ values: NSSet)

    @objc(removeKeywords:)
    @NSManaged public func removeFromKeywords(_ values: NSSet)

}

// MARK: Generated accessors for mentions
extension Tweet {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(_ value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(_ value: Mention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(_ values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(_ values: NSSet)

}

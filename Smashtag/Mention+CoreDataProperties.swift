//
//  Mention+CoreDataProperties.swift
//  
//
//  Created by ❤ on 1/2/17.
//
//

import Foundation
import CoreData


extension Mention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mention> {
        return NSFetchRequest<Mention>(entityName: "Mention");
    }

    @NSManaged public var popularity: Int16
    @NSManaged public var text: String?
    @NSManaged public var type: String?
    @NSManaged public var relatedTweets: NSSet?

}

// MARK: Generated accessors for relatedTweets
extension Mention {

    @objc(addRelatedTweetsObject:)
    @NSManaged public func addToRelatedTweets(_ value: Tweet)

    @objc(removeRelatedTweetsObject:)
    @NSManaged public func removeFromRelatedTweets(_ value: Tweet)

    @objc(addRelatedTweets:)
    @NSManaged public func addToRelatedTweets(_ values: NSSet)

    @objc(removeRelatedTweets:)
    @NSManaged public func removeFromRelatedTweets(_ values: NSSet)

}

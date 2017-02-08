//
//  Tweet+CoreDataClass.swift
//  
//
//  Created by ❤ on 1/2/17.
//
//

import Foundation
import CoreData
import Twitter

@objc(Tweet)
public class Tweet: NSManagedObject {
    class func tweetWithTwitterInfo(keyword: String, twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try?context.fetch(request))?.first as? Tweet {
            return addMentions(keyword: keyword, tweet: tweet, twitterInfo: twitterInfo, inManagedObjectContext: context)
        }
            // if cannot find the tweet from DB, create one
        else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context) as? Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created as NSDate?
            return addMentions(keyword: keyword, tweet: tweet, twitterInfo: twitterInfo, inManagedObjectContext: context)
        }
        
        return nil
    }
    
    class func addMentions(keyword: String, tweet: Tweet, twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let tweetMentions = ["hashtags": twitterInfo.hashtags, "userMentions": twitterInfo.userMentions]
        for (_, mentionsInfo) in tweetMentions {
            for m in mentionsInfo {
                if let mention = Mention.mentionWithMentionInfo(mentionInfo: m, inManagedObjectContext: context) {
                    let mentions = tweet.mutableSetValue(forKey: "mentions")
                    mentions.add(mention)
                }
            }
            
        }
        return tweet
    }
    
}

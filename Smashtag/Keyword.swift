//
//  Keyword+CoreDataClass.swift
//  
//
//  Created by ❤ on 1/2/17.
//
//

import Foundation
import CoreData
import Twitter

@objc(Keyword)
public class Keyword: NSManagedObject {
    class func keywordWithTweets(keywordText: String, tweetsInfo: [Twitter.Tweet], inManagedObjectContext context: NSManagedObjectContext) -> Keyword? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Keyword")
        request.predicate = NSPredicate(format: "text = %@", keywordText)
        
        // fetch the request and looking for the keyword
        if let keyword = (try?context.fetch(request))?.first as? Keyword {
            return addTweets(keyword: keyword, tweetsInfo: tweetsInfo, inManagedObjectContext: context)
        } else if let keyword = NSEntityDescription.insertNewObject(forEntityName: "Keyword", into: context) as? Keyword {
            keyword.text = keywordText
            return addTweets(keyword: keyword, tweetsInfo: tweetsInfo, inManagedObjectContext: context)
        }
        return nil
    }
    
    class func addTweets(keyword: Keyword, tweetsInfo: [Twitter.Tweet], inManagedObjectContext context: NSManagedObjectContext) -> Keyword? {
        for tweetInfo in tweetsInfo {
            // update DB
            if let tweet = Tweet.tweetWithTwitterInfo(keyword: keyword.text!, twitterInfo: tweetInfo, inManagedObjectContext: context) {
                // also update mutableSet for accessing
                let tweets = keyword.mutableSetValue(forKey: "tweets")
                tweets.add(tweet)
            }
            
        }
        return keyword
    }
    
}

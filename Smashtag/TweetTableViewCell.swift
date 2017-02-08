//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by ❤ on 12/23/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    
    // set the VIEW
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOf: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData as Data)
                }
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
            
            // change color of mentions
            var mutableString = NSMutableAttributedString()
            mutableString = NSMutableAttributedString(string: tweet.text, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!])
            for m in tweet.hashtags {
                mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: m.nsrange)
            }
            for m in tweet.urls {
                mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: m.nsrange)
            }
            for m in tweet.userMentions {
                mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: m.nsrange)
            }
            tweetTextLabel?.attributedText = mutableString
        }
        
    }
    
    
}

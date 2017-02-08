//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by ❤ on 12/24/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {
    var tweet: Twitter.Tweet? {
        didSet {
            if let tweet = tweet {
                title = tweet.user.name
                
                // Images
                if tweet.media.count > 0 {
                    var mediaItems = [Mention]()
                    for mediaItem in tweet.media {
                        mediaItems.append(Mention.Image(mediaItem))
                    }
                    addMentions(mentionsToInsert: mediaItems)
                }
                
                // Hashtags
                if tweet.hashtags.count > 0 {
                    var hashtags = [Mention]()
                    for hashtag in tweet.hashtags {
                        hashtags.append(Mention.Hashtag(hashtag.keyword))
                    }
                    addMentions(mentionsToInsert: hashtags)
                }
                
                // URLs
                if tweet.urls.count > 0 {
                    var urls = [Mention]()
                    for url in tweet.urls {
                        urls.append(Mention.URL(url.keyword))
                    }
                    addMentions(mentionsToInsert: urls)
                }
                
                // Users
                var userMentions = [Mention]()
                userMentions.append(Mention.UserMention("@\(tweet.user.screenName)"))
                if tweet.userMentions.count > 0 {
                    for userMention in tweet.userMentions {
                        userMentions.append(Mention.UserMention(userMention.keyword))
                    }
                }
                addMentions(mentionsToInsert: userMentions)
            }
        }
    }
    
    private var mentions = [[Mention]]()
    private func addMentions(mentionsToInsert: [Mention]) {
        mentions.insert(mentionsToInsert, at: mentions.count)
    }
    
    private enum Mention {
        case Image(MediaItem)
        case Hashtag(String)
        case URL(String)
        case UserMention(String)
        var description: String {
            switch self {
            case .Image(let mediaItem):
                return mediaItem.url.absoluteString
            case .Hashtag(let hashtag):
                return hashtag
            case .URL(let url):
                return url
            case .UserMention(let userMention):
                return userMention
            }
        }
        var type: String {
            switch self {
            case .Image(_):
                return "Images"
            case .Hashtag(_):
                return "Hashtags"
            case .URL(_):
                return "URLs"
            case .UserMention(_):
                return "Users"
            }
        }
    }
    
    
    func updateUI() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adjust height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(mentions.count - section)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return (tweet?.hashtags.count)! + (tweet?.urls.count)! + (tweet?.userMentions.count)!
        return mentions[section].count
    }
    
    private struct storyboard {
        static let TextCellIdentifier = "text cell"
        static let ImageCellIdentifier = "image cell"
        static let ShowImageSegue = "show image"
        static let SearchTagSegue = "search tag"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section][indexPath.row]
        switch mention {
        case .Image(let mediaItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.ImageCellIdentifier, for: indexPath)
            if let imageCell = cell as? MentionImageTableViewCell {
                imageCell.imageURL = mediaItem.url
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: storyboard.TextCellIdentifier, for: indexPath)
            cell.textLabel?.text = mention.type
            cell.detailTextLabel?.text = mention.description
            return cell
        }
        
    }
    
    
    // OPEN URL IN SAFARI
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mention = mentions[indexPath.section][indexPath.row]
        switch mention {
        case .URL(let urlString):
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
    // SEARCH FOR HASHTAG or OPEN IMAGE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination
        if let navcon = destination as? UINavigationController {
            destination = navcon.visibleViewController ?? destination
        }
        if let segueID = segue.identifier {
            switch segueID {
            case storyboard.SearchTagSegue:
                if let tweetVC = destination as? TweetTableViewController {
                    if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                        let mention = mentions[indexPathForSelectedRow.section][indexPathForSelectedRow.row]
                        if mention.type != "URLs" {
                            tweetVC.searchText = mention.description
                            tweetVC.searchForTweets()
                        }
                    }
                }
                
            case storyboard.ShowImageSegue:
                if let imgVC = destination as? ImageViewController {
                    if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                        let mention = mentions[indexPathForSelectedRow.section][indexPathForSelectedRow.row]
                        switch mention {
                        case .Image(let mediaItem):
                            imgVC.imageURL = mediaItem.url
                        default: break
                        }
                    }
                }
            default:
                break
            }
        }
    }
}

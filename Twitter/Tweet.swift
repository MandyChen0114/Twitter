//
//  Tweet.swift
//  Twitter
//
//  Created by Mandy Chen on 9/28/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

enum TweetType: String {
    case Retweet, Reply, Original
}

class Tweet: NSObject {
    
    let text: String?
    let timestamp: Date?
    var replyCount: Int
    var retweetCount: Int
    var favoritesCount: Int
    var favorited: Bool!
    var retweeted: Bool!
    var user: User?
    let idStr: String?
    var retweetedStatus:NSDictionary?
    var inReplyToScreenName:String?
    var tweetType:TweetType?
    var retweetedUser:User?
    
    init(dictionary: [String: AnyObject]) {
        self.text = dictionary["text"] as? String
        self.replyCount = (dictionary["reply_count"] as? Int) ?? 0
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZ yyyy"
            timestamp = formatter.date(from: timestampString)
        } else {
            timestamp = nil
        }
        
        if let userDict = dictionary["user"] as? [String: AnyObject]{
            self.user = User(dictionary: userDict)
        } else {
            self.user = nil
        }
        
        
        self.favorited = (dictionary["favorited"] as? Bool) ?? false
        self.retweeted = (dictionary["retweeted"] as? Bool) ?? false
        self.idStr = dictionary["id_str"] as? String
        
        inReplyToScreenName = dictionary["in_reply_to_screen_name"] as? String
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        if(retweetedStatus != nil){
            tweetType = TweetType.Retweet
            retweetedUser = user
            user = User(dictionary: (retweetedStatus!["user"] as! [String : AnyObject]))
        } else if(inReplyToScreenName != nil){
            tweetType = TweetType.Reply
        } else {
            tweetType = TweetType.Original
        }

    }
    
    class func tweetsWithArray(dictionaries: [[String: AnyObject]]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

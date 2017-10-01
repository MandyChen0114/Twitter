//
//  Tweet.swift
//  Twitter
//
//  Created by Mandy Chen on 9/28/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    let text: String?
    let timestamp: Date?
    var replyCount: Int
    var retweetCount: Int
    var favoritesCount: Int
    var favorited: Bool?
    var retweeted: Bool?
    let user: User?
    
    init(dictionary: NSDictionary) {
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
            print("\(self.user?.name)")
        } else {
            self.user = nil
        }
        
        
        self.favorited = dictionary["favorited"] as? Bool
        self.retweeted = dictionary["retweeted"] as? Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

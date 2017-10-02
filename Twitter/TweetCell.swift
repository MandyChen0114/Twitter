//
//  TweetCell.swift
//  Twitter
//
//  Created by Mandy Chen on 9/30/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    
    var avatarURL : URL?
    
    var tweet: Tweet! {
        didSet {
            if let imageUrl = tweet.user?.profileUrl {
                avatarImage.setImageWith(imageUrl)
                self.avatarURL = imageUrl
            } else {
                avatarImage.image = UIImage(named: "defaultImage")
            }
            avatarImage.clipsToBounds = true
            avatarImage.layer.cornerRadius = 32.5
            nameLabel.text = tweet.user?.name
            if let screenName = tweet.user?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            
            
            if let date = tweet.timestamp {
                dateLabel.text = TwitterClient.convertTweetTimestamp(timestamp: date)
            }
            
            tweetContent.text = tweet.text
            replyCount.text = "\(tweet.replyCount)"
            retweetCount.text = "\(tweet.retweetCount)"
            likeCount.text = "\(tweet.favoritesCount)"
            
            if tweet.favorited! {
                favoriteImage.image = UIImage(named: "liked")
            } else {
                favoriteImage.image = UIImage(named: "like")
            }
            
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweeted")
            } else {
                retweetImage.image = UIImage(named: "retweet")
            }
            
            
            let favoriteTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            favoriteImage.isUserInteractionEnabled = true
            favoriteImage.addGestureRecognizer(favoriteTapGestureRecognizer)
            
            let retweetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            retweetImage.isUserInteractionEnabled = true
            retweetImage.addGestureRecognizer(retweetTapGestureRecognizer)
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if tappedImage.tag == 1 {
            var param = [String: AnyObject]()
            param["id"] = tweet.idStr as AnyObject?
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweet")
                TwitterClient.sharedInstance?.unretweet(param: param, success: { (tweet) -> (Void) in
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.retweetCount.text = "\(self.tweet.retweetCount)"
                }, failure: { (error) in
                })
                
            } else {
                retweetImage.image = UIImage(named: "retweeted")
                TwitterClient.sharedInstance?.retweet(param: param, success: { (tweet) -> (Void) in
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                    self.retweetCount.text = "\(self.tweet.retweetCount)"
                }, failure: { (error) in
                })
            }
        } else if tappedImage.tag == 2 {
            var param = [String: AnyObject]()
            param["id"] = tweet.idStr as AnyObject?
            if tweet.favorited! {
                favoriteImage.image = UIImage(named: "like")
                TwitterClient.sharedInstance?.favoriteDestroy(param: param, success: { (tweet) -> (Void) in
                    self.tweet.favorited = false
                    self.tweet.favoritesCount -= 1
                    self.likeCount.text = "\(self.tweet.favoritesCount)"
                }, failure: { (error) in
                })
                
            } else {
                favoriteImage.image = UIImage(named: "liked")
                TwitterClient.sharedInstance?.favoriteCreate(param: param, success: { (tweet) -> (Void) in
                    self.tweet.favorited = true
                    self.tweet.favoritesCount += 1
                    self.likeCount.text = "\(self.tweet.favoritesCount)"
                }, failure: { (error) in
                })
            }
        }
    }

}

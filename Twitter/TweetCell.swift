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

}

//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 10/1/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    var tweet: Tweet!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var interactionView: UIView!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl = tweet.user?.profileUrl {
            avatar.setImageWith(imageUrl)
        } else {
            avatar.image = UIImage(named: "defaultImage")
        }
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 32.5
        name.text = tweet.user?.name
        if let screenNameStr = tweet.user?.screenName {
            screenName.text = "@\(screenNameStr)"
        }
        
        
        if let date = tweet.timestamp {
            timestamp.text = TwitterClient.convertTweetTimestamp(timestamp: date)
        }
        
        tweetContent.text = tweet.text
        retweetCount.text = "\(tweet.retweetCount)"
        favoriteCount.text = "\(tweet.favoritesCount)"
        countView.layer.borderWidth = 1.0
        countView.layer.borderColor = UIColor.lightGray.cgColor
        interactionView.layer.borderWidth = 0.5
        interactionView.layer.borderColor = UIColor.lightGray.cgColor
        
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
        
        let replyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        replyImage.isUserInteractionEnabled = true
        replyImage.addGestureRecognizer(replyTapGestureRecognizer)
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if tappedImage.tag == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ComposeNavigationController")
            
            self.present(vc, animated: true, completion: nil)
            
        } else if tappedImage.tag == 1 {
            var param = [String: AnyObject]()
            param["id"] = tweet.idStr as AnyObject?
            if tweet.retweeted! {
                retweetImage.image = UIImage(named: "retweet")
                TwitterClient.sharedInstance?.unretweet(param: param, success: { (tweet) -> (Void) in
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.retweetCount.text = "\(self.tweet.retweetCount)"
                }, failure: { (error) in
                    self.showError(error: error)
                })
                
            } else {
                retweetImage.image = UIImage(named: "retweeted")
                TwitterClient.sharedInstance?.retweet(param: param, success: { (tweet) -> (Void) in
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                    self.retweetCount.text = "\(self.tweet.retweetCount)"
                }, failure: { (error) in
                    self.showError(error: error)
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
                    self.favoriteCount.text = "\(self.tweet.favoritesCount)"
                }, failure: { (error) in
                    self.showError(error: error)
                })
                
            } else {
                favoriteImage.image = UIImage(named: "liked")
                TwitterClient.sharedInstance?.favoriteCreate(param: param, success: { (tweet) -> (Void) in
                    self.tweet.favorited = true
                    self.tweet.favoritesCount += 1
                    self.favoriteCount.text = "\(self.tweet.favoritesCount)"
                }, failure: { (error) in
                    self.showError(error: error)
                })
            }
        }
    }


    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

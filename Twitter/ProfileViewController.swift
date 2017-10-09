//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 10/7/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var user:User?
    var tweets:[Tweet]!
    
    var headerBlurImageView:UIImageView!
    var headerImageView:UIImageView!
    let offset_HeaderStop:CGFloat = 40.0
    let distance_W_LabelHeader:CGFloat = 30.0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100;

        initProfileView()
        getTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        headerImageView = UIImageView(frame: headerView.bounds)
        headerBlurImageView = UIImageView(frame: headerView.bounds)
        print("banner image url: \(user?.bannerImageUrl)")
        if let bannerImageUrl = user?.bannerImageUrl {
            headerImageView.setImageWith(bannerImageUrl)
            headerBlurImageView.setImageWith(bannerImageUrl)
        }
        
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        


        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerBlurImageView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerBlurImageView?.addSubview(blurEffectView)
    
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        headerView.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        headerView.clipsToBounds = true
        headerView.isHidden = false
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height , 0, 0, 0)
    }

    
    func initProfileView() {
        if let imageUrl = user?.profileUrl {
            avatarImage.setImageWith(imageUrl)
        } else {
            avatarImage.image = UIImage(named: "defaultImage")
        }
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 32.5
        headerLabel.text = user?.name
        nameLabel.text = user?.name
        if let screenName = user?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        followingCountLabel.text = "\(user!.followingCount)"
        followersCountLabel.text = "\(user!.followersCount)"
    }
    
    func getTweets() {
        let count = 20 as AnyObject
        let userId = user?.userID as AnyObject
        let param =  ["count": count, "user_id" : userId] as [String: AnyObject]
        
        TwitterClient.sharedInstance?.userTimeline(param: param ,success: { (tweets:[Tweet]) in
            
            self.tweets = tweets
        
            self.tableView.reloadData()
            
        }, failure: {(error : Error) -> () in
            self.showError(error: error)
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
   
        cell.tweet = tweet
        return cell
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.zPosition = 0
            headerLabel.isHidden = true
            
        } else {
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            headerLabel.isHidden = false
            let alignToNameLabel = -offset + nameLabel.frame.origin.y + headerView.frame.height + offset_HeaderStop
            
            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToNameLabel, distance_W_LabelHeader + offset_HeaderStop))

            headerBlurImageView?.alpha = min (1.0, (offset - alignToNameLabel)/distance_W_LabelHeader)
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
            }else {
                if avatarImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                }
                
            }
            
        }

        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
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

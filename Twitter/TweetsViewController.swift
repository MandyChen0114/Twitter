//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 9/30/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            
        })
        
        initRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.section]
        cell.tweet = tweet
        return cell
    }

    // MARK: - Pull and Refresh
    func initRefreshControl() {

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            refreshControl.endRefreshing()
        })

    }

    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
//            case "composeSegue":
//                let composeNavigationController = segue.destination as! UINavigationController
//                let composeVC = composeNavigationController.topViewController as! ComposeViewController
            case "homeToDetailSegue":
                let detailNavigationController = segue.destination as! UINavigationController
                let detailVC = detailNavigationController.topViewController as! TweetDetailViewController
                let cell = sender as! TweetCell
                detailVC.tweet = cell.tweet
            default:
                ()
        }
    }


}

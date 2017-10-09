//
//  MenuViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 10/7/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var homeTimeLineNavController:UIViewController!
    private var mentionsNavController:UIViewController!
    private var profileNavController:ProfileViewController!
    
    var viewControllers:[UIViewController] = []
    let titles = ["Home", "Mentions", "Profile"]
    var hamburgerViewController: HamburgerViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeTimeLineNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        homeTimeLineNavController.title = "Home"
        viewControllers.append(homeTimeLineNavController)
        
        mentionsNavController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavController.title = "Mentions"
        viewControllers.append(mentionsNavController)
        
        profileNavController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileNavController.user = User.currentUser
        profileNavController.title = "Profile"
        viewControllers.append(profileNavController)
        
        hamburgerViewController.contentViewController = homeTimeLineNavController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuItem = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = Int.init(self.view.frame.height)/titles.count
        return CGFloat.init(rowHeight)
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

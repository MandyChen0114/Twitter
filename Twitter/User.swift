//
//  User.swift
//  Twitter
//
//  Created by Mandy Chen on 9/28/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

class User: NSObject {

    let name: String?
    let screenName: String?
    let profileUrl: URL?
    let tagline: String?
    let bannerImageUrl: URL?
    let userID:Int64!
    var followersCount = 0
    var followingCount = 0
    
    var dictionary: [String: AnyObject]
    
    init(dictionary:  [String: AnyObject]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        } else {
            profileUrl = nil
        }
        if let bannerImageUrlStr = dictionary["profile_banner_url"] as? String {
            bannerImageUrl = URL(string: bannerImageUrlStr)
        } else {
            bannerImageUrl = nil
        }

        tagline = dictionary["description"] as? String
        
        let userIDStr = dictionary["id"]!
        userID = (userIDStr as! NSNumber).int64Value
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    static let userDidLogoutNotification = Notification.Name("UserDidLogout")
    static var _currentUser: User?
    class var currentUser: User? {
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let data = defaults.data(forKey: "currentUserData"),
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                    let dictionary = jsonData as? [String: AnyObject] {
                    _currentUser = User(dictionary: dictionary)
                    return _currentUser
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                if let data = try? JSONSerialization.data(withJSONObject: user.dictionary, options: []) {
                    defaults.set(data, forKey: "currentUserData")
                } else {
                    defaults.set(nil, forKey: "currentUserData")
                }
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}

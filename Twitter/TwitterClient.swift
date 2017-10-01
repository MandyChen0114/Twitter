//
//  TwitterClilent.swift
//  Twitter
//
//  Created by Mandy Chen on 9/28/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "j8BOI8FPLPugqeZpNsLIDAfuI", consumerSecret: "BatMVt2aPfnkEUTX9r12b10hmb7iHs3iXSrR3OYyX7IePvqQoz")
    
    var loginSuccess: (() -> Void)?
    var loginFailure: ((Error) -> Void)?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token",
                          method: "GET",
                          callbackURL: URL(string: "twitter://oauth"),
                          scope: nil,
                          success: { (requestToken: BDBOAuth1Credential?) -> Void in
                            if let token = requestToken?.token,
                                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)") {
                                UIApplication.shared.open(url,
                                                          options: [:],
                                                          completionHandler: nil)
                            }},
                          failure: { (error: Error?) in
                            print("error: \(error?.localizedDescription ?? "unknown")")
                            if let error = error {
                                self.loginFailure?(error)
                            }}
        )
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(
            name: User.userDidLogoutNotification,
            object: nil
        )
    }
    
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "/oauth/access_token",
                         method: "POST",
                         requestToken: requestToken,
                         success: { (accessToken: BDBOAuth1Credential?) in
                            self.currentAccount(
                                success: { (user) in
//                                    if let accessToken = accessToken {
//                                        User.saveCurrentUser(user: user, accessToken: accessToken)
//                                    }
                                    User.currentUser = user
                                    self.loginSuccess?()},
                                failure: { (error) in
                                    self.loginFailure?(error)
                                })
                        },
                        failure: { (error: Error?) in
                            print("error: \(error?.localizedDescription ?? "unknown")")
                            if let error = error {
                                self.loginFailure?(error)
                            }
                        }
        )
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        get("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (_, response: Any?) in
                if let dictionaries = response as? [NSDictionary] {
                    
                    let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)                    
                    success(tweets)
                }
            },
            failure: { (_, error: Error) in
                failure(error)
        })
    }
    
    func currentAccount(success:@escaping (User) -> Void, failure: @escaping (Error) -> Void ) {
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (_, response: Any?) in
                if let userDictionary = response as? [String: AnyObject] {
                    let user = User(dictionary: userDictionary)
                    success(user)
                }
        },
            failure: { (_, error: Error) in
                failure(error)
        })
    }
    
    static func convertTweetTimestamp(timestamp: Date) -> String {
        
        let interval = abs(timestamp.timeIntervalSinceNow)
        
        if interval < 60 * 60 * 24 {
            let minutes = Int((interval / 60).truncatingRemainder(dividingBy: 60))
            let hours = Int((interval / 3600))
            
            let result = (hours == 0 ? "" : "\(hours)h ") + (minutes == 0 ? "" : "\(minutes)m ")
            return result
        } else {
            let formatter: DateFormatter = {
                let format = DateFormatter()
                format.dateFormat = "MM/dd/yy"
                return format
            }()
            return formatter.string(from: timestamp)
        }
    }
}

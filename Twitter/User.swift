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
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        } else {
            profileUrl = nil
        }
        tagline = dictionary["description"] as? String
    }
    
}

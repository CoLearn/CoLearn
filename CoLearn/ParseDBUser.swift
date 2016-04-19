//
//  ParseDBUser.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 4/6/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse

class ParseDBUser: NSObject {
    var userId: String?
    var about: String?
    var fullName: String?
    var phoneNumber: String?
    var location: String?
    
    var userInfo: PFObject? {
        didSet {
            if let userInfo = userInfo {
                self.userId = (userInfo["user_id"] as! String)
                self.about = (userInfo["about"] as! String)
                self.fullName = (userInfo["name"] as! String)
                self.phoneNumber = (userInfo["phoneNumber"] as! String)
                self.location = (userInfo["loc"] as! String)
            }
        }
    }
}

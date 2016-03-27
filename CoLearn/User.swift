//
//  User.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var phoneNumber: String?
    var about: String?
    var rewards: String?
    var timeZone: String?
    var profilePictureURL: NSURL?
    var coverPictureURL: NSURL?
    var location: Location?
    
    var userInfo: AnyObject? {
        didSet {
            if let userInfo = userInfo {
                // Id
                if let id = userInfo["id"] as? String{
                    self.id = id
                }
                // First Name
                if let firstName = userInfo["first_name"] as? String {
                    self.firstName = firstName
                }
                // Last Name
                if let lastName = userInfo["last_name"] as? String {
                    self.lastName = lastName
                }
                // About
                if let about = userInfo["about"] as? String {
                    self.about = about
                } else {
                    self.about = ""
                }
                // Location
                let timeZone = userInfo["timezone"] as? Int
                let locale = userInfo["locale"] as? String
                if let timeZone = timeZone {
                    if let locale = locale {
                        self.location = Location(country: locale, timeZone: "\(timeZone)")
                    }
                }
                //Profile Picture
                if let picture = userInfo["picture"] as? NSDictionary{
                    if let data = picture["data"] as? NSDictionary {
                        if let profileImageUrl = data["url"] as? String {
                            self.profilePictureURL =  NSURL(string: profileImageUrl)
                        }
                    }
                }
                // Cover Picture
                //        let cover = userInfo["cover"] as? NSDictionary
                //        let coverPhotoUrl = cover!["source"] as? String
                //        if let coverPhotoUrl = coverPhotoUrl {
                //            self.coverPictureURL = NSURL(string: coverPhotoUrl)
                //        }
            }
        }
    }
    
    func toString() -> String{
        return "User: { [id: \(self.id)] [First Name: \(self.firstName)] [Last Name: \(self.lastName)] [Phone: \(self.phoneNumber)] [About: \(self.about)] [Country: \(self.location?.country)] [State: \(self.location?.state)] [City: \(self.location?.city)] [Timezone: \(self.location?.timeZone)] [Rewards: \(self.rewards)]"
    }
}

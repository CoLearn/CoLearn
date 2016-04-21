//
//  FacebookSDK.swift
//  CoLearn
//
//  Created by Caleb Ripley on 4/4/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookSDK: NSObject {
    
    // Get the User Information from Facebook, using Graph Request.
    class func getUserInfoFromFacebook(success: (User?) -> (), failure: (NSError?) -> () ) {
        let params = ["fields": "id, name, first_name, last_name, email, picture, cover, bio, friends, locale, location,  timezone"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                retrieveUserInfo(result)
                success(retrieveUserInfo(result))
            } else {
                print(error.localizedDescription)
                failure(error)
            }
        }
    }
    
    
    private class func retrieveUserInfo(userInfo: AnyObject?) -> User {
        
        let user = User()
        
        if let userInfo = userInfo {
            // Id
            if let id = userInfo["id"] as? String{
                user.id = id
            }
            // First Name
            if let firstName = userInfo["first_name"] as? String {
                user.firstName = firstName
            }
            // Last Name
            if let lastName = userInfo["last_name"] as? String {
                user.lastName = lastName
            }
            // Full Name
            if let fullName = userInfo["name"] as? String {
                user.fullName = fullName
            }
            // Email
            if let email = userInfo["Email"] as? String {
                user.email = email
            }
//            // About
//            if let about = userInfo["bio"] as? String {
//                user.about = about
//            } else {
//                user.about = ""
//            }
            // Location
            let timeZone = userInfo["timezone"] as? Int
            let locale = userInfo["locale"] as? String
            if let timeZone = timeZone {
                if let locale = locale {
                    user.location = Location(country: locale, timeZone: "\(timeZone)")
                }
            }
            // Location- City, State
            if let locationDictionary = userInfo["location"] as? NSDictionary {
                if let location = locationDictionary["name"] as? String {
                    user.location?.loc = location
                }
            }
            //Profile Picture
            if let picture = userInfo["picture"] as? NSDictionary{
                if let data = picture["data"] as? NSDictionary {
                    if let profileImageUrl = data["url"] as? String {
                        user.profilePictureURL =  NSURL(string: profileImageUrl)
                    }
                }
            }
            // Cover Picture
            if let cover = userInfo["cover"] as? NSDictionary {
                if let coverPhotoUrl = cover["source"] as? String {
                    user.coverPictureURL = NSURL(string: coverPhotoUrl)
                }
            }
            
            user.languagesCanTeach = LanguagesChosen()
            user.languagesToLearn = LanguagesChosen()
        }
        return user
    }
}

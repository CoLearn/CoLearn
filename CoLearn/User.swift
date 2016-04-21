//
//  User.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var fullName: String!
    var email: String!
    var phoneNumber: String?
    var about: String?
    var rewards: String?
    var timeZone: String?
    var profilePictureURL: NSURL?
    var coverPictureURL: NSURL?
    var location: Location?
    var languagesCanTeach: LanguagesChosen?
    var languagesToLearn: LanguagesChosen?
    
    
    class func setUserInfoFromDB(userInfo: AnyObject?) -> User {
    let user = User()
    
        if userInfo != nil {
            CoLearnClient.getUserDataFromDB((currentUser?.id)!, success: { (userInfo: PFObject?) in

                if let about = userInfo!["about"] {
                    currentUser!.about = about as? String
                }
                if let name = userInfo!["name"] {
                    currentUser!.fullName = name as? String
                }
                if let location = userInfo!["loc"] {
                    currentUser!.location?.loc = location as? String
                }
                if let phoneNum = userInfo!["phoneNumber"] {
                    currentUser!.phoneNumber = phoneNum as? String
                }
                currentUser?.rewards = ""

                }, failure: { (error: NSError?) in
                    print(error?.localizedDescription)
            })
        }
        
        CoLearnClient.getLanguagesCanTeachByAnUser((currentUser?.id)!, success: { (languages: [PFObject]?) in
            currentUser?.teachLang = languages
        }) { (error: NSError?) in
                print("Error getting languages user can teach: \(error?.localizedDescription)")
        }
        
    return user
    }
    
    var learnLang: [PFObject]? {
        didSet {
            languagesToLearn = LanguagesChosen()
            for lanObject in learnLang! {
                switch lanObject["lang"] as! String {
                case "English":
                    languagesToLearn?.addLanguage(Languages.LangType.ENGLISH)
                case "French":
                    languagesToLearn?.addLanguage(Languages.LangType.FRENCH)
                case "Spanish":
                    languagesToLearn?.addLanguage(Languages.LangType.SPANISH)
                case "Chinese":
                    languagesToLearn?.addLanguage(Languages.LangType.CHINESE)
                default: ()
                }
            }
        }
    }
    
    var teachLang: [PFObject]? {
        didSet {
            languagesCanTeach = LanguagesChosen()
            for lanObject in teachLang! {
                switch lanObject["lang"] as! String {
                case "English":
                    languagesCanTeach?.addLanguage(Languages.LangType.ENGLISH)
                case "French":
                    languagesCanTeach?.addLanguage(Languages.LangType.FRENCH)
                case "Spanish":
                    languagesCanTeach?.addLanguage(Languages.LangType.SPANISH)
                case "Chinese":
                    languagesCanTeach?.addLanguage(Languages.LangType.CHINESE)
                default: ()
                }
            }
        }
    }
    
    func toString() -> String{
        return "User: { [id: \(self.id)] [First Name: \(self.firstName)] [Last Name: \(self.lastName)] [Phone: \(self.phoneNumber)] [About: \(self.about)] [Country: \(self.location?.country)] [Location: \(self.location?.loc)] [Timezone: \(self.location?.timeZone)] [Rewards: \(self.rewards)]"
    }
}

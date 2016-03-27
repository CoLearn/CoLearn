//
//  CoLearnClient.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class CoLearnClient: NSObject {
    
    static let UserClass = "user"
    static let ScheduleClass = "schedule"
    static let teachSpanishClass = "teachSpanish"
    static let teachEnglishClass = "teachEnglish"
    static let teachFrenchClass = "teachFrench"
    static let teachChineseClass = "teachChinese"
    static let learnSpanishClass = "learnSpanish"
    static let learnEnglishClass = "learnEnglish"
    static let learnFrenchClass = "learnFrench"
    static let learnChineseClass = "learnChinese"

    static let LanguagesToLearnClass = "langtolearn"
    
    
    /*------------------------------ User Information - Start ----------------------------------------*/
    // Get the User Information from Facebook, using Graph Request.
    class func getUserInfoFromFacebook(success: (User?) -> (), failure: (NSError?) -> () ) {
        let params = ["fields":"id, name, first_name, last_name, picture, cover, locale, location, timezone"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                print("UserInfo From Facebook: " , result)
                let user:User = User()
                user.userInfo = result
                success(user)
            } else {
                print(error.localizedDescription)
                failure(error)
            }
        }
    }

    // Post User Information to the table.
    class func postUserInfo(user: User, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: UserClass)
        
        post["user_id"] = user.id
        if let phoneNumber = user.phoneNumber {
            post["phoneNumber"] = phoneNumber
        } else {
            post["phoneNumber"] = "(+XX XXX XXX XXXX)"
        }
        if let about = user.about {
            post["about"] = about
        }
        if let location = user.location {
            post["country"] = location.country
            post["timezone"] = location.timeZone
            if let city = location.city {
                post["city"] = city
            } else {
                post["city"] = "---------"
            }
            if let state = location.state {
                post["state"] = state
            } else {
                post["state"] = "------"
            }
        }
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    // UserData from the DB is retrieved based on Id and PFObject is returned.
    class func getUserDataFromDB(id: String, success: (PFObject?) -> (), failure: (NSError?) -> ()) {
        
        let keys = ["phoneNumber","about","country","state","timezone","city","author"]
        let query = PFQuery(className: UserClass)
        query.includeKeys(keys)
        query.whereKey("user_id", equalTo: id)
        
        query.getFirstObjectInBackgroundWithBlock { (userInfo: PFObject?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(userInfo)
            }
        }
    }
    
    // Update the User Information on DB.
    class func updateUserDataOnDB(user: User, status: (NSError?) -> (), withCompletion completion: PFBooleanResultBlock?) {
        
        let keys = ["phoneNumber","about","country","state","timezone","city","author"]
        let query = PFQuery(className: UserClass)
        query.includeKeys(keys)
        query.whereKey("user_id", equalTo: user.id)
        
        query.getFirstObjectInBackgroundWithBlock { (userInfo: PFObject?, error: NSError?) in
            if error != nil {
                status(error)
            } else {
                if let userInfo = userInfo {
                    userInfo["phoneNumber"] = user.phoneNumber
                    userInfo["about"] = user.about
                    userInfo["country"] = user.location?.country
                    userInfo["state"] = user.location?.state
                    userInfo["timezone"] = user.timeZone
                    userInfo["city"] = user.location?.city
                    userInfo.saveInBackgroundWithBlock(completion)
                }
            }
        }
    }
    /*------------------------------ User Information - Start ----------------------------------------*/
    
    /* ---------------------- Post the Languages chosen to Teach to DB - Start ----------------------------------*/
    class func postLanguagesToTeach(langToTeach: LanguagesChosen, withCompletion completion: PFBooleanResultBlock?) {
        
        for lang in langToTeach.lanuages {
            switch lang {
                case .CHINESE:
                    postLanguageCanTeach(lang, className: teachChineseClass, id: langToTeach.id)
                case .ENGLISH:
                    postLanguageCanTeach(lang, className: teachEnglishClass, id: langToTeach.id)
                case .FRENCH:
                    postLanguageCanTeach(lang, className: teachFrenchClass, id: langToTeach.id)
                case .SPANISH:
                    postLanguageCanTeach(lang, className: teachSpanishClass, id: langToTeach.id)
            }
        }

    }
    
    private class func postLanguageCanTeach(lang: Languages.LangType, className: String, id: String) {
        
        var userList = id
        
        //Get the current list of users to check if the user is already in the list.
        getUsersCanTeachForALangauge(lang, success: { (users: String?) in
            if users?.characters.count > 0 {
                // If User is not in the list already
                if !((users?.containsString(id))!) {
                    userList += ",\(users)"
                    let post = PFObject(className: className)
                    post["users"] = userList
                    post.saveInBackground()
                }
            } else { // new list and now users found.
                let post = PFObject(className: className)
                post["users"] = userList
                post.saveInBackground()
            }
        }) { (error: NSError?) in
            print(error?.localizedDescription)
        }
    }
    
    private class func getUsersCanTeachForALangauge(langType: Languages.LangType, success: (String?) -> (), failure: (NSError?) -> ()){
        
        //Class Name
        var className = teachEnglishClass
        switch langType {
        case .CHINESE:
            className = teachChineseClass
        case .ENGLISH:
            className = teachEnglishClass
        case .FRENCH:
            className = teachFrenchClass
        case .SPANISH:
            className = teachSpanishClass
        }
        
        
        // Query
        let query = PFQuery(className: className)
        query.includeKey("users")
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                if let posts = posts {
                    print(posts)
                    let users = posts[0]["users"] as? String
                    print(users)
                    success(users)
                }
                success("")
            }
        }
    }
    /* ---------------------- Post the Languages chosen to Teach to DB - End ----------------------------------*/
    
    
    /* ---------------------- Post the Languages Chosen to Learn to DB - Start ----------------------------------*/
    class func postLanguagesToLearn(langToLearn: LanguagesChosen, withCompletion completion: PFBooleanResultBlock?) {
        
        for lang in langToLearn.lanuages {
            switch lang {
                case .CHINESE:
                    postLanguageToLearn(lang, className: learnChineseClass, id: langToLearn.id)
                case .ENGLISH:
                    postLanguageToLearn(lang, className: learnEnglishClass, id: langToLearn.id)
                case .FRENCH:
                    postLanguageToLearn(lang, className: learnFrenchClass, id: langToLearn.id)
                case .SPANISH:
                    postLanguageToLearn(lang, className: learnSpanishClass, id: langToLearn.id)
            }
        }
    }
    
    private class func postLanguageToLearn(lang: Languages.LangType, className: String, id: String) {
        
        var userList = id
        
        //Get the current list of users to check if the user is already in the list.
        getUsersToLearnALanguage(lang, success: { (users: String?) in
            if users?.characters.count > 0 {
                // If User is not in the list already
                if !((users?.containsString(id))!) {
                    userList += ",\(users)"
                    let post = PFObject(className: className)
                    post["users"] = userList
                    post.saveInBackground()
                }
            } else { // new list and now users found.
                let post = PFObject(className: className)
                post["users"] = userList
                post.saveInBackground()
            }
        }) { (error: NSError?) in
                print(error?.localizedDescription)
        }
        
    }
    
    private class func getUsersToLearnALanguage(langType: Languages.LangType, success: (String?) -> (), failure: (NSError?) -> ()){
        
        // ClassName
        var className = learnEnglishClass
        switch langType {
        case .CHINESE:
            className = learnChineseClass
        case .ENGLISH:
            className = learnEnglishClass
        case .FRENCH:
            className = learnFrenchClass
        case .SPANISH:
            className = learnSpanishClass
        }
        
        //Query
        let query = PFQuery(className: className)
        query.includeKey("users")
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                if let posts = posts {
                    print(posts)
                    let users = posts[0]["users"] as? String
                    print(users)
                    success(users)
                }
                success("")
            }
        }
    }
    
    /* ---------------------- Post the Languages Chosen to Learn to DB - End ----------------------------------*/
    
    /* ---------------------------------------------- Schedules - Start ----------------------------------*/
    
    // Add a single schedule to DB.
    class func addASchedule(schedule: Schedule, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: ScheduleClass)
        post["user_id"] = schedule.user_id
        post["instructor_id"] = schedule.instructor_id
        post["language"] = schedule.language.getName()
        post["time"] = schedule.time.description
        post["timezone"] = schedule.timezone.abbreviation
        post["request_note"] = schedule.requestNote
        post["response_note"] = schedule.responseNote
        post["status"] = schedule.scheduleStatus.getName()
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    // Retrives all the schedules of the current user
    class func getSchedules(userId: String, success: ([PFObject]?) -> (), failure: (NSError?) -> ()) {
        
        let keys = ["author", "instructor_id", "language", "time", "timezone","request_note", "response_note","status"]
        let query = PFQuery(className: ScheduleClass)
        query.whereKey("user_id", equalTo: userId)
        query.whereKey("status", containedIn: [Constants.APPROVED, Constants.PENDING, Constants.REJECTED])
        query.includeKeys(keys)
        
        query.findObjectsInBackgroundWithBlock { (schedulesInfo: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(schedulesInfo)
            }
        }
    }
    
    // Updating the schedule of the current user
    class func updateScheduleStatus(sch_id : String, newStatus: ScheduleStatus.status, withCompletion completion: PFBooleanResultBlock?) {
        
        let key = "status"
        let query = PFQuery(className: ScheduleClass)
        query.whereKey("sch_id", equalTo: sch_id)
        query.includeKey(key)
        
        query.getFirstObjectInBackgroundWithBlock { (schedule: PFObject?, error: NSError?) in
            if error == nil {
                if let schedule = schedule {
                    schedule["status"] = newStatus.getName()
                    schedule.saveInBackgroundWithBlock(completion)
                } else {
                    print("Unable to update the Schedule \(sch_id)")
                }
            }
        }
        
    }
    /* ---------------------------------------------- Schedules - Start ----------------------------------*/
}

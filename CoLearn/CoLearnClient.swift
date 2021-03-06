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
    static let LangCanTeachClass = "LanguagesCanTeach"
    static let LangToLearnClass = "LanguagesToLearn"
    static var sharedInstance: CoLearnClient?
    
    override init(){
        super.init()
        CoLearnClient.sharedInstance = self
    }
    
    /*------------------------------ User Information - Start ----------------------------------------*/


    // Post User Information to the table.
    class func postUserInfo(user: User, withCompletion completion: PFBooleanResultBlock?) {
        
        // Save a new User if the user doesn't exist
        isUserAlreadySaved(user.id) { (status: Bool?) in
            if let status = status {
                if status == false {
                    let post = PFObject(className: UserClass)
                    
                    post["user_id"] = user.id
                    if let phoneNumber = user.phoneNumber {
                        post["phoneNumber"] = phoneNumber
                    } else {
                        post["phoneNumber"] = ""
                    }
                    if let about = user.about {
                        post["about"] = about
                    } else {
                        post["about"] = ""
                    }
                    if let location = user.location {
                        post["country"] = location.country
                        post["timezone"] = location.timeZone
                        if let loc = location.loc {
                            post["loc"] = loc
                        } else {
                            post["loc"] = ""
                        }
                    } else {
                        post["country"] = ""
                        post["timezone"] = ""
                        post["loc"] = ""
                    }
                    
                    if let name = user.fullName {
                        post["name"] = name
                    } else {
                        post["name"] = ""
                    }
                    
                    post.saveInBackgroundWithBlock(completion)
                }
            }
        }
        
    }
    
    // UserData from the DB is retrieved based on Id and PFObject is returned.
    class func getUserDataFromDB(id: String, success: (PFObject?) -> (), failure: (NSError?) -> ()) {

//        let keys = ["phoneNumber","about","country","state","timezone","city","author"]
        let query = PFQuery(className: UserClass)
//        query.includeKeys(keys)

        query.whereKey("user_id", equalTo: id)
        
        query.getFirstObjectInBackgroundWithBlock { (userInfo: PFObject?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(userInfo)
            }
        }
    }
    
    // Get the UserInfo of Multiple users
    class func getAllUserDataFromDB(ids: [String], success: ([PFObject]?) -> (), failure: (NSError?) -> ()) {
        
        let query = PFQuery(className: UserClass)
        query.whereKey("user_id", containedIn: ids)
        
        query.findObjectsInBackgroundWithBlock { (userInfo: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(userInfo)
            }
        }
        
    }
    
    // Update the User Information on DB.
    class func updateUserDataOnDB(user: User, status: (NSError?) -> (), withCompletion completion: PFBooleanResultBlock?) {
        
        let query = PFQuery(className: UserClass)
        query.whereKey("user_id", equalTo: user.id)
        
        query.getFirstObjectInBackgroundWithBlock { (userInfo: PFObject?, error: NSError?) in
            if error != nil {
                status(error)
            } else {
                if let userInfo = userInfo {
                    if let phoneNum = user.phoneNumber {
                        userInfo["phoneNumber"] = phoneNum as String
                    }
                    if let name = user.fullName {
                        userInfo["name"] = name as String
                    }
                    if let about = user.about {
                        userInfo["about"] = about as String
                    }
                    if let country = user.location?.country {
                        userInfo["country"] = country as String
                    }
                    if let location = user.location?.loc {
                        userInfo["loc"] = location as String
                    }
                    if let timeZone = user.timeZone {
                        userInfo["timezone"] = timeZone as String
                    }
                    userInfo.saveInBackgroundWithBlock(completion)
                }
            }
        }
    }
    
    class func isUserAlreadySaved(id: String, success: (Bool?) -> ()) {
        getUserDataFromDB(id, success: { (user: PFObject?) in
            if user == nil {
                success(false)
            } else {
                success(true)
            }
        }) { (error: NSError?) in
            success(false)
        }

    }
    
    class func getUsersWithFollowingIDs(ids: [String], success: ([PFObject]?) -> (), failure: (NSError?) -> ()) {
        
        let keys = ["phoneNumber","about","country","state","timezone","city","author"]
        let query = PFQuery(className: UserClass)
        query.includeKeys(keys)
        query.whereKey("user_id", containedIn: ids)
        
        query.findObjectsInBackgroundWithBlock { (userInfo: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(userInfo)
            }
        }
    }
     /*------------------------------ User Information - Start ----------------------------------------*/
    
    /* ---------------------- Post the Languages chosen to Teach to DB - Start ----------------------------------*/
    class func postLanguagesToTeach(langToTeach: Languages.LangType, user_id: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: LangCanTeachClass)
        post["user_id"] = user_id
        post["lang"] = langToTeach.getName()
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    class func removeLanguagesToTeach(langToTeach: Languages.LangType, user_id: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let query = PFQuery(className: LangCanTeachClass)
        query.whereKey("lang", equalTo: langToTeach.getName())
        query.whereKey("user_id", equalTo: user_id)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                for object in objects! {
                    object.deleteInBackgroundWithBlock(completion)
                }
            } else {
                print("Error finding object to remove: \(error?.localizedDescription)")
            }
        }
    }
    
    // All the users that can teach a specific langauge
    class func getUsersCanTeachForALangauge(langType: Languages.LangType, success: ([PFObject]?) -> (), failure: (NSError?) -> ()){
        
        // Query
        let query = PFQuery(className: LangCanTeachClass)

        query.whereKey("lang", equalTo: langType.getName())
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {

                success(posts)
            }
        }

    }
    
    // Languages a User can Teach
    class func getLanguagesCanTeachByAnUser(user_id: String, success: ([PFObject]?) -> (), failure: (NSError?) -> ()){
        
        //Query
        let query = PFQuery(className: LangCanTeachClass)
//        query.includeKey("lang")
        query.whereKey("user_id", equalTo: user_id)
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(posts)
            }
        }
    }
    
    /* ---------------------- Post the Languages chosen to Teach to DB - End ----------------------------------*/
    
    
    /* ---------------------- Post the Languages Chosen to Learn to DB - Start ----------------------------------*/
    class func postLanguagesToLearn(langToTeach: Languages.LangType, user_id: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = PFObject(className: LangToLearnClass)
        post["user_id"] = user_id
        post["lang"] = langToTeach.getName()
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    // All the users that want to learn a specific langauge
    class func getUsersToLearnALanguage(langType: Languages.LangType, success: ([PFObject]?) -> (), failure: (NSError?) -> ()){
        
        //Query
        let query = PFQuery(className: LangToLearnClass)

        query.whereKey("lang", equalTo: langType.getName())
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(posts)
            }
        }
    }
    
    // All the languages a user wants to learn
    class func getLanguagesToLearnByAnUser(user_id: String, success: ([PFObject]?) -> (), failure: (NSError?) -> ()){
        
        //Query
        let query = PFQuery(className: LangToLearnClass)
        query.includeKey("lang")
        query.whereKey("user_id", equalTo: user_id)
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(posts)
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
        post["time"] = schedule.time
        post["timezone"] = schedule.timezone.abbreviation
        post["request_note"] = schedule.requestNote
        post["response_note"] = schedule.responseNote
        post["status"] = schedule.scheduleStatus.getName()
        
        post.saveInBackgroundWithBlock(completion)
    }
    
    // Retrives all the schedules of the current user
    class func getSchedules(userId: String, success: ([PFObject]?) -> (), failure: (NSError?) -> ()) {
        
        let learnerQuery = PFQuery(className: ScheduleClass)
        learnerQuery.whereKey("user_id", equalTo: userId)
        learnerQuery.whereKey("status", containedIn: [Constants.APPROVED, Constants.PENDING, Constants.REJECTED])
        
        let instructorQuery = PFQuery(className: ScheduleClass)
        instructorQuery.whereKey("instructor_id", equalTo: userId)
        instructorQuery.whereKey("status", containedIn: [Constants.APPROVED, Constants.PENDING, Constants.REJECTED])
        
        let queryArray = [learnerQuery, instructorQuery]
        let mainQuery = PFQuery.orQueryWithSubqueries(queryArray)
        //mainQuery.addAscendingOrder()
        mainQuery.orderByAscending("time")
        mainQuery.findObjectsInBackgroundWithBlock { (schedulesInfo: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(schedulesInfo)
            }
        }
    }
    
    // Retrives schedules pending on current user for approval
    class func getApprovalSchedules(userId: String, success: ([PFObject]?) -> (), failure: (NSError?) -> ()) {
        
        let query = PFQuery(className: ScheduleClass)
        query.whereKey("instructor_id", equalTo: userId)
        query.whereKey("status", equalTo: Constants.PENDING)
        
        query.findObjectsInBackgroundWithBlock { (schedulesInfo: [PFObject]?, error: NSError?) in
            if error != nil {
                failure(error)
            } else {
                success(schedulesInfo)
            }
        }
    }

    
    // Updating the schedule of the current user
    class func updateScheduleStatus(sch_id : String, newStatus: ScheduleStatus.status, responseNote: String, withCompletion completion: PFBooleanResultBlock?) {
        
//      let key = "status"
        let query = PFQuery(className: ScheduleClass)
        query.whereKey("_id", equalTo: sch_id)
        print(sch_id)
//      query.includeKey(key)
        
        query.getFirstObjectInBackgroundWithBlock { (schedule: PFObject?, error: NSError?) in
            if error == nil {
                if let schedule = schedule {
                    schedule["status"] = newStatus.getName()
                    schedule["response_note"] = responseNote
                    schedule.saveInBackgroundWithBlock(completion)
                } else {
                    print("Unable to update the Schedule \(sch_id)")
                }
            }
        }
        
    }
    /* ---------------------------------------------- Schedules - Start ----------------------------------*/
}

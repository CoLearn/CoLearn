//
//  SchedulesViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/9/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import ParseUI

class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var schedulesTableView: UITableView!
    
    //var scheduledMeetings = [Meeting]()
    var scheduledMeetings = [Schedule]()
    var currentUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Schedule"
        self.schedulesTableView.reloadData()
        self.schedulesTableView.rowHeight = UITableViewAutomaticDimension
        self.schedulesTableView.estimatedRowHeight = 120
        
        //self.createSchedules()
        /*
        CoLearnClient.getUserInfoFromFacebook({ (user: User?) -> () in
            if let id = user?.id{
                self.currentUserId = id
                //print("CurrentUserId: \(self.currentUserId!)")
                
                CoLearnClient.getSchedules(currentUser?.id, success: { (schedules: [PFObject]?) -> () in
                    
                    if let receivedSchedules = schedules{
                        //print("Received schedules from server: \(schedules)")
                        //print("Adding schedules to collection")
                        
                        for s in receivedSchedules{
                            
                            let userId = s["user_id"] as! String
                            //print("userID: \(userId)")
                            
                            
                            let instructorID = s["instructor_id"] as! String
                            //print("instructorID: \(instructorID)")
                            
                            let language: Languages.LangType
                            switch(s["language"] as! String){
                                case Constants.ENGLISH: language = Languages.LangType.ENGLISH
                                case Constants.CHINESE: language = Languages.LangType.CHINESE
                                case Constants.SPANISH: language = Languages.LangType.SPANISH
                                case Constants.FRENCH: language = Languages.LangType.FRENCH
                                default: language = Languages.LangType.ENGLISH
                            }
                            //print("Language: \(language.getName())")
                            
                            // let formatter = NSDateFormatter()
                            // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                            //let time = formatter.dateFromString(s["time"] as! String)
                            var time = NSDate()
                            let timeString = s["time"] as? String
                            if let str = timeString{
                                //time = str.toDateTime()
                            }else{
                                print("Nil at time")
                            }
                            
                            print("received time: \(s["time"])")
                            print("time: \(time)")
                            
                            let timezone = NSTimeZone(name: s["timezone"] as! String)
                            print("timezone: \(timezone)")
                            
                            let reqNote = s["request_note"] as! String
                            print("reqNote: \(reqNote)")
                            
                            let resNote = s["response_note"] as! String
                            print("resNote: \(resNote)")
                            
                            let status: ScheduleStatus.status
                            switch (s["status"] as! String){
                                case Constants.PENDING: status = ScheduleStatus.status.PENDING
                                case Constants.APPROVED: status = ScheduleStatus.status.APPROVED
                                case Constants.REJECTED: status = ScheduleStatus.status.REJECTED
                                default: status = ScheduleStatus.status.PENDING
                            }
                            print("status: \(status.getName())")
                            
                            self.scheduledMeetings.append(Schedule(user_id: userId, instructor_id: instructorID, lang: language, time: time, timezone: timezone!, requestNote: reqNote, responseNote: resNote, scheduleStatus: status))
                            self.schedulesTableView.reloadData()
                            /*
                            self.scheduledMeetings.append(Schedule(userId,
                                instructor_id: s["instructor_id"] as! String,
                                lang: language,
                                time: NSDate(s["time"])!,
                                timezone: NSTimezone(s["timezone"]),
                                requestNote: s["request_note"],
                                responseNote: s["response_note"] as! String,
                                scheduleStatus: status
                            ))
                            */
                        }
                    }
                    
                    //scheduledMeetings.append
                    }) { (error: NSError?) -> () in
                        print("Error in getting schedules \(error?.localizedDescription)")
                }
            }
            }) { (error: NSError?) -> () in
                print(error?.localizedDescription)
        }
        */
        
        
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                print(currentUser?.id)
                
                CoLearnClient.getSchedules((currentUser?.id)!, success: { (schedules: [PFObject]?) in
                    if let receivedSchedules = schedules{
                        //print("Received schedules from server: \(schedules)")
                        //print("Adding schedules to collection")
                        
                        for s in receivedSchedules{
                            
                            let userId = s["user_id"] as! String
                            //print("userID: \(userId)")
                            
                            
                            let instructorID = s["instructor_id"] as! String
                            //print("instructorID: \(instructorID)")
                            
                            let language: Languages.LangType
                            switch(s["language"] as! String){
                            case Constants.ENGLISH: language = Languages.LangType.ENGLISH
                            case Constants.CHINESE: language = Languages.LangType.CHINESE
                            case Constants.SPANISH: language = Languages.LangType.SPANISH
                            case Constants.FRENCH: language = Languages.LangType.FRENCH
                            default: language = Languages.LangType.ENGLISH
                            }
                            //print("Language: \(language.getName())")
                            
                            // let formatter = NSDateFormatter()
                            // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                            //let time = formatter.dateFromString(s["time"] as! String)
                            var time = NSDate()
                            let timeString = s["time"] as? String
                            if let str = timeString{
                                //time = str.toDateTime()
                            }else{
                                print("Nil at time")
                            }
                            
                            print("received time: \(s["time"])")
                            print("time: \(time)")
                            
                            let timezone = NSTimeZone(name: s["timezone"] as! String)
                            print("timezone: \(timezone)")
                            
                            let reqNote = s["request_note"] as! String
                            print("reqNote: \(reqNote)")
                            
                            let resNote = s["response_note"] as! String
                            print("resNote: \(resNote)")
                            
                            let status: ScheduleStatus.status
                            switch (s["status"] as! String){
                            case Constants.PENDING: status = ScheduleStatus.status.PENDING
                            case Constants.APPROVED: status = ScheduleStatus.status.APPROVED
                            case Constants.REJECTED: status = ScheduleStatus.status.REJECTED
                            default: status = ScheduleStatus.status.PENDING
                            }
                            print("status: \(status.getName())")
                            
                            self.scheduledMeetings.append(Schedule(user_id: userId, instructor_id: instructorID, lang: language, time: time, timezone: timezone!, requestNote: reqNote, responseNote: resNote, scheduleStatus: status))
                            self.schedulesTableView.reloadData()
                            /*
                             self.scheduledMeetings.append(Schedule(userId,
                             instructor_id: s["instructor_id"] as! String,
                             lang: language,
                             time: NSDate(s["time"])!,
                             timezone: NSTimezone(s["timezone"]),
                             requestNote: s["request_note"],
                             responseNote: s["response_note"] as! String,
                             scheduleStatus: status
                             ))
                             */
                        }
                    }
                }) { (error: NSError?) in
                    print("Error in getting schedules \(error?.localizedDescription)")
                }
                
            }
        }) { (error: NSError?) in
            print(error?.localizedDescription)
        }
        /*
        */

        
        /*
        print("Inside viewDidLoad of schedules")
        scheduledMeetings.append(Meeting(language: "Spanish" , mtime: "Apr 1st, 2016 @7:30am", instructor: "Rahul Vasantham", learner: "Caleb Ripley", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeetings.append(Meeting(language: "German" , mtime: " Jun 23rd, 2016 @6pm", instructor: "Rahul Vasantham", learner: "Timothy Lee", requestNote: "I want to learn german"))
        scheduledMeetings.append(Meeting(language: "Italian" , mtime: "Sept 19th, 2016 @1pm", instructor: "Rahul Vasantham", learner: "Charlie Hieger", requestNote: "Can you help me in learning Italian? I won't take much of your time Rahul Sir. Let me know please."))
        scheduledMeetings.append(Meeting(language: "Japanese" , mtime: "Dec 31st, 2016 @12noon", instructor: "Rahul Vasantham", learner: "Sachin Gandhi", requestNote: "I wish to learn spanish please spare some time"))
        */
        
        self.schedulesTableView.dataSource = self
        self.schedulesTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.schedulesTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    
    func createSchedules(){
        // CoLearn: 123042818089530
        // Satyam: 1265123510169659
        let s = Schedule(user_id: "10153818548450873", instructor_id: "123042818089530", lang: Languages.LangType.FRENCH, time: NSDate(), timezone: NSTimeZone.localTimeZone(), requestNote: "Visit to France soon. It would be of great help to me if spare some time", responseNote: "", scheduleStatus: ScheduleStatus.status.PENDING)
        
        CoLearnClient.addASchedule(s) { (b: Bool, error: NSError?) -> Void in
            if let e = error{
                print("Error in adding schedule \(e.localizedDescription)")
            }
            
            if b{
                print("Boolean of completion is true")
            }else{
                print("Boolean of completion is false")
            }
        }
    }

    @IBAction func onClick(sender: AnyObject) {
        
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                CoLearnClient.postUserInfo(user, withCompletion: { (status: Bool, error: NSError?) in
                    if status {
                        print("successfully posted")
                    }
                })
            }
        }) { (error: NSError?) in
            print(error?.localizedDescription)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleTableViewCell", forIndexPath: indexPath) as? ScheduleTableViewCell
        //ScheduleTableViewCell()
        cell?.schedule = self.scheduledMeetings[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scheduledMeetings.count != 0{
            return self.scheduledMeetings.count
        }else{
            return 0
        }

    }
    
    func onRefreshAction(refreshControl: UIRefreshControl){
        self.schedulesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ApprovalsSegue" {
            let dvc = segue.destinationViewController as! ApprovalsViewController
            //dvc.parentMeetings = self.scheduledMeetings
        }
    }
}

extension String
{
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

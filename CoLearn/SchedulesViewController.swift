//
//  SchedulesViewController.swift
//  CoLearn
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import ParseUI

class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var schedulesTableView: UITableView!
    
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
        
        self.schedulesTableView.dataSource = self
        self.schedulesTableView.delegate = self
        
        self.populateScheduleTable()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.schedulesTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    func populateScheduleTable(){
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                //print(currentUser?.id)
                
                CoLearnClient.getSchedules((currentUser?.id)!, success: { (schedules: [PFObject]?) in
                    if let receivedSchedules = schedules{
                        
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
                            
                            var time = NSDate()
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            
                            if let dateString = s["time"] as? String{
                                //print("s[\"time\"] successfully converted to string")
                                if let d = formatter.dateFromString(dateString){
                                    time = d
                                }else{
                                    print("formatter error")
                                }
                            }else{
                                print("error while converting s[\"time\"] to string")
                            }
                            
                            
                            print("received time: \(s["time"])")
                            print("formatted time: \(time)")
                            
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
                        }
                    }
                    }) { (error: NSError?) in
                        print("Error in getting schedules \(error?.localizedDescription)")
                }
                
            }
            }) { (error: NSError?) in
                print(error?.localizedDescription)
        }
    }
    
    func createSchedules(){
        // CoLearn: 123042818089530
        // Satyam: 1265123510169659
        // Caleb: 10153818548450873
        
        //2016-04-14T14:22:43+0000
        //yyyy-MM-dd'T'HH:mm:ssZ
        
        var scheduleTime: NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        scheduleTime = formatter.dateFromString("2016-05-14T14:30:00+0000")!
        
        let s = Schedule(user_id: "1265123510169659", instructor_id: "10153818548450873", lang: Languages.LangType.ENGLISH, time: scheduleTime, timezone: NSTimeZone.localTimeZone(), requestNote: "Need help for GRE and TOEFL exams. Speaking to a native speaker would create a major impact.", responseNote: "", scheduleStatus: ScheduleStatus.status.PENDING)
        
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
/*
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
*/
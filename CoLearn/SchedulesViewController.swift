//
//  SchedulesViewController.swift
//  CoLearn
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import ParseUI
import SVProgressHUD

class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var schedulesTableView: UITableView!
    
    static var scheduledMeetings = [Schedule]()
    var currentUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        schedulesTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        self.title = "Schedule"
        // print("inside schedules view controller view did load")
        
        self.schedulesTableView.rowHeight = UITableViewAutomaticDimension
        self.schedulesTableView.estimatedRowHeight = 120
        
        //self.createSchedules()
        
        self.schedulesTableView.dataSource = self
        self.schedulesTableView.delegate = self
        
        self.populateScheduleTable()
        self.schedulesTableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.schedulesTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        // print("inside view did appear")
        self.schedulesTableView.reloadData()
    }
    
    
    func populateScheduleTable(){
        self.schedulesTableView.backgroundView?.hidden = true
        SVProgressHUD.showWithStatus("Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        //SVProgressHUD.showWithStatus("Loading...")
        
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                //print(currentUser?.id)
                
                CoLearnClient.getSchedules((currentUser?.id)!, success: { (schedules: [PFObject]?) in
                    if let receivedSchedules = schedules{
                        SchedulesViewController.scheduledMeetings = []
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
                            
                            if let datetime = (s["time"]) as? NSDate{
                                time = datetime
                            }else{
                                print("Conversion to nsdate failed")
                            }
                            
                            let timezone = NSTimeZone(name: s["timezone"] as! String)
                            
                            let reqNote = s["request_note"] as! String
                            
                            let resNote = s["response_note"] as! String
                            
                            let status: ScheduleStatus.status
                            switch (s["status"] as! String){
                            case Constants.PENDING: status = ScheduleStatus.status.PENDING
                            case Constants.APPROVED: status = ScheduleStatus.status.APPROVED
                            case Constants.REJECTED: status = ScheduleStatus.status.REJECTED
                            default: status = ScheduleStatus.status.PENDING
                            }
                            
                            var schId = ""
                            if let schedule_id = s.objectId{
                                schId = schedule_id
                            }
                            
                            let s = Schedule(sch_id: schId, user_id: userId, instructor_id: instructorID, lang: language, time: time, timezone: timezone!, requestNote: reqNote, responseNote: resNote, scheduleStatus: status)
                        
                            let callMinutesLapse = NSCalendar.currentCalendar().components(.Minute, fromDate: s.time, toDate: NSDate(), options: []).minute
                            //print("Lapse minutes \(callMinutesLapse)")
                            
                            if callMinutesLapse <= 60{
                                SchedulesViewController.scheduledMeetings.append(s)
                            }
                        }
                        
                        SVProgressHUD.dismiss()
                        self.schedulesTableView.reloadData()
                    }
                    }) { (error: NSError?) in
                        SVProgressHUD.dismiss()
                        print("Error in getting schedules \(error?.localizedDescription)")
                }
                
            }
            }) { (error: NSError?) in
                SVProgressHUD.dismiss()
                print(error?.localizedDescription)
        }
    }
    
    func createSchedules(){
        // CoLearn: 123042818089530
        // Satyam: 1265123510169659
        // Caleb: 10153818548450873
        
        //2016-04-14T14:22:43+0000
        //yyyy-MM-dd'T'HH:mm:ssZ
        
        //let scheduleTime: NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //scheduleTime = formatter.dateFromString("2016-12-24T05:30:00+0000")!
        
        let s = Schedule(user_id: "10153818548450873", instructor_id: "1265123510169659", lang: Languages.LangType.SPANISH, time: NSDate(), timezone: NSTimeZone.localTimeZone(), requestNote: "I want to experience the tomatino festival", responseNote: "", scheduleStatus: ScheduleStatus.status.PENDING)
        CoLearnClient.addASchedule(s) { (b: Bool, error: NSError?) -> Void in
            if let e = error{
                print("Error in adding schedule \(e.localizedDescription)")
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
        cell?.schedule = SchedulesViewController.scheduledMeetings[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SchedulesViewController.scheduledMeetings.count != 0{
            return SchedulesViewController.scheduledMeetings.count
        }else{
            self.schedulesTableView.backgroundView?.hidden = false
            let emptyMessage = UILabel()
            emptyMessage.text = "You have no scheduled appointments. Use Add button to schedule one!"
            emptyMessage.textAlignment = NSTextAlignment.Center
            self.schedulesTableView.backgroundView = emptyMessage
            self.schedulesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }

    }
    
    func onRefreshAction(refreshControl: UIRefreshControl){
        self.populateScheduleTable()
        self.schedulesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ApprovalsSegue" {
            let dvc = segue.destinationViewController as! ApprovalsViewController
            //dvc.parentMeetings = self.scheduledMeetings
        }
    }*/
}
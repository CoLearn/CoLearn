//
//  ApprovalsViewController.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import SWTableViewCell
import ParseUI

class ApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {

    @IBOutlet var approvalsTableView: UITableView!
    
    var approvalMeetings:[Schedule] = []
    //var pendingApprovalMeetings = [Meeting]()
    //var parentMeetings: [Meeting]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.approvalsTableView.delegate = self
        self.approvalsTableView.dataSource = self
        self.approvalsTableView.rowHeight = UITableViewAutomaticDimension
        self.approvalsTableView.estimatedRowHeight = 120
        self.populateApprovalsTable()
    }
    
    func populateApprovalsTable(){
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                //print(currentUser?.id)
                
                CoLearnClient.getApprovalSchedules((currentUser?.id)!, success: { (schedules: [PFObject]?) in
                    if let receivedSchedules = schedules{
                        
                        for s in receivedSchedules{
                            print("Received approval schedule \(s)")
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
                            
                            self.approvalMeetings.append(Schedule(user_id: userId, instructor_id: instructorID, lang: language, time: time, timezone: timezone!, requestNote: reqNote, responseNote: resNote, scheduleStatus: status))
                            self.approvalsTableView.reloadData()
                        }
                    }
                    }) { (error: NSError?) in
                        print("Error in getting approval schedules \(error?.localizedDescription)")
                }
                
            }
            }) { (error: NSError?) in
                print(error?.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalsTableViewCell", forIndexPath: indexPath) as? ApprovalsTableViewCell
        
        
        //ScheduleTableViewCell()
        cell!.delegate = self
        let leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Decline")
        
        let rightUtilityButtons: NSMutableArray = []
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Accept")
        
        cell!.leftUtilityButtons = leftUtilityButtons as [AnyObject]
        cell!.rightUtilityButtons = rightUtilityButtons as [AnyObject]
        
        //cell?.pendingApprovalMeeting = self.pendingApprovalMeetings[indexPath.row]
        cell?.pendingApprovalMeeting = self.approvalMeetings[indexPath.row]
        cell?.index = indexPath.row
        return cell!
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        
        let cellIndex = self.approvalsTableView.indexPathForCell(cell)
        self.approvalMeetings.removeAtIndex((cellIndex?.row)!)
        self.approvalsTableView.deleteRowsAtIndexPaths([cellIndex!], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let cellIndex = self.approvalsTableView.indexPathForCell(cell)
        self.approvalMeetings.removeAtIndex((cellIndex?.row)!)
        self.approvalsTableView.deleteRowsAtIndexPaths([cellIndex!], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.approvalMeetings.count != 0{
            return self.approvalMeetings.count
        }else{
            return 0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

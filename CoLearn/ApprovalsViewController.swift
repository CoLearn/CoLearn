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
import SVProgressHUD

class ApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UITextFieldDelegate {

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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.approvalsTableView.insertSubview(refreshControl, atIndex: 0)
        hideKeyboardOnTapOutside()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func onRefreshAction(refreshControl: UIRefreshControl){
        self.populateApprovalsTable()
        self.approvalsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func populateApprovalsTable(){

        for s in SchedulesViewController.scheduledMeetings{
            if (s.instructor_id == currentUser!.id && s.scheduleStatus.getName() == Constants.PENDING){
                self.approvalMeetings.append(s)
            }
        }
        /*
        SVProgressHUD.showWithStatus("Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Clear)
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                //print(currentUser?.id)
        
                CoLearnClient.getApprovalSchedules((currentUser?.id)!, success: { (schedules: [PFObject]?) in
                    if let receivedSchedules = schedules{
                        self.approvalMeetings = []
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
                            
                            var schedule_id = "unknown"
                            if let sch_id = s.objectId{
                                schedule_id = sch_id
                            }else{
                                print("Error in getting schedule id")
                            }
                            self.approvalMeetings.append(Schedule(sch_id: schedule_id, user_id: userId, instructor_id: instructorID, lang: language, time: time, timezone: timezone!, requestNote: reqNote, responseNote: resNote, scheduleStatus: status))
                        }
                        SVProgressHUD.dismiss()
                        self.approvalsTableView.reloadData()
                    }
                    }) { (error: NSError?) in
                        print("Error in getting approval schedules \(error?.localizedDescription)")
                }

            }
            }) { (error: NSError?) in
                print(error?.localizedDescription)
        }*/
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
        cell?.feedbackCommentTextField.delegate = self
        return cell!
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        
        let cellIndex = self.approvalsTableView.indexPathForCell(cell)
        
        let tableCell = self.approvalsTableView.cellForRowAtIndexPath(cellIndex!) as? ApprovalsTableViewCell
        
        var user_reponse = ""
        if let respone  = tableCell?.responseNoteTextField.text{
            print("User respone: \(respone)")
            user_reponse = respone
        }else{
            print("No user response")
        }
        
        if let schedueId = self.approvalMeetings[(cellIndex?.row)!].sch_id{
            CoLearnClient.updateScheduleStatus(schedueId, newStatus: ScheduleStatus.status.REJECTED, responseNote: user_reponse) { (Bool, error: NSError?) -> Void in
                if (Bool && (error == nil)){
                    self.approvalMeetings[(cellIndex?.row)!].scheduleStatus = ScheduleStatus.status.REJECTED
                    self.approvalMeetings[(cellIndex?.row)!].responseNote = user_reponse
                    self.approvalMeetings.removeAtIndex((cellIndex?.row)!)
                    self.approvalsTableView.deleteRowsAtIndexPaths([cellIndex!], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.approvalsTableView.reloadData()
                }else{
                    print("Error while updating the schedule status")
                }
            }
        }else{
            print("Can't update. No schedule id")
        }
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let cellIndex = self.approvalsTableView.indexPathForCell(cell)
        
        let tableCell = self.approvalsTableView.cellForRowAtIndexPath(cellIndex!) as? ApprovalsTableViewCell
        
        var user_reponse = ""
        if let respone  = tableCell?.responseNoteTextField.text{
            print("User respone: \(respone)")
            user_reponse = respone
        }else{
            print("No user response")
        }
        
        if let schedueId = self.approvalMeetings[(cellIndex?.row)!].sch_id{
            CoLearnClient.updateScheduleStatus(schedueId, newStatus: ScheduleStatus.status.APPROVED, responseNote: user_reponse) { (Bool, error: NSError?) -> Void in
                if (Bool && (error == nil)){
                    self.approvalMeetings[(cellIndex?.row)!].scheduleStatus = ScheduleStatus.status.APPROVED
                    self.approvalMeetings[(cellIndex?.row)!].responseNote = user_reponse
                    self.approvalMeetings.removeAtIndex((cellIndex?.row)!)
                    self.approvalsTableView.deleteRowsAtIndexPaths([cellIndex!], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.approvalsTableView.reloadData()
                }else{
                    print("Error while updating the schedule status")
                }
            }
        }else{
            print("Can't update. No schedule id")
        }
        
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

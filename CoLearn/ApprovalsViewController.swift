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

class ApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {

    @IBOutlet var approvalsTableView: UITableView!
    
    var approvalMeetings:[Schedule] = []
    
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
    }
    
    func onRefreshAction(refreshControl: UIRefreshControl){
        self.populateApprovalsTable()
        self.approvalsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func populateApprovalsTable(){
        self.approvalsTableView.backgroundView?.hidden = true
        for s in SchedulesViewController.scheduledMeetings{
            if (s.instructor_id == currentUser!.id && s.scheduleStatus.getName() == Constants.PENDING){
                self.approvalMeetings.append(s)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.approvalMeetings.count != 0{
            return self.approvalMeetings.count
        }else{
            self.approvalsTableView.backgroundView?.hidden = false
            let emptyMessage = UILabel()
            emptyMessage.text = "You have answered to all requests!"
            emptyMessage.textAlignment = NSTextAlignment.Center
            self.approvalsTableView.backgroundView = emptyMessage
            self.approvalsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalsTableViewCell", forIndexPath: indexPath) as? ApprovalsTableViewCell
        
        cell!.delegate = self
        let leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Decline")
        
        let rightUtilityButtons: NSMutableArray = []
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Accept")
        
        cell!.leftUtilityButtons = leftUtilityButtons as [AnyObject]
        cell!.rightUtilityButtons = rightUtilityButtons as [AnyObject]
        
        cell?.pendingApprovalMeeting = self.approvalMeetings[indexPath.row]
        cell?.index = indexPath.row
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

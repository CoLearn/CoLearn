//
//  ApprovalsViewController.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class ApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var approvalsTableView: UITableView!
    
    var pendingApprovalMeetings = [Meeting]()
    var parentMeetings: [Meeting]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.approvalsTableView.delegate = self
        self.approvalsTableView.dataSource = self
        
        self.title = "Approvals"
        pendingApprovalMeetings.append(Meeting(language: "Spanish" , mtime: "Apr 1st, 2016 @7:30am", instructor: "Rahul Vasantham", learner: "Caleb Ripley", requestNote: "I wish to learn spanish. Please spare some time for me"))
        pendingApprovalMeetings.append(Meeting(language: "German" , mtime: " Jun 23rd, 2016 @6pm", instructor: "Rahul Vasantham", learner: "Timothy Lee", requestNote: "I want to learn german"))
        pendingApprovalMeetings.append(Meeting(language: "Italian" , mtime: "Sept 19th, 2016 @1pm", instructor: "Rahul Vasantham", learner: "Charlie Hieger", requestNote: "Can you help me in learning Italian? I won't take much of your time Rahul Sir. Let me know please."))
        pendingApprovalMeetings.append(Meeting(language: "Japanese" , mtime: "Dec 31st, 2016 @12noon", instructor: "Rahul Vasantham", learner: "Sachin Gandhi", requestNote: "I wish to learn spanish please spare some time"))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("onRightSwipe:"))
        rightSwipe.direction = .Right
        self.approvalsTableView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("onLeftSwipe:"))
        rightSwipe.direction = .Left
        self.approvalsTableView.addGestureRecognizer(leftSwipe)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalsTableViewCell", forIndexPath: indexPath) as? ApprovalsTableViewCell
        //ScheduleTableViewCell()
        cell?.pendingApprovalMeeting = self.pendingApprovalMeetings[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pendingApprovalMeetings.count != 0{
            return self.pendingApprovalMeetings.count
        }else{
            return 0
        }
    }
    
    func onRightSwipe(gestureRecognizer: UISwipeGestureRecognizer){
        let location: CGPoint = gestureRecognizer.locationInView(self.approvalsTableView)
        
        //Get the corresponding index path within the table view
        let indexPath: NSIndexPath = self.approvalsTableView.indexPathForRowAtPoint(location)!

        //Check if index path is valid
        if(indexPath.row > -1){
            
            //Get the cell out of the table view
            let cell = self.approvalsTableView.cellForRowAtIndexPath(indexPath) as! ApprovalsTableViewCell
            self.parentMeetings?.append(cell.pendingApprovalMeeting!)
            //cell?.addMotionEffect(UIMotionEffect.delete(<#T##NSObject#>))
            
            //Update the cell or model
            self.pendingApprovalMeetings.removeAtIndex(indexPath.row)
            self.approvalsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
        
    }
    
    func onLeftSwipe(gestureRecognizer: UISwipeGestureRecognizer){
        let location: CGPoint = gestureRecognizer.locationInView(self.approvalsTableView)
        
        //Get the corresponding index path within the table view
        let indexPath: NSIndexPath = self.approvalsTableView.indexPathForRowAtPoint(location)!
        
        //Check if index path is valid
        if(indexPath.row > -1){
            
            //Get the cell out of the table view
            //let cell = self.approvalsTableView.cellForRowAtIndexPath(indexPath)
            
            //cell?.addMotionEffect(UIMotionEffect.delete(<#T##NSObject#>))
            
            //Update the cell or model
            self.pendingApprovalMeetings.removeAtIndex(indexPath.row)
            self.approvalsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
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

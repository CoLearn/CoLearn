//
//  SchedulesViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/9/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class SchedulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var schedulesTableView: UITableView!
    
    var scheduledMeetings = [Meeting]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Schedule"
        self.schedulesTableView.reloadData()
        
        print("Inside viewDidLoad of schedules")
        scheduledMeetings.append(Meeting(language: "Spanish" , mtime: "Apr 1st, 2016 @7:30am", instructor: "Rahul Vasantham", learner: "Caleb Ripley", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeetings.append(Meeting(language: "German" , mtime: " Jun 23rd, 2016 @6pm", instructor: "Rahul Vasantham", learner: "Timothy Lee", requestNote: "I want to learn german"))
        scheduledMeetings.append(Meeting(language: "Italian" , mtime: "Sept 19th, 2016 @1pm", instructor: "Rahul Vasantham", learner: "Charlie Hieger", requestNote: "Can you help me in learning Italian? I won't take much of your time Rahul Sir. Let me know please."))
        scheduledMeetings.append(Meeting(language: "Japanese" , mtime: "Dec 31st, 2016 @12noon", instructor: "Rahul Vasantham", learner: "Sachin Gandhi", requestNote: "I wish to learn spanish please spare some time"))
        
        self.schedulesTableView.dataSource = self
        self.schedulesTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.schedulesTableView.insertSubview(refreshControl, atIndex: 0)
    }

    @IBAction func onClick(sender: AnyObject) {
        
        CoLearnClient.getUserInfoFromFacebook({ (user: User?) in
            print(user?.toString())
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
            dvc.parentMeetings = self.scheduledMeetings
        }
    }
}

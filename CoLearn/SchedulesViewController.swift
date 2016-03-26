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
    
    var scheduledMeeting = [Meeting]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Schedule"
        scheduledMeeting.append(Meeting(language: "Spanish" , mtime: "Apr 1st, 2016 @7:30am", instructor: "Rahul Vasantham", learner: "Caleb Ripley", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeeting.append(Meeting(language: "German" , mtime: " Jun 23rd, 2016 @6pm", instructor: "Rahul Vasantham", learner: "Timothy Lee", requestNote: "I want to learn german"))
        scheduledMeeting.append(Meeting(language: "Italian" , mtime: "Sept 19th, 2016 @1pm", instructor: "Rahul Vasantham", learner: "Charlie Hieger", requestNote: "Can you help me in learning Italian? I won't take much of your time Rahul Sir. Let me know please."))
        scheduledMeeting.append(Meeting(language: "Japanese" , mtime: "Dec 31st, 2016 @12noon", instructor: "Rahul Vasantham", learner: "Sachin Gandhi", requestNote: "I wish to learn spanish please spare some time"))
        
        self.schedulesTableView.dataSource = self
        self.schedulesTableView.delegate = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleTableViewCell", forIndexPath: indexPath) as? ScheduleTableViewCell
        //ScheduleTableViewCell()
        cell?.schedule = self.scheduledMeeting[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scheduledMeeting.count != 0{
            return self.scheduledMeeting.count
        }else{
            return 0
        }

    }


}

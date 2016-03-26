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
        scheduledMeeting.append(Meeting(language: "Spanish" , mtime: "April 2nd, 2016", instructor: "Rahul", learner: "Caleb", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeeting.append(Meeting(language: "German" , mtime: "April 2nd, 2016", instructor: "Rahul", learner: "Caleb", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeeting.append(Meeting(language: "Italian" , mtime: "April 2nd, 2016", instructor: "Rahul", learner: "Caleb", requestNote: "I wish to learn spanish please spare some time"))
        scheduledMeeting.append(Meeting(language: "Japanese" , mtime: "April 2nd, 2016", instructor: "Rahul", learner: "Caleb", requestNote: "I wish to learn spanish please spare some time"))
        
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

//
//  RequestViewController.swift
//  CoLearn
//
//  Created by Caleb Ripley on 4/20/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var requestNoteLabel: UITextField!
    
    var user: ParseDBUser?
    var langType: Languages.LangType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hideKeyboardOnTapOutside()
        
        instructorNameLabel.text = user?.fullName
        languageLabel.text = langType?.getName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSendRequest(sender: AnyObject) {
        
        let schedule = Schedule(user_id: (currentUser?.id)!, instructor_id: (user?.userId)! , lang: self.langType!, time: dateTime.date, timezone: NSTimeZone.localTimeZone(), requestNote: requestNoteLabel.text!, responseNote: "-", scheduleStatus: ScheduleStatus.status.PENDING)
        
        CoLearnClient.addASchedule(schedule) { (status: Bool, error:NSError?) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else {
                if status {
                    print("Success : Session requested!!")
                }
            }
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

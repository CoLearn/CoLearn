//
//  SessionViewController.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 4/15/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import ParseUI

class SessionViewController: UIViewController {

    @IBOutlet weak var inTimeLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var flagPoster: UIImageView!
    
    @IBOutlet weak var attendeeLabel: UILabel!
    
    @IBOutlet weak var userRoleLabel: UILabel!
    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var requestNoteLabel: UILabel!
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var responseNoteLabel: UILabel!
    
    @IBOutlet weak var callPoster: UIImageView!
    
    var session: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nearest Call"
        self.session = SchedulesViewController.scheduledMeetings[0]
        initializeSession()
        self.updateScene()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeSession(){
        for item in SchedulesViewController.scheduledMeetings{
            if (item.scheduleStatus.getName() == Constants.PENDING && session?.instructor_id == currentUser?.id){
                self.session = item
                return
            }
        }
    }
    
    func updateScene(){
        
        if let language = session?.language.getName(){
            self.languageLabel.text = language
            
            switch language{
            case Languages.LangType.CHINESE.getName(): self.flagPoster.image = UIImage(named: "FlagOfChina")
            case Languages.LangType.ENGLISH.getName(): self.flagPoster.image = UIImage(named: "FlagOfBritain")
            case Languages.LangType.FRENCH.getName(): self.flagPoster.image = UIImage(named: "FlagOfFrance")
            case Languages.LangType.SPANISH.getName(): self.flagPoster.image = UIImage(named: "FlagOfSpain")
            default: self.flagPoster.image = UIImage(named: "FlagOfBritain")
            }
        }
        
        if currentUser?.id == self.session?.user_id{
            //self.attendeeLabel.text = self.getUserName((session?.instructor_id)!)
            self.userRoleLabel.text = "Learner"
            CoLearnClient.getUserDataFromDB((session?.instructor_id)!, success: { (user: PFObject?) -> () in
                    self.attendeeLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
        }else{
            //self.attendeeLabel.text = self.getUserName((session?.user_id)!)
            self.userRoleLabel.text = "Instructor"
            CoLearnClient.getUserDataFromDB((session?.user_id)!, success: { (user: PFObject?) -> () in
                self.attendeeLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
        }
        
        if session?.requestNote != "" {
            self.requestNoteLabel.text = session?.requestNote
        }else{
            self.requestLabel.hidden = true
            self.requestNoteLabel.hidden = true
        }
        
        if session?.responseNote != "" {
            self.responseNoteLabel.text = session?.responseNote
        }else{
            self.responseLabel.hidden = true
            self.responseNoteLabel.hidden = true
        }
        
        self.inTimeLabel.text = NSDate().offsetFrom((session?.time)!)
            
        
    }
    
    func getUserName(userId: String) -> (String){
        var name = "Unknown"
        CoLearnClient.getUserDataFromDB(userId, success: { (user: PFObject?) -> () in
            //print(user)
            if let username = user!["name"] as? String{
                name = username
            }
            }) { (error: NSError?) -> () in
                print("Error getting the user info from db \(error?.localizedDescription)")
        }
        return name
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

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

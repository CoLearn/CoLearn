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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var session: Schedule?
    var phoneNumber: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Nearest Call"
        self.session = SchedulesViewController.scheduledMeetings[0]
        initializeSession()
        self.updateScene()
        
        let tapCallPoster = UITapGestureRecognizer(target: self, action: Selector("makeFacetimeCall"))
        self.callPoster.addGestureRecognizer(tapCallPoster)
        self.callPoster.userInteractionEnabled = true
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefreshAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.scrollView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.session = SchedulesViewController.scheduledMeetings[0]
        initializeSession()
        self.updateScene()
    }
    
    func onRefreshAction(refreshControl: UIRefreshControl){
        //self.populateScheduleTable()
        //self.schedulesTableView.reloadData()
        initializeSession()
        self.updateScene()
        refreshControl.endRefreshing()
    }
    
    
    func makeFacetimeCall() {
        print("Facetime called...")
        if let callingNumber = self.phoneNumber{
            let trimmedNumber = callingNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
            print("Calling number \(trimmedNumber)")
            
            let facetimeUrlString = "facetime://\(trimmedNumber)"
            
            print(facetimeUrlString)
            if let facetimeURL = NSURL(string: facetimeUrlString) {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(facetimeURL)) {
                    print("can open facetime url")
                    application.openURL(facetimeURL);
                }else{
                    print("cannot open facetime url")
                }
            }else{
                print("Error in forming facetime url")
            }
        }
        
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
        self.callPoster.hidden = true
        
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
                    //print(user)
                    self.attendeeLabel.text = user!["name"] as? String
                    self.phoneNumber = user!["phoneNumber"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
        }else{
            //self.attendeeLabel.text = self.getUserName((session?.user_id)!)
            self.userRoleLabel.text = "Instructor"
            CoLearnClient.getUserDataFromDB((session?.user_id)!, success: { (user: PFObject?) -> () in
                //print(user)
                self.attendeeLabel.text = user!["name"] as? String
                self.phoneNumber = user!["phoneNumber"] as? String
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
        
        self.inTimeLabel.text = self.offsetFrom((session?.time)!)
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
    
    
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: NSDate(), toDate: date, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: NSDate(), toDate: date, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: NSDate(), toDate: date, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: NSDate(), toDate: date, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: NSDate(), toDate: date, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: NSDate(), toDate: date, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: NSDate(), toDate: date, options: []).second
    }
    
    func offsetFrom(date:NSDate) -> String {
        //print("offset called")
        
        let year = yearsFrom(date)
        //print(year)
        if year > 0 {
            if year==1{
                return "\(year) yr"
            }else{
                return "\(year) yrs"
            }
            
        }
        
        let month = monthsFrom(date)
        //print(month)
        if month > 0 {
            if month==1{
                return "\(month) month"
            }else{
                return "\(month) months"
            }
            
        }
        
        let week = weeksFrom(date)
        //print(week)
        if week > 0 {
            if week==1{
                return "\(week) week"
            }else{
                return "\(week) weeks"
            }
            
        }
        
        let day = daysFrom(date)
        //print(day)
        if day > 0 {
            if day==1{
                return "\(day) day"
            }else{
                return "\(day) days"
            }
            
        }
        
        let hour = hoursFrom(date)
        //print(hour)
        if hour > 0 {
            if hour==1{
                return "\(hour) hour"
            }else{
                let hourText = "\(hour) hours \(minutesFrom(date) % 60) mins"
                return hourText
            }
            
        }
        
        let min = minutesFrom(date)
        //print(min)
        if min > 0 {
            if min==1{
                return "\(min) min"
            }else{
                let minText = "\(min) mins \(secondsFrom(date) % 60) secs"
                return minText
            }
            
        }
        
        let sec = secondsFrom(date)
        //print(sec)
        if sec > 0 {
            if sec==1{
                return "\(sec) sec"
            }else{
                return "\(sec) secs"
            }
            
        }
        
        let callMinutesLapse = NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: NSDate(), options: []).minute
        //print("Lapse minutes \(callMinutesLapse)")
        
        if callMinutesLapse <= 60{
            self.callPoster.hidden = false
            return "Live now!"
        }
        
        return ""
    }

}

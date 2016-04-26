//
//  RequestViewController.swift
//  CoLearn
//
//  Created by Caleb Ripley on 4/20/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var requestNoteTextField: UITextField!
    
    var user: ParseDBUser?
    var langType: Languages.LangType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        hideKeyboardOnTapOutside()
        setViewFields()
        
        requestNoteTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func setViewFields() {
        instructorNameLabel.text = user?.fullName
        languageLabel.text = langType?.getName()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissKeyboard()
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func onSendRequest(sender: AnyObject) {
        
        let schedule = Schedule(user_id: (currentUser?.id)!, instructor_id: (user?.userId)! , lang: self.langType!, time: dateTime.date, timezone: NSTimeZone.localTimeZone(), requestNote: requestNoteTextField.text!, responseNote: "", scheduleStatus: ScheduleStatus.status.PENDING)

        
        CoLearnClient.addASchedule(schedule) { (status: Bool, error:NSError?) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                self.performSegueWithIdentifier("requestFailedSegue", sender: self)
            } else {
                if status {
                    self.performSegueWithIdentifier("unwindToSchedules", sender: self)
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindToSchedules") {
            let alert = UIAlertController(title: "Success!", message: Constants.requestSent, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default) { _ in })
            let schedulesVC = segue.destinationViewController as! SchedulesViewController
            schedulesVC.alert = alert
        }
        if (segue.identifier == "requestFailedSegue") {
            let alert = UIAlertController(title: "Oops!", message: Constants.tryAgain, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            let searchResultsVC = segue.destinationViewController as! SearchResultsViewController
            searchResultsVC.alert = alert
        }
    }
    
}

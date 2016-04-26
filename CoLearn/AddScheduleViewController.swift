//
//  AddScheduleViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/28/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse

class AddScheduleViewController: UIViewController {
    
    var langType: Languages.LangType?
    var usersCanTeachTheLanguage =  [ParseDBUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnLanguageSelect(sender: AnyObject) {
        let button = sender as! UIButton
        
        switch button.tag {
        case 1:
            //print("English") // English
            self.langType = Languages.LangType.ENGLISH
            getUserInfoForALanguage(self.langType!)
        case 2:
            //print("French")// French
            self.langType = Languages.LangType.FRENCH
            getUserInfoForALanguage(self.langType!)
        case 3:
            //print("Spanish")// Spanish
            self.langType = Languages.LangType.SPANISH
            getUserInfoForALanguage(self.langType!)
        case 4:
            //print("Chinese")// Chinese
            self.langType = Languages.LangType.CHINESE
            getUserInfoForALanguage(self.langType!)
        default: ()
        }
    }
    
    // Get the Instructors Info for multiple users.
    private func getUserInfoForALanguage(langType: Languages.LangType) {
        
        CoLearnClient.getUsersCanTeachForALangauge(langType, success: { (users: [PFObject]?) in
            
            if let users = users {
                var ids = [String]()
                for user in users {
                    ids.append(user["user_id"] as! String)
                }
                //print("getUserInfoForALanguage-userId's: ")
                //print("Count: \(ids.count)")
                self.usersCanTeachTheLanguage.removeAll()
                if ids.count > 0 {
                    CoLearnClient.getAllUserDataFromDB(ids, success: { (usersData: [PFObject]?) in
                        if let usersData = usersData {
                            for userData in usersData {
                                let user = ParseDBUser()
                                user.userInfo = userData
                                self.usersCanTeachTheLanguage.append(user)
                                // Move to Table View To display the results
                                self.performSegueWithIdentifier("SearchUserByLanguage", sender: self)
                            }
                        } else {
                            print("User Data can't be retrieved")
                        }
                    }, failure: { (error: NSError?) in
                        print("Error: \(error?.localizedDescription)")
                    })
                } else {
                    self.sorryMessage()
                }
            }
            }, failure: { (error: NSError?) in
                print("Error: \(error?.localizedDescription)")
        })
        
    }
    
    func sorryMessage() {
        let alert = UIAlertController(title: "Sorry!", message: Constants.teacherNotFound, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the User information to the Next View Controller.
        
        if segue.identifier == "SearchUserByLanguage" {
            let searchResultsViewController = segue.destinationViewController as! SearchResultsViewController
            searchResultsViewController.langType = self.langType
            searchResultsViewController.usersCanTeachTheLanguage = self.usersCanTeachTheLanguage
        }
        
    }
    
}

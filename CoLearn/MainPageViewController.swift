//
//  MainPageViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/9/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

var currentUser:User?

class MainPageViewController: UITabBarController {
    
//    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get User info from facebook
        FacebookSDK.getUserInfoFromFacebook({ (user: User?) in
            if let user = user {
                currentUser = user
                CoLearnClient.postUserInfo(currentUser!, withCompletion: { (status: Bool, error: NSError?) in
                    if (error == nil && status == true) {
                    }
                })
                User.setUserInfoFromDB(currentUser!)
            }
        }) { (error: NSError?) in
            print(error?.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

}


extension UIViewController {
    func hideKeyboardOnTapOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


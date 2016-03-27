//
//  SchedulesViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/9/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class SchedulesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}

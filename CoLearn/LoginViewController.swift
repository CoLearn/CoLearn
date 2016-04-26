//
//  LoginViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 2/24/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email", "user_about_me", "user_hometown", "user_location", "user_status"]
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.facebookLoginButton.hidden = true
        if(error == nil) {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
}


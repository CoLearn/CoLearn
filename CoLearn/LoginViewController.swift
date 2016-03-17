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
        
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email"]
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged out")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Logged in")
        self.facebookLoginButton.hidden = true
        if(error == nil) {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
    
}


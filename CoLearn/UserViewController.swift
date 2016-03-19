//
//  UserViewController.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/9/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var facebookLogoutButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        facebookLogoutButton.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(" Already Logged in.")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged out..")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func getUserInfo() {
        let params = ["fields":"id, name, first_name, last_name, email"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                print(result)
                self.nameLabel.text = result["name"] as? String
                self.emailLabel.text = result["email"] as? String
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func onClickCallButton(sender: AnyObject) {
        facetime("14804340901")
    }
    
    func facetime(phoneNumber:String) {
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                print("can open facetime url")
                application.openURL(facetimeURL);
            }else{
                print("cannot open facetime url")
            }
            
            
        }
    }
    
}

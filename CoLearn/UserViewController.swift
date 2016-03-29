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
import AFNetworking

class UserViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var facebookLogoutButton: FBSDKLoginButton!
    @IBOutlet weak var languageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        facebookLogoutButton.delegate = self
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageTableView.rowHeight = UITableViewAutomaticDimension
        languageTableView.estimatedRowHeight = 60
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
        let params = ["fields":"id, name, first_name, last_name, email, picture, cover, about, friends, locale, location,  timezone"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error == nil {
                print(result)
                
//                self.locationLabel.text = 
//                self.rewardsLabel.text =   // Need to make API calls to our database for these
                
                self.nameLabel.text = result["name"] as? String
                self.taglineLabel.text = result["about"] as? String
                print(result["about"]) // Doesn't give me anything, not sure if it is a code problem or FB's database hasn't registered that I just updated my about me section?
                
                let picture = result["picture"] as? NSDictionary
                let data = picture!["data"] as? NSDictionary
                let profileImageUrl = data!["url"] as? String
                if let profileImageUrl = profileImageUrl {
                    self.profilePictureImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
                }
                
                if let cover = data!["cover"] as? NSDictionary {
                    if let coverPhotoUrl = cover["source"] as? String {
                        self.coverPhotoImageView.setImageWithURL(NSURL(string: coverPhotoUrl)!)
                    }
                }

            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    // Need to make API call to our database for the language object that includes the language and the flag 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let languages = langauges {
//            return languages!.count
//        } else {
            return 0
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageCell", forIndexPath: indexPath) as! LanguageCell
        
        
        return cell
    }
    
}

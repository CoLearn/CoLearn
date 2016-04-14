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
import Parse
import ParseFacebookUtilsV4


class UserViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var facebookLogoutButton: FBSDKLoginButton!
    @IBOutlet weak var languageTableView: UITableView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserProperties()
        
        facebookLogoutButton.delegate = self
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageTableView.rowHeight = UITableViewAutomaticDimension
        languageTableView.estimatedRowHeight = 60
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        setUserProperties()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(" Already Logged in.")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged out..")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    

    // Need to make API call to our database for the language object that includes the language and the flag 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let user = self.user {
            return (user.languagesCanTeach?.languages.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageCell", forIndexPath: indexPath) as! LanguageCell

        let langs = Array(arrayLiteral: user?.languagesCanTeach?.languages)
//        let langType: Languages.LangType = langs[indexPath.row]
        let language = "\(langs[indexPath.row])"
        switch language {
            case "0":
            cell.languageLabel.text = Constants.SPANISH
            case "1":
            cell.languageLabel.text = Constants.CHINESE
            case "2":
            cell.languageLabel.text = Constants.FRENCH
            case "3":
            cell.languageLabel.text = Constants.ENGLISH
            default:
            cell.languageLabel.text = Constants.ENGLISH
        }
        
        return cell
    }
    
    private func setUserProperties() {
        if let about = currentUser?.about {
            taglineLabel.text = about
        }
//        rewardsLabel.text = 
        if let location = currentUser?.location?.loc {
            locationLabel.text = location
        }
        if  let profilePic = currentUser?.profilePictureURL {
            profilePictureImageView.setImageWithURL(profilePic)
        }
        if let coverPhoto = currentUser?.coverPictureURL {
            coverPhotoImageView.setImageWithURL(coverPhoto)
        }
        if let name = currentUser?.fullName {
            nameLabel.text = name
        }
    }
    
    @IBAction func onPressSettings(sender: AnyObject) {
        
    }
    
    
}

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
    var lanTeachObjectCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        facebookLogoutButton.delegate = self
        
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageTableView.rowHeight = UITableViewAutomaticDimension
        languageTableView.estimatedRowHeight = 60
    }
    
    override func viewDidAppear(animated: Bool) {
        languageTableView.reloadData()
        setUserProperties()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let user = currentUser {
            return (user.languagesCanTeach?.languages.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageCell", forIndexPath: indexPath) as! LanguageCell

        if let langs = currentUser?.languagesCanTeach?.languages {
            if (langs[indexPath.row].getName() == Constants.ENGLISH) {
                cell.flagImageView.image = UIImage(named: "FlagOfBritain")
                cell.languageLabel.text = Constants.ENGLISH
            } else if (langs[indexPath.row].getName() == Constants.SPANISH) {
                cell.flagImageView.image = UIImage(named: "FlagOfSpain")
                cell.languageLabel.text = Constants.SPANISH
            } else if (langs[indexPath.row].getName() == Constants.FRENCH) {
                cell.flagImageView.image = UIImage(named: "FlagOfFrance")
                cell.languageLabel.text = Constants.FRENCH
            } else if (langs[indexPath.row].getName() == Constants.CHINESE) {
                cell.flagImageView.image = UIImage(named: "FlagOfChina")
                cell.languageLabel.text = Constants.CHINESE
            }
        } else {
            cell.languageLabel.text = ""
        }
        
        return cell
    }
    
    private func setUserProperties() {
        if let about = currentUser?.about {
            taglineLabel.text = about
        } else {
            taglineLabel.text = ""
        }
        if let location = currentUser?.location?.loc {
            locationLabel.text = location
        } else {
            locationLabel.text = ""
        }
        if  let profilePic = currentUser?.profilePictureURL {
            profilePictureImageView.setImageWithURL(profilePic)
            profilePictureImageView.layer.cornerRadius = 3
        } else {
            // Allow user to tap to add new profile picture
        }
        if let coverPhoto = currentUser?.coverPictureURL {
            coverPhotoImageView.setImageWithURL(coverPhoto)
        } else {
            // Allow user to tap to add new cover photo
        }
        if let name = currentUser?.fullName {
            nameLabel.text = name
        } else {
            nameLabel.text = ""
        }
        rewardsLabel.text = currentUser?.rewards
    }
    
    @IBAction func onPressSettings(sender: AnyObject) {
        // Segues to settings view controller
    }
    
    
}

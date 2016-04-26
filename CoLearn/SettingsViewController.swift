//
//  SettingsViewController.swift
//  CoLearn
//
//  Created by Caleb Ripley on 4/6/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var aboutMeTextField: UITextField!
    @IBOutlet weak var chineseTeachSwitch: UISwitch!
    @IBOutlet weak var frenchTeachSwitch: UISwitch!
    @IBOutlet weak var spanishTeachSwitch: UISwitch!
    @IBOutlet weak var englishTeachSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        setTextFields()
        setSwitches()
        hideKeyboardOnTapOutside()
        
        aboutMeTextField.delegate = self
        nameTextField.delegate = self
        locationTextField.delegate = self
        phoneNumberTextField.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onSave(sender: AnyObject) {
        saveEditedData()
        updateEditedData()
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onBack(sender: AnyObject) {
        dismissKeyboard()
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func setTextFields() {
        phoneNumberTextField.text = currentUser?.phoneNumber
        aboutMeTextField.text = currentUser?.about
        nameTextField.text = currentUser?.fullName
        locationTextField.text = currentUser?.location?.loc
    }
    
    func setSwitches() {
        // For languages user can teach
        if let languages = currentUser?.languagesCanTeach?.languages {
            for langObject in languages {
                if (langObject.getName() == Constants.ENGLISH) {
                    englishTeachSwitch.on = true
                } else if (langObject.getName() == Constants.SPANISH) {
                    spanishTeachSwitch.on = true
                } else if (langObject.getName() == Constants.FRENCH) {
                    frenchTeachSwitch.on = true
                } else if (langObject.getName() == Constants.CHINESE) {
                    chineseTeachSwitch.on = true
                }
            }
        }
        
        // For languages user wants to learn
    }
    
    func saveEditedData() {
        // Saving basic user properties
        currentUser?.fullName = nameTextField.text
        currentUser?.phoneNumber = phoneNumberTextField.text
        currentUser?.about = aboutMeTextField.text
        currentUser?.location?.loc = locationTextField.text
        
        // Saving languages a user can teach
        if (currentUser?.languagesCanTeach?.languages != nil) {
            
            // ENGLISH
            if (englishTeachSwitch.on == true && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.ENGLISH) == false) {
                CoLearnClient.postLanguagesToTeach(Languages.LangType.ENGLISH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if error == nil {
                        currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.ENGLISH)
                    } else {
                        print("Error posting language to teach: \(error?.localizedDescription)")
                    }
                })
            } else if (englishTeachSwitch.on == false && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.ENGLISH) == true) {
                CoLearnClient.removeLanguagesToTeach(Languages.LangType.ENGLISH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if (error == nil) {
                        currentUser?.languagesCanTeach?.removeLanguage(Languages.LangType.ENGLISH)
                    } else {
                        print("Error removing language to teach: \(error?.localizedDescription)")
                    }
                })
                
            }   // FRENCH
            if (frenchTeachSwitch.on == true && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.FRENCH) == false) {
                CoLearnClient.postLanguagesToTeach(Languages.LangType.FRENCH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if error == nil {
                        currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.FRENCH)
                    } else {
                        print("Error posting language to teach: \(error?.localizedDescription)")
                    }
                })
            } else if (frenchTeachSwitch.on == false && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.FRENCH) == true) {
                CoLearnClient.removeLanguagesToTeach(Languages.LangType.FRENCH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if (error == nil) {
                        currentUser?.languagesCanTeach?.removeLanguage(Languages.LangType.FRENCH)
                    } else {
                        print("Error removing language to teach: \(error?.localizedDescription)")
                    }
                })
                
            }    // SPANISH
            if (spanishTeachSwitch.on == true && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.SPANISH) == false) {
                CoLearnClient.postLanguagesToTeach(Languages.LangType.SPANISH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if error == nil {
                        currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.SPANISH)
                    } else {
                        print("Error posting language to teach: \(error?.localizedDescription)")
                    }
                })
            } else if (spanishTeachSwitch.on == false && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.SPANISH) == true) {
                CoLearnClient.removeLanguagesToTeach(Languages.LangType.SPANISH, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if (error == nil) {
                        currentUser?.languagesCanTeach?.removeLanguage(Languages.LangType.SPANISH)
                    } else {
                        print("Error removing language to teach: \(error?.localizedDescription)")
                    }
                })
                
            }    // CHINESE
            if (chineseTeachSwitch.on == true && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.CHINESE) == false) {
                CoLearnClient.postLanguagesToTeach(Languages.LangType.CHINESE, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if error == nil {
                        currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.CHINESE)
                    } else {
                        print("Error posting language to teach: \(error?.localizedDescription)")
                    }
                })
            } else if (chineseTeachSwitch.on == false && currentUser?.languagesCanTeach?.hasLanguage(Languages.LangType.CHINESE) == true) {
                CoLearnClient.removeLanguagesToTeach(Languages.LangType.CHINESE, user_id: (currentUser?.id)!, withCompletion: { (status: Bool, error: NSError?) in
                    if (error == nil) {
                        currentUser?.languagesCanTeach?.removeLanguage(Languages.LangType.CHINESE)
                    } else {
                        print("Error removing language to teach: \(error?.localizedDescription)")
                    }
                })
            }
        }
    }
    
    func updateEditedData() {
        CoLearnClient.updateUserDataOnDB(currentUser!, status: { (error: NSError?) in
            print(error?.localizedDescription)
        }) { (status:  Bool, error: NSError?) in
            if error == nil {
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

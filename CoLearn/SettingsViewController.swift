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
        
        setTextFields()
        disableTextFields()
        //hideKeyboardOnTapOutside()
        
        self.aboutMeTextField.delegate = self
        self.nameTextField.delegate = self
        self.locationTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onSave(sender: AnyObject) {
        disableTextFields()
        saveEditedData()
        updateEditedData()
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onBack(sender: AnyObject) {
        disableTextFields()
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onEditTextFields(sender: AnyObject) {
        enableTextFields()
    }
    
    func disableTextFields() {
        phoneNumberTextField.userInteractionEnabled = false
        aboutMeTextField.userInteractionEnabled = false
        nameTextField.userInteractionEnabled = false
        locationTextField.userInteractionEnabled = false
    }
    
    func enableTextFields () {
        nameTextField.userInteractionEnabled = true
        phoneNumberTextField.userInteractionEnabled = true
        aboutMeTextField.userInteractionEnabled = true
        locationTextField.userInteractionEnabled = true
    }
    
    func setTextFields() {
        phoneNumberTextField.text = currentUser?.phoneNumber
        aboutMeTextField.text = currentUser?.about
        nameTextField.text = currentUser?.fullName
        locationTextField.text = currentUser?.location?.loc
    }
    
    func saveEditedData() {
        currentUser?.fullName = nameTextField.text
        currentUser?.phoneNumber = phoneNumberTextField.text
        currentUser?.about = aboutMeTextField.text
        currentUser?.location?.loc = locationTextField.text
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
    
    @IBAction func onSwitchTeachEnglish(sender: AnyObject) {
        if (englishTeachSwitch.on == true) {
            currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.ENGLISH)

            for langType in (currentUser?.languagesCanTeach?.languages)! {
                CoLearnClient.postLanguagesToTeach(langType, user_id: (currentUser?.id)!) { (status: Bool, error: NSError?) in
                }
            }
        } else {
            // remove language from the object and make API call here
        }
    }
    
    @IBAction func onSwitchTeachSpanish(sender: AnyObject) {
        if (spanishTeachSwitch.on == true) {
            currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.SPANISH)
        }
    }
    
    @IBAction func onSwitchTeachFrench(sender: AnyObject) {
        if (frenchTeachSwitch.on == true) {
            currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.FRENCH)
        }
    }
    
    @IBAction func onSwitchTeachChinese(sender: AnyObject) {
        if (chineseTeachSwitch.on == true) {
            currentUser?.languagesCanTeach?.addLanguage(Languages.LangType.CHINESE)
        }
    }
    
    @IBAction func onTapView(sender: AnyObject) {
        //dismissKeyboard()
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

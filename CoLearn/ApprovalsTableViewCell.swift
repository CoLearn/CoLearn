//
//  ApprovalsTableViewCell.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import SWTableViewCell
import Parse


class ApprovalsTableViewCell: SWTableViewCell{
    

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var proposedTimeLabel: UILabel!
    
    @IBOutlet weak var learnerLabel: UILabel!
    
    @IBOutlet weak var requestNoteLabel: UILabel!
    
    @IBOutlet weak var feedbackCommentTextField: UITextField!
    
    @IBOutlet weak var flagPosterView: UIImageView!
    
    @IBOutlet weak var responseNoteTextField: UITextField!
    
    var index: Int?
    
    var pendingApprovalMeeting: Schedule?{
        didSet{
            /*
            self.languageLabel.text = pendingApprovalMeeting?.language.getName()
            self.proposedTimeLabel.text = "\(pendingApprovalMeeting?.time)"
            self.learnerLabel.text = pendingApprovalMeeting?.user_id
            self.requestNoteLabel.text = pendingApprovalMeeting?.requestNote
            */
            
            languageLabel.text = pendingApprovalMeeting?.language.getName()
            
            if let language = pendingApprovalMeeting?.language.getName(){
                switch language{
                case Languages.LangType.CHINESE.getName(): self.flagPosterView.image = UIImage(named: "FlagOfChina")
                case Languages.LangType.ENGLISH.getName(): self.flagPosterView.image = UIImage(named: "FlagOfBritain")
                case Languages.LangType.FRENCH.getName(): self.flagPosterView.image = UIImage(named: "FlagOfFrance")
                case Languages.LangType.SPANISH.getName(): self.flagPosterView.image = UIImage(named: "FlagOfSpain")
                default: self.flagPosterView.image = UIImage(named: "FlagOfBritain")
                }
                
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            self.proposedTimeLabel.text = dateFormatter.stringFromDate((pendingApprovalMeeting?.time)!)
            
            
            learnerLabel.text = pendingApprovalMeeting?.user_id
            CoLearnClient.getUserDataFromDB((pendingApprovalMeeting?.user_id)!, success: { (user: PFObject?) -> () in
                print(user)
                self.learnerLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
            requestNoteLabel.text = pendingApprovalMeeting?.requestNote
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}

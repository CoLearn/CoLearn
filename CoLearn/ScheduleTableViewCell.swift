//
//  ScheduleTableViewCell.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse

class ScheduleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var meetingDatatime: UILabel!
    
    @IBOutlet weak var instructorLabel: UILabel!
    
    @IBOutlet weak var learnerLabel: UILabel!
    
    @IBOutlet weak var requestNoteLabel: UILabel!
    
    @IBOutlet weak var flagPosterView: UIImageView!
    
    @IBOutlet weak var statusPoster: UIImageView!
    
    
    var schedule: Schedule?{
        didSet{
            languageLabel.text = schedule?.language.getName()
            
            if let language = schedule?.language.getName(){
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
            meetingDatatime.text = dateFormatter.stringFromDate((schedule?.time)!)
            
            instructorLabel.text = schedule?.instructor_id
            CoLearnClient.getUserDataFromDB((schedule?.instructor_id)!, success: { (user: PFObject?) -> () in
                //print(user)
                self.instructorLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
            learnerLabel.text = schedule?.user_id
            CoLearnClient.getUserDataFromDB((schedule?.user_id)!, success: { (user: PFObject?) -> () in
                //print(user)
                self.learnerLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
            requestNoteLabel.text = schedule?.requestNote
            
            if let staus = schedule?.scheduleStatus.getName(){
                switch staus{
                case Constants.APPROVED: self.statusPoster.image = UIImage(named: "approved")
                case Constants.REJECTED: self.statusPoster.image = UIImage(named: "rejected")
                case Constants.PENDING: self.statusPoster.image = UIImage(named: "pending")
                default: self.statusPoster.image = UIImage(named: "pending")
                }
                
            }
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

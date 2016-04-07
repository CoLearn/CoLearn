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
    
    /*
    var schedule: Meeting?{
        didSet{
            languageLabel.text = schedule?.language
            meetingDatatime.text = schedule?.mtime
            instructorLabel.text = schedule?.instructor
            learnerLabel.text = schedule?.learner
            requestNoteLabel.text = schedule?.requestNote
        }
    }*/
    
    var schedule: Schedule?{
        didSet{
            languageLabel.text = schedule?.language.getName()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            
            let date = dateFormatter.stringFromDate((schedule?.time)!)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let time = timeFormatter.stringFromDate((schedule?.time)!)
            
            meetingDatatime.text = "\(date) @\(time)"
            
            //meetingDatatime.text = "\(schedule?.time)"
            
            
            instructorLabel.text = schedule?.instructor_id
            //let instructor =
            CoLearnClient.getUserDataFromDB((schedule?.instructor_id)!, success: { (user: PFObject?) -> () in
                print(user)
                self.instructorLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
            learnerLabel.text = schedule?.user_id
            CoLearnClient.getUserDataFromDB((schedule?.user_id)!, success: { (user: PFObject?) -> () in
                print(user)
                self.learnerLabel.text = user!["name"] as? String
                }) { (error: NSError?) -> () in
                    print("Error getting the user info from db \(error?.localizedDescription)")
            }
            
            requestNoteLabel.text = schedule?.requestNote
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

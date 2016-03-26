//
//  ScheduleTableViewCell.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var meetingDatatime: UILabel!
    
    @IBOutlet weak var instructorLabel: UILabel!
    
    @IBOutlet weak var learnerLabel: UILabel!
    
    @IBOutlet weak var requestNoteLabel: UILabel!
    
    var schedule: Meeting?{
        didSet{
            languageLabel.text = schedule?.language
            meetingDatatime.text = schedule?.mtime
            instructorLabel.text = schedule?.instructor
            learnerLabel.text = schedule?.learner
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

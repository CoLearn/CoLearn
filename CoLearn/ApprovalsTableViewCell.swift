//
//  ApprovalsTableViewCell.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import SWTableViewCell

class ApprovalsTableViewCell: SWTableViewCell{
    

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var proposedTimeLabel: UILabel!
    
    @IBOutlet weak var instructorLabel: UILabel!
    
    @IBOutlet weak var learnerLabel: UILabel!
    
    @IBOutlet weak var requestNoteLabel: UILabel!
    
    @IBOutlet weak var feedbackCommentTextField: UITextField!
    
    var index: Int?
    
    var pendingApprovalMeeting: Meeting?{
        didSet{
            self.languageLabel.text = pendingApprovalMeeting?.language
            self.proposedTimeLabel.text = pendingApprovalMeeting?.mtime
            self.instructorLabel.text = pendingApprovalMeeting?.instructor
            self.learnerLabel.text = pendingApprovalMeeting?.learner
            self.requestNoteLabel.text = pendingApprovalMeeting?.requestNote
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

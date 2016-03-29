//
//  Meetings.swift
//  CoLearn
//
//  Created by Satyam Jaiswal on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class Meeting: NSObject {
    var language: String?
    var mtime: String?
    var instructor: String?
    var learner: String?
    var requestNote: String?
    
    init(language: String, mtime: String, instructor: String, learner: String, requestNote: String){
        self.language = language
        self.mtime = mtime
        self.instructor = instructor
        self.learner = learner
        self.requestNote = requestNote
    }
}

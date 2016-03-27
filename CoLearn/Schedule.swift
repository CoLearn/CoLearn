//
//  Schedule.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    var sch_id:String?
    var user_id: String!
    var instructor_id: String!
    var language: Languages.LangType!
    var time: NSDate!
    var timezone: NSTimeZone!
    var requestNote: String!
    var responseNote: String!
    var scheduleStatus: ScheduleStatus.status!
    
    init(user_id :String, instructor_id: String, lang: Languages.LangType, time: NSDate, timezone: NSTimeZone, requestNote: String, responseNote: String, scheduleStatus: ScheduleStatus.status) {
        self.user_id = user_id
        self.instructor_id = instructor_id
        self.language = lang
        self.time = time
        self.timezone = timezone
        self.requestNote = requestNote
        self.responseNote = responseNote
        self.scheduleStatus = scheduleStatus
    }
    
    init(sch_id:String, user_id :String, instructor_id: String, lang: Languages.LangType, time: NSDate, timezone: NSTimeZone, requestNote: String, responseNote: String, scheduleStatus: ScheduleStatus.status) {
        self.sch_id = sch_id
        self.user_id = user_id
        self.instructor_id = instructor_id
        self.language = lang
        self.time = time
        self.timezone = timezone
        self.requestNote = requestNote
        self.responseNote = responseNote
        self.scheduleStatus = scheduleStatus
    }
}

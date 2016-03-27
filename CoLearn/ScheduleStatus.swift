//
//  ScheduleStatus.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/26/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class ScheduleStatus: NSObject {
    
    enum status:Int {
        case PENDING, APPROVED, REJECTED, COMPLETED
        
        static let names = [
            PENDING: Constants.PENDING, APPROVED: Constants.APPROVED, REJECTED: Constants.REJECTED, COMPLETED: Constants.COMPLETED
        ]
        
        func getName() -> String {
            if let name = status.names[self] {
                return name
            } else {
                return ""
            }
        }
    }
    
}

//
//  Location.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class Location: NSObject {
    
    var loc: String? //City, State
    var country: String
    var timeZone: String
    
    init( country: String, timeZone: String) {
        self.country = country
        self.timeZone = timeZone
        self.loc = ""
    }
    
    init( country: String, timeZone: String, loc: String?) {
        if let loc = loc {
            self.loc = loc
        }
        
        self.country = country
        self.timeZone = timeZone
    }
}

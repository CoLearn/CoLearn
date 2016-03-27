//
//  Location.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class Location: NSObject {
    
    var city: String?
    var state: String?
    var country: String
    var timeZone: String
    
    init( country: String, timeZone: String) {
        self.country = country
        self.timeZone = timeZone
        self.city = ""
        self.state = ""
    }
    
    init( country: String, timeZone: String, city: String?, state: String?) {
        if let city = city {
            self.city = city
        }
        if let state = state {
            self.state = state
        }
        self.country = country
        self.timeZone = timeZone
    }
    
}

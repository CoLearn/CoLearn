//
//  Languages.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class Languages: NSObject {
    
    enum LangType:Int {
        case SPANISH, CHINESE, FRENCH, ENGLISH
        
        static let names = [
            SPANISH: Constants.SPANISH, CHINESE: Constants.CHINESE, FRENCH: Constants.FRENCH, ENGLISH: Constants.ENGLISH
        ]
        
        func getName() -> String {
            if let name = LangType.names[self] {
                return name
            } else {
                return ""
            }
        }
    }
}

//
//  LanguagesChosen.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 3/25/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

extension String {
    func condenseWhitespace() -> String {
        return characters
            .split { $0 == " " }
            .map { String($0) }
            .joinWithSeparator(" ")
    }
}

class LanguagesChosen: NSObject {
    
    var id: String!
    var lanuages = Set<Languages.LangType>() // Chosen a set, as a language can be added only once.
    
    init(id:String, language: String) {
        
        // User Id (Facebook)
        self.id = id
        
        // Languages Chosen
        let languages = language.componentsSeparatedByString(",")
        for lang in languages {
            switch lang.condenseWhitespace() {
                case Constants.CHINESE:
                    self.lanuages.insert(Languages.LangType.CHINESE)
                case Constants.ENGLISH:
                    self.lanuages.insert(Languages.LangType.ENGLISH)
                case Constants.FRENCH:
                    self.lanuages.insert(Languages.LangType.FRENCH)
                case Constants.SPANISH:
                    self.lanuages.insert(Languages.LangType.SPANISH)
                default: ()
            }
        }
    }
    
    // Add a language to the set
    func addLanguage(lang: Languages.LangType) {
        lanuages.insert(lang)
    }
    
    // Return the list of Languages in a string format.
    func toString() -> String {
        
        var response:String = ""
        
        for lang in lanuages {
            response += "\(lang.getName()),"
        }
        
        response = response.substringToIndex(response.startIndex.advancedBy(response.characters.count-2))
        return response
    }
}

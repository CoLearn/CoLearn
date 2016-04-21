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
    var languages = Array<Languages.LangType>() // Chosen a set, as a language can be added only once.
    

    
    // Add a language to the set
    func addLanguage(lang: Languages.LangType) {
        languages.append(lang)
    }
    
    func removeLanguage(lang: Languages.LangType) {
        var i = 0
        var removeIndex: Int!
        for language in languages {
            if language.getName() == lang.getName() {
                removeIndex = i
            }
            i += 1
        }
        languages.removeAtIndex(removeIndex)
    }
    
    func hasLanguage(lang: Languages.LangType) -> Bool {
        var result = false
        for language in languages {
            if (language.getName() == lang.getName()) {
                result = true
            }
        }
        return result
    }
    
    // Return the list of Languages in a string format.
    func toString() -> String {
        var response:String = ""
        
        for lang in languages {
            response += "\(lang.getName()),"
        }
        
        response = response.substringToIndex(response.startIndex.advancedBy(response.characters.count-1))
        return response
    }
}

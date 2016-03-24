//
//  LanguageCell.swift
//  CoLearn
//
//  Created by Caleb Ripley on 3/23/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
//    var language: langauges! {
//        didSet {
//            langauge.languagelabel =
//            langauge.flagImageView =
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

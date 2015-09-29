//
//  HighScoresTableViewCell.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/12/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit

class HighScoresTableViewCell: UITableViewCell {

    @IBOutlet weak var hsName: UILabel!
    @IBOutlet weak var hsScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

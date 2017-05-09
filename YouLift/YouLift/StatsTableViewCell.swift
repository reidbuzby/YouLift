//
//  StatsTableViewCell.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import UIKit

class StatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statsDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(exercise: Exercise){
        var cellText:String = exercise.name + ":\n"
    
        for i in 0..<exercise.sets {
            cellText += "Set " + String(i+1) + ": " + String(exercise.setsArray[i].0) + " x " + String(exercise.setsArray[i].1) + "\n"
        }
        
        statsDataLabel.numberOfLines = 0
        statsDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        statsDataLabel.text = cellText
    }
}

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
    
    //  cell's label
    @IBOutlet weak var statsDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //  configure the cell accordingly.
    func configureCell(exercise: Exercise){
        
        //  cell should display the exercise name
        var cellText:String = exercise.name + ":\n"
    
        //  display the weights/reps data for each set
        for i in 0..<exercise.sets {
            cellText += "\tSet " + String(i+1) + ":\t" + String(exercise.setsArray[i].0) + " lbs x " + String(exercise.setsArray[i].1) + " reps\n"
        }
        
        //  allow the label to span multiple lines
        statsDataLabel.numberOfLines = 0
        statsDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //  set the label's text to be the exercise data
        statsDataLabel.text = cellText
    }
}

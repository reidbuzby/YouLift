//
//  WorkoutListingCellTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/25/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

/*
 
 Data storage for individual cells within a table view
 
*/

import UIKit

class WorkoutListingCell: UITableViewCell {

    
    @IBOutlet weak var workoutName: UILabel!
    
    func configureCell(workout: Workout) {
        workoutName.text = workout.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

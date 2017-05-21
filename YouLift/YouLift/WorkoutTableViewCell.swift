//
//  WorkoutTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  A basic cell associated with a workout. Each cell displays the workout name. In the case of a completed workout, the date is also displayed.

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    //  label to display the workout's name
    @IBOutlet weak var workoutName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //  connects the cell's label to the workout's name
    func configureCell(workout: Workout) {
        workoutName.text = workout.name
    }
    
    //  FOR STATS TAB
    //  connects the cell's label to the workout's name + date (dd/MM/yyyy format).
    func configureDateCell(workout: Workout, date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        workoutName.text = String(workout.name + " - " + dateFormatter.string(from: date))
    }

}

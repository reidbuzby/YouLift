//
//  ExerciseTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  A basic cell associated with an exercise. Each cell displays the exercise name.

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseName2: UILabel!
    @IBOutlet weak var exerciseName3: UILabel!
    @IBOutlet weak var exerciseName4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(exercise: Exercise) {
        if exerciseName != nil {
            exerciseName.text = exercise.name
        }
        if exerciseName2 != nil {
            exerciseName2.text = exercise.name
        }
        if exerciseName3 != nil {
            exerciseName3.text = exercise.name
        }
        if exerciseName4 != nil {
            exerciseName4.text = exercise.name
        }
        
    }
    
}

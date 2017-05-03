//
//  ExerciseTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseName2: UILabel!
    @IBOutlet weak var exerciseName3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
    }
}

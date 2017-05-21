//
//  ExerciseStats.swift
//  YouLift
//
//  Created by rbuzby on 5/20/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation

//  class for storing all the completed data for an exercise
class ExerciseStats {
    
    var exercise: Exercise
    var data: [(Double, Date)]//first int is weight second is reps
    
    init(exercise: Exercise, data: [(Double, Date)]) {
        self.exercise = exercise
        self.data = data
    }
}

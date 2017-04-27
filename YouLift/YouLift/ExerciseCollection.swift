//
//  ExerciseCollection.swift
//  YouLift
//
//  Created by rbuzby on 4/25/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

/*
 
 Data storage for all exercises made in an array
 
*/

import Foundation

class ExerciseCollection {
    
    var collection = [Exercise]()
    
    init() {
        collection += [Exercise(name: "Squat", description: "This is how to do a squat", sets: 3, setsArray: [(100, 2), (100, 2), (100, 2)]),
                           Exercise(name: "Leg Press", description: "This is how to do a leg press", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                           Exercise(name: "Deadlift", description: "This is how to do a deadlift", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                           Exercise(name: "Leg Curl", description: "This is how to do a leg curl", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                           Exercise(name: "Calf Raises", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])]
    }
    
    func add(exercise: Exercise) {
        collection.append(exercise)
    }
    
    func remove(at_index:Int) {
        collection.remove(at: at_index)
    }
}

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
        collection += [Exercise(name: "Squat", description: "This is how to do a squat", sets: 3, setsArray: [(100, 2), (100, 2), (100, 2)])]
    }
    
    func add(exercise: Exercise) {
        collection.append(exercise)
    }
    
    func remove(at_index:Int) {
        collection.remove(at: at_index)
    }
}

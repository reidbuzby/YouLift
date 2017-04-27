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
    
    var collection = [String: Exercise]()
    
    init() {
        collection["Squat"] = Exercise(name: "Squat", description: "This is how to do a squat", sets: 3, setsArray: [(100, 2), (100, 2), (100, 2)])
    }
    
    func add(name:String, description:String, sets:Int, setsArray:[(Int, Int)]) {
        collection[name] = Exercise(name: name, description: description, sets: sets, setsArray: setsArray)
    }
    
    func remove(exercise_name:String) {
        collection.removeValue(forKey: exercise_name)
    }
}

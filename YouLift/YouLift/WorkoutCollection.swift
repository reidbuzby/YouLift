//
//  WorkoutCollection.swift
//  YouLift
//
//  Created by rbuzby on 4/25/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

/*
 
 Data storage for all workouts made in an array
 
*/

import Foundation

class WorkoutCollection {
    
    var defaultCollection = [Workout]()
    var customCollection = [Workout]()
    
    
    //Add in dummy workouts
    init() {
        defaultCollection += [
            Workout(name: "Leg Day", exercises: [Exercise(name:"Squat", description:"This is how to do a squat", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])])
        ]
        customCollection += [
            Workout(name: "Custom Workout", exercises: [Exercise(name:"blah", description:"This is how to do blah", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])])
        ]
    }
    
    func add(workout:Workout) {
        customCollection.append(workout)
    }
    
    func removeDefault(at_index:Int) {
        defaultCollection.remove(at: at_index)
    }
    
    func removeCustom(at_index:Int) {
        customCollection.remove(at: at_index)
    }
}

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
    
    public var defaultCollection = [Workout]()
    public var customCollection = [Workout]()
    
    
    //Add in dummy workouts
    init() {
        defaultCollection += [
            Workout(name: "Leg Day", exercises: [
                Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slow stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
                Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Deadlift", description: "This is how to do a deadlift", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Leg Curl", description: "This is how to do a leg curl", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Calf Raises", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])]),
            
            
            Workout(name: "Sunday Morning", exercises: [
                Exercise(name: "Bicep Curl", description: "csxdgfgcxg", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Shoulder Press", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Ab Crunch", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])]),
            
            Workout(name: "Try Hard", exercises: [
                Exercise(name: "Bicep Curl", description: " ", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Shoulder Press", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                Exercise(name: "Ab Crunch", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])])
        ]
        
        customCollection += [
            Workout(name: "Connor's Workout", exercises: [
                Exercise(name:"blah", description:"This is how to do blah", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])
                ]),
            Workout(name: "Reid's Workout", exercises: [
                Exercise(name:"blah", description:"This is how to do blah", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])]),
            Workout(name: "Andrew's Workout", exercises: [
                Exercise(name:"blah", description:"This is how to do blah", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])])
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

//
//  Workout.swift
//  YouLift
//
//  Created by rbuzby on 4/25/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
/*
 Class for an entire workout
*/

import Foundation

//  basic workout object. Has a name and an array of exercise objects
class Workout{
    
    var name:String
    
    var exerciseArray:[Exercise]
    
    init(name:String, exercises:[Exercise]) {
        self.name = name
        self.exerciseArray = exercises
    }
    
    init(){
        self.name = ""
        self.exerciseArray = []
    }
}

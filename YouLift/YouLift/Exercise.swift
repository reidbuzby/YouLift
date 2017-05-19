//
//  Exercise.swift
//  YouLift
//
//  Created by rbuzby on 4/25/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

/*
 
 Class for individual exercises within a workout
 
*/

import Foundation

//  basic exercise object. Has a name, description, number of sets, and array of tuples (weight, reps)
class Exercise{
    
    var name:String
    var description:String
    var sets:Int
    var setsArray:[(Int, Int)]//first int is weight, second is number of reps
    
    init(name:String, description:String, sets:Int, setsArray:[(Int, Int)]) {
        self.name = name
        self.description = description
        self.sets = sets
        self.setsArray = setsArray
    }
    
    init(){
        self.name = ""
        self.description = ""
        self.sets = 0
        self.setsArray = []
    }
}

//
//  ExerciseEntity+CoreDataClass.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  Exercise Entity class for core data
//  name: name of the exercise (string)
//  desc: description of the exercise (string)
//  sets: number of sets for the exercise (int)
//  weights: array of [sets] integers. x integer is the weight for x set.
//  reps: array of [sets] integers. x rep is the number of reps for x set.

import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
    @NSManaged var weights: [Int]
    @NSManaged var reps: [Int]
}

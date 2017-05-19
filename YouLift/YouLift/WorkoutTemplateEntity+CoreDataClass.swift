//
//  WorkoutTemplateEntity+CoreDataClass.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  Workout Template Entity class for core data
//  name: name of the workout (string)
//  custom: boolean. True if the workout was created by the user, false if it's a default workout
//  allNames: array of n strings. x string is the name of the xth exercise in the workout
//  allDescriptions: array of n strings. x string is the description of the xth exercise in the workout
//  allSets: array of n integers. x integer is the number of sets for the xth exercise in the workout
//  allWeights: array of > n integers. x:x+sets[i] integers are the weight amounts for each set in the xth exercise of the workout
//  allReps: array of > n integers. x:x+sets[i] integers are the number of repetitions for each set in the xth exercise of the workout

import Foundation
import CoreData

@objc(WorkoutTemplateEntity)
public class WorkoutTemplateEntity: NSManagedObject {
    @NSManaged var allNames: [String]
    @NSManaged var allDescriptions: [String]
    @NSManaged var allSets: [Int]
    @NSManaged var allWeights: [Int]
    @NSManaged var allReps: [Int]
}

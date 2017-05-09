//
//  CompletedWorkoutEntity+CoreDataClass.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import CoreData

@objc(CompletedWorkoutEntity)
public class CompletedWorkoutEntity: NSManagedObject {
    @NSManaged var allNames: [String]
    @NSManaged var allDescriptions: [String]
    @NSManaged var allSets: [Int]
    @NSManaged var allWeights: [Int]
    @NSManaged var allReps: [Int]
}

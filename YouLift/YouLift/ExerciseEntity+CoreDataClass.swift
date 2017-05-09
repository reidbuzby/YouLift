//
//  ExerciseEntity+CoreDataClass.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import CoreData

@objc(ExerciseEntity)
public class ExerciseEntity: NSManagedObject {
    @NSManaged var weights: [Int]
    @NSManaged var reps: [Int]
}

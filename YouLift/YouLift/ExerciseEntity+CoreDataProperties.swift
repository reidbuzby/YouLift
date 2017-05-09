//
//  ExerciseEntity+CoreDataProperties.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var desc: String
    @NSManaged public var sets: Int

}

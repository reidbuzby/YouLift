//
//  WorkoutTemplateEntity+CoreDataProperties.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import CoreData


extension WorkoutTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutTemplateEntity> {
        return NSFetchRequest<WorkoutTemplateEntity>(entityName: "WorkoutTemplateEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var custom: Bool
    //@NSManaged public var exerciseArray: NSObject

}

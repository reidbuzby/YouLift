//
//  CoreDataManager.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func storeExercise(exercise: Exercise) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseEntity", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObj.setValue(exercise.name, forKey: "name")
        managedObj.setValue(exercise.description, forKey: "desc")
        managedObj.setValue(exercise.sets, forKey: "sets")
        
        var weights = [Int]()
        var reps = [Int]()
        //convert setsArray to weights array
        for set in exercise.setsArray {
            weights.append(set.0)
            reps.append(set.1)
        }
        
        managedObj.setValue(weights, forKey: "weights")
        managedObj.setValue(reps, forKey: "reps")
        
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func storeWorkoutTemplate(workout: Workout) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WorkoutTemplateEntity", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObj.setValue(workout.name, forKey: "name")
        
        var names = [String]()
        var descriptions = [String]()
        var sets = [Int]()
        var weights = [Int]()
        var reps = [Int]()
        
        for exercise in workout.exerciseArray {
            names.append(exercise.name)
            descriptions.append(exercise.description)
            sets.append(exercise.sets)
            
            for set in exercise.setsArray {
                weights.append(set.0)
                reps.append(set.1)
            }
        }
        
        managedObj.setValue(names, forKey: "allNames")
        managedObj.setValue(sets, forKey: "allSets")
        managedObj.setValue(descriptions, forKey: "allDescriptions")
        managedObj.setValue(weights, forKey: "allWeights")
        managedObj.setValue(reps, forKey: "allReps")
        managedObj.setValue(true, forKey: "custom")
        
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func storeCompletedWorkout(workout: Workout, date: Date, duration: Double) {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "CompletedWorkoutEntity", in: context)

        //as! CompletedWorkoutEntity

        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObj.setValue(workout.name, forKey: "name")
        managedObj.setValue(date, forKey: "date")
        managedObj.setValue(duration, forKey: "duration")
        
        var names = [String]()
        var descriptions = [String]()
        var sets = [Int]()
        var weights = [Int]()
        var reps = [Int]()
        
        for exercise in workout.exerciseArray {
            names.append(exercise.name)
            descriptions.append(exercise.description)
            sets.append(Int(exercise.sets))
            
            for set in exercise.setsArray {
                weights.append(set.0)
                reps.append(set.1)
            }
        }
        
        managedObj.setValue(names, forKey: "allNames")
        managedObj.setValue(sets, forKey: "allSets")
        managedObj.setValue(descriptions, forKey: "allDescriptions")
        managedObj.setValue(weights, forKey: "allWeights")
        managedObj.setValue(reps, forKey: "allReps")
        
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func convertToExercise(name: String, description: String, sets: Int, weights: [Int], reps: [Int]) -> Exercise {
        
        var setsArray = [(Int, Int)]()
        
        for i in 0..<sets {
            setsArray.append((weights[i], reps[i]))
        }
        
        return Exercise(name: name, description: description, sets: sets, setsArray: setsArray)
    }
    
    class func convertToWorkout(name: String, allNames: [String], allDescriptions: [String], allSets: [Int], allWeights: [Int], allReps: [Int]) -> Workout{
        
        var exerciseArray = [Exercise]()
        
        var weightCount:Int = 0
        
        for i in 0..<allNames.count {
            let weightSlice:[Int] = Array(allWeights[weightCount...weightCount+allSets[i]-1])
            let repSlice:[Int] = Array(allReps[weightCount...weightCount+allSets[i]-1])
            
            exerciseArray.append(convertToExercise(name: allNames[i], description: allDescriptions[i], sets: allSets[i], weights: weightSlice, reps: repSlice))
            
                weightCount += allSets[i]
        }
        
        return Workout(name: name, exercises: exerciseArray)
    }
    
    class func fetchCompletedWorkouts() -> [(Workout, Date, Double)]{
        var workouts = [(Workout, Date, Double)]()
        
        let fetchRequest:NSFetchRequest<CompletedWorkoutEntity> = CompletedWorkoutEntity.fetchRequest()
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for result in fetchResult {
                let newWorkout = convertToWorkout(name: result.name, allNames: result.allNames, allDescriptions: result.allDescriptions, allSets: result.allSets, allWeights: result.allWeights, allReps: result.allReps)
                
                print("HERE!")
                print(newWorkout)
                workouts.append((newWorkout, result.date, result.duration))
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return workouts
    }
    
    class func fetchWorkoutTemplates() -> [(Workout, Bool)] {
        var workouts = [(Workout, Bool)]()
        
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for result in fetchResult {
                let newWorkout = convertToWorkout(name: result.name, allNames: result.allNames, allDescriptions: result.allDescriptions, allSets: result.allSets, allWeights: result.allWeights, allReps: result.allReps)
                
                workouts.append((newWorkout, result.custom))
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return workouts
    }
    
    class func fetchExercises() -> [Exercise] {
        var exercises = [Exercise]()
        
        let fetchRequest:NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for result in fetchResult {
                let newExercise = convertToExercise(name: result.name, description: result.desc, sets: Int(result.sets), weights: result.weights, reps: result.reps)
                exercises.append(newExercise)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return exercises
    }
    
    
    ///fetch all the objects from core data
    //    class func fetchObj() -> [imageItem]{
    //        var aray = [imageItem]()
    //
    //        let fetchRequest:NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
    //
    //        //        var predicate = NSPredicate(format: "name contains[c] %@", "001")
    //        //        predicate = NSPredicate(format: "by == %@" , "wang")
    //        //        predicate = NSPredicate(format: "year > %@", "2012")
    //        //
    //        //        fetchRequest.predicate = predicate
    //
    //        do {
    //            let fetchResult = try getContext().fetch(fetchRequest)
    //
    //            for item in fetchResult {
    //                let img = imageItem(name: item.name!, year: item.year!, by: item.by!)
    //                aray.append(img)
    //                print("image name:"+img.imageName!+"\nimage year:"+img.imageYear!+"\nimage by:"+img.imageBy!+"\n")
    //            }
    //        }catch {
    //            print(error.localizedDescription)
    //        }
    //
    //        return aray
    //    }
    
    //delete all the data in core data
    class func cleanCoreData(entity: String) {
        
        if entity == "CompletedWorkoutEntity" {
            
            let fetchRequest:NSFetchRequest<CompletedWorkoutEntity> = CompletedWorkoutEntity.fetchRequest()
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }

        }else if entity == "WorkoutTemplateEntity" {
            
            let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
            
        }else if entity == "ExerciseEntity" {
            
            let fetchRequest:NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
            
        }else{
            print("ERROR!")
        }
    
        //var predicate = NSPredicate(format: "name contains[c] %@", "1")
        //fetchRequest.predicate = predicate
    
    }
}

//class ManagedExercise: NSManagedObject {
//    @NSManaged var name:String
//    @NSManaged var desc:String
//    @NSManaged var sets:Int
//    @NSManaged var setsArray:[Int: Int]
//}
//
//class ManagedWorkoutTemplate: NSManagedObject {
//    @NSManaged var name:String
//    @NSManaged var exerciseArray:[ManagedExercise]
//}
//
//class ManagedCompletedWorkout: NSManagedObject {
//    @NSManaged var name:String
//    @NSManaged var exerciseArray:[ManagedExercise]
//    @NSManaged var date:Date
//    @NSManaged var duration:Double
//}

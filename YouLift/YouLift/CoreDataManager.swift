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
    
    class func storeExercise(exercise: Exercise) -> Bool{
        let context = getContext()
        
        //perform validation
        
        if exercise.name == "" {
            print("no name given")
            return false
        }
        
        let fetchRequest:NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", exercise.name)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            if fetchResult.count > 0 {
                //if already exercise with the specified name
                print("exercise name already in use")
                return false
            }
            
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //resume storing
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
            return false
        }
        
        return true
    }
    
    class func storeWorkoutTemplate(workout: Workout) -> Bool{
        let context = getContext()
        
        //validate workout Template name
        if workout.name == ""{
            print("no name given for the workout")
            return false
        }
        
        if workout.exerciseArray.count < 1 {
            print("no exercises...")
            return false
        }
        
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", workout.name)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            if fetchResult.count > 0 {
                //if already template with the specified name
                print("already a workout with this name")
                return false
            }
        
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //resume storing
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
            return false
        }
        
        return true
    }
    
    class func storeCompletedWorkout(workout: Workout, date: Date, duration: Double) -> Bool{
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
            return false
        }
        
        return true
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
    
    class func updateWorkoutTemplate(workout: Workout) {
        
        deleteWorkoutTemplate(workout: workout)
        
        do {

            storeWorkoutTemplate(workout: workout)
            try getContext().save()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    class func deleteWorkoutTemplate(workout: Workout){
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", workout.name)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            
            try getContext().execute(deleteRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    //fetch and delete and make new with changes and save
    
    
    
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
    
    
    class func storeDefaultWorkouts(){
        let workoutOne = Workout(name: "Leg Day", exercises: [
            Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slowly stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
            Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name: "Deadlift", description: "Grab the weight on the floor with an overhand grip and pull it up to your thighs while keeping your lower back straight, lower weight back to floor and repeat.", sets: 3, setsArray: [(75, 5), (100, 5), (125, 5)]),
            Exercise(name: "Leg Curl", description: "Sit on the machine with the back of your lower legs on the padded lever, pull the lever back to your thighs slowly return to the start position and repeat.", sets: 3, setsArray: [(120, 3), (120, 3), (120, 3)]),
            Exercise(name: "Calf Raises", description: "Stand on the edge of a step with the balls of your feet on it, and raise your heels a few inches, hold it for a second, lower, and repeat.", sets: 3, setsArray: [(100, 4), (100, 4), (100, 4)])])
        
        let workoutTwo = Workout(name: "Try Hard", exercises: [
            Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(200, 3), (200, 3), (200, 3)]),
            Exercise(name: "Deadlift", description: "Grab the weight on the floor with an overhand grip and pull it up to your thighs while keeping your lower back straight, lower weight back to floor and repeat.", sets: 3, setsArray: [(100, 5), (100, 5), (100, 5)]),
            Exercise(name: "Floor Press", description: "Lie on the floor on your back and hold two dumbells on your chest, explosively press teh dumbells up and then slowly lower them.", sets: 3, setsArray: [(80, 4), (80, 4), (100, 4)]),
            Exercise(name: "Leg Curl", description: "Sit on the machine with the back of your lower legs on the padded lever, pull the lever back to your thighs slowly return to the start position and repeat.", sets: 3, setsArray: [(75, 5), (75, 5), (75, 5)]),
            Exercise(name: "Bicep Curl", description: "Hold a dumbbell in each hand at arm's length, keep your elbows close to your torso and rotate the palms of your hands until they are facing forward. This will be your starting position. Keeping the upper arms stationary curl the weights while contracting your biceps.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name: "Ab Crunch", description: "Sit in the ab crunch machine and place your feet under the pads and grab the top handles. Lift your legs and crunch your torso in, hold it for a second and slowly return to the starting position.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])])
        
        let workoutThree = Workout(name: "Sunday Morning", exercises: [
            Exercise(name: "Bicep Curl", description: "Hold a dumbbell in each hand at arm's length, keep your elbows close to your torso and rotate the palms of your hands until they are facing forward. This will be your starting position. Keeping the upper arms stationary curl the weights while contracting your biceps.", sets: 3, setsArray: [(75, 3), (75, 3), (75, 3)]),
            Exercise(name: "Shoulder Press", description: "Sitting down, hold the dumbbells at ear level, push the dumbells so they touch above your head and slowly lower them back down.", sets: 3, setsArray: [(50, 2), (50, 2), (50, 2)]),
            Exercise(name: "Floor Press", description: "Lie on the floor on your back and hold two dumbells on your chest, explosively press teh dumbells up and then slowly lower them.", sets: 3, setsArray: [(50, 3), (50, 3), (50, 3)]),
            Exercise(name: "Ab Crunch", description: "Sit in the ab crunch machine and place your feet under the pads and grab the top handles. Lift your legs and crunch your torso in, hold it for a second and slowly return to the starting position.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slowly stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
            Exercise(name: "Calf Raises", description: "Stand on the edge of a step with the balls of your feet on it, and raise your heels a few inches, hold it for a second, lower, and repeat.", sets: 3, setsArray: [(40, 3), (40, 3), (40, 3)])])
        
        tempStoreDefaultWorkoutTemplate(workout: workoutOne)
        tempStoreDefaultWorkoutTemplate(workout: workoutTwo)
        tempStoreDefaultWorkoutTemplate(workout: workoutThree)
        
        
    }
    
    class func tempStoreDefaultWorkoutTemplate(workout: Workout) -> Bool{
        let context = getContext()
        
        //validate workout Template name
        if workout.name == ""{
            print("no name given for the workout")
            return false
        }
        
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", workout.name)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            if fetchResult.count > 0 {
                //if already template with the specified name
                print("already a workout with this name")
                return false
            }
            
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //resume storing
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
        managedObj.setValue(false, forKey: "custom")
        
        do {
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
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

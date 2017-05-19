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

//  Manages all interaction with Core Data (fetching, saving, etc.)
class CoreDataManager: NSObject {
    
    //  get the current context
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    //  save an exercise to core data - returns false if the save fails
    class func storeExercise(exercise: Exercise) -> Bool{
        
        //  get the context
        let context = getContext()
        
        //  check that a name was given
        if exercise.name == "" {
            print("no name given")
            return false
        }
        
        let fetchRequest:NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", exercise.name)
        fetchRequest.predicate = predicate
        
        do {
            //  attempt to fetch any exercises with the same name
            let fetchResult = try getContext().fetch(fetchRequest)
            
            //  if any exercises with the same name exist, return false
            if fetchResult.count > 0 {
                print("exercise name already in use")
                return false
            }
            
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //  create a new exercise entity
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseEntity", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        //  assign the exercise data to the new object
        managedObj.setValue(exercise.name, forKey: "name")
        managedObj.setValue(exercise.description, forKey: "desc")
        managedObj.setValue(exercise.sets, forKey: "sets")
        
        var weights = [Int]()
        var reps = [Int]()
        
        //  convert setsArray to separate weights and reps arrays
        for set in exercise.setsArray {
            weights.append(set.0)
            reps.append(set.1)
        }
        
        //  assign the new arrays to the new object
        managedObj.setValue(weights, forKey: "weights")
        managedObj.setValue(reps, forKey: "reps")
        
        do {
            //  try to save the exercise
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //  return true if no errors were found
        return true
    }
    
    //  save a workout template to core data - returns false if the save fails
    class func storeWorkoutTemplate(workout: Workout, custom: Bool) -> Bool{
        
        //  get the context
        let context = getContext()
        
        //  check that the workout is named
        if workout.name == ""{
            print("no name given for the workout")
            return false
        }
        
        //  check that the template has at least one exercise
        if workout.exerciseArray.count < 1 {
            print("no exercises...")
            return false
        }
        
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", workout.name)
        fetchRequest.predicate = predicate
        
        do {
            //  fetch any workout templates with the same name
            let fetchResult = try getContext().fetch(fetchRequest)
            
            //  if any template already has this name, return false
            if fetchResult.count > 0 {
                print("already a workout with this name")
                return false
            }
        
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //  create a new workout template entity
        let entity = NSEntityDescription.entity(forEntityName: "WorkoutTemplateEntity", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        //  assign the template data to the new object
        managedObj.setValue(workout.name, forKey: "name")
        
        var names = [String]()
        var descriptions = [String]()
        var sets = [Int]()
        var weights = [Int]()
        var reps = [Int]()
        
        //  convert exerciseArray to a store-able format (separate arrays)
        for exercise in workout.exerciseArray {
            names.append(exercise.name)
            descriptions.append(exercise.description)
            sets.append(exercise.sets)
            
            for set in exercise.setsArray {
                weights.append(set.0)
                reps.append(set.1)
            }
        }
        
        //  assign the template data to the new object
        managedObj.setValue(names, forKey: "allNames")
        managedObj.setValue(sets, forKey: "allSets")
        managedObj.setValue(descriptions, forKey: "allDescriptions")
        managedObj.setValue(weights, forKey: "allWeights")
        managedObj.setValue(reps, forKey: "allReps")
        managedObj.setValue(custom, forKey: "custom")
        
        do {
            //  try to save the workout template
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //  return true if no errors were found
        return true
    }
    
    //  save a completed workout to core data - return false if the save fails
    class func storeCompletedWorkout(workout: Workout, date: Date, duration: Double) -> Bool{
        
        //  get the context
        let context = getContext()
        
        //  create a new completed workout entity
        let entity = NSEntityDescription.entity(forEntityName: "CompletedWorkoutEntity", in: context)
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        //  assign the workout data to the new object
        managedObj.setValue(workout.name, forKey: "name")
        managedObj.setValue(date, forKey: "date")
        managedObj.setValue(duration, forKey: "duration")
        
        var names = [String]()
        var descriptions = [String]()
        var sets = [Int]()
        var weights = [Int]()
        var reps = [Int]()
        
        
        //  convert exerciseArray to a store-able format (separate arrays)
        for exercise in workout.exerciseArray {
            names.append(exercise.name)
            descriptions.append(exercise.description)
            sets.append(Int(exercise.sets))
            
            for set in exercise.setsArray {
                weights.append(set.0)
                reps.append(set.1)
            }
        }
        
        
        //  assign the exericse data to the new object
        managedObj.setValue(names, forKey: "allNames")
        managedObj.setValue(sets, forKey: "allSets")
        managedObj.setValue(descriptions, forKey: "allDescriptions")
        managedObj.setValue(weights, forKey: "allWeights")
        managedObj.setValue(reps, forKey: "allReps")
        
        do {
            //  try to save the completed workout
            try context.save()
            print("saved!")
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        //  return true if no errors were found
        return true
    }
    
    //  convert a core data exercise entity to an exercise object
    class func convertToExercise(name: String, description: String, sets: Int, weights: [Int], reps: [Int]) -> Exercise {
        
        var setsArray = [(Int, Int)]()
        
        //  convert the entity's weights/reps arrays to an array of tuples
        for i in 0..<sets {
            setsArray.append((weights[i], reps[i]))
        }
        
        //  return a new exercise object with the entity's data
        return Exercise(name: name, description: description, sets: sets, setsArray: setsArray)
    }
    
    //  convert a core data workout template/completed workout entity to a workout object
    class func convertToWorkout(name: String, allNames: [String], allDescriptions: [String], allSets: [Int], allWeights: [Int], allReps: [Int]) -> Workout{
        
        var exerciseArray = [Exercise]()
        var weightCount:Int = 0
        
        //  iterate through each stored exercise
        for i in 0..<allNames.count {
            
            //  get the exercise's respective weights and reps
            let weightSlice:[Int] = Array(allWeights[weightCount...weightCount+allSets[i]-1])
            let repSlice:[Int] = Array(allReps[weightCount...weightCount+allSets[i]-1])
            
            //  convert the exercise data to an exercise object
            exerciseArray.append(convertToExercise(name: allNames[i], description: allDescriptions[i], sets: allSets[i], weights: weightSlice, reps: repSlice))
            
            weightCount += allSets[i]
        }
        
        //  return the new workout object
        return Workout(name: name, exercises: exerciseArray)
    }
    
    //  fetch all completed workouts from core data
    class func fetchCompletedWorkouts() -> [(Workout, Date, Double)]{
        //  return an array of workouts, each with its date and duration
        var workouts = [(Workout, Date, Double)]()
        
        let fetchRequest:NSFetchRequest<CompletedWorkoutEntity> = CompletedWorkoutEntity.fetchRequest()
        
        do {
            //  try to fetch all completed workouts
            let fetchResult = try getContext().fetch(fetchRequest)
            
            
            //  convert each completed workout entity to a workout object
            for result in fetchResult {
                let newWorkout = convertToWorkout(name: result.name, allNames: result.allNames, allDescriptions: result.allDescriptions, allSets: result.allSets, allWeights: result.allWeights, allReps: result.allReps)
                
                workouts.append((newWorkout, result.date, result.duration))
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        //  return the list of workout objects/dates/durations
        return workouts
    }
    
    //  fetch all workout templates from core data
    class func fetchWorkoutTemplates() -> [(Workout, Bool)] {
        //  return an array of workouts, each with a boolean signifying if it's custom or not
        var workouts = [(Workout, Bool)]()
        
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        
        do {
            //  try to fetch all workout template
            let fetchResult = try getContext().fetch(fetchRequest)
            
            //  convert each workout template entity to a workout object
            for result in fetchResult {
                let newWorkout = convertToWorkout(name: result.name, allNames: result.allNames, allDescriptions: result.allDescriptions, allSets: result.allSets, allWeights: result.allWeights, allReps: result.allReps)
                
                workouts.append((newWorkout, result.custom))
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        //  return the list of workout objects/custom status
        return workouts
    }
    
    //  fetch all exercises from core data
    class func fetchExercises() -> [Exercise] {
        //  return an array of exercise objects
        var exercises = [Exercise]()
        
        let fetchRequest:NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        
        do {
            //  try to fetch all exercises
            let fetchResult = try getContext().fetch(fetchRequest)
            
            
            //  convert each exercise entity to an exercise object
            for result in fetchResult {
                let newExercise = convertToExercise(name: result.name, description: result.desc, sets: Int(result.sets), weights: result.weights, reps: result.reps)
                
                exercises.append(newExercise)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        //  return the array of exercise objects
        return exercises
    }
    
    //  update an existing workout template
    class func updateWorkoutTemplate(workout: Workout, custom: Bool) {
        
        //  delete the previously existing workout template
        deleteWorkoutTemplate(workout: workout)
        
        do {
            //  try and store the new workout template
            storeWorkoutTemplate(workout: workout, custom: custom)
            try getContext().save()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //  delete an existing workout template
    class func deleteWorkoutTemplate(workout: Workout){
        let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", workout.name)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            //  try and delete the existing workout template (based on workout name)
            try getContext().execute(deleteRequest)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
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

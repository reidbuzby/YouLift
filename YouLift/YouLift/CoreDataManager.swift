//
//  CoreDataManager.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  CoreDataManager holds all the functions to for interacting with core data. Saving, fetching, deleting, and converting between core data entities and exercise/workout objects are all handled here.

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
    
    //  function to fetch data on all completed exercises
    class func fetchCompletedExercises() -> [ExerciseStats] {
        let workouts = fetchCompletedWorkouts()
        var exercises = [ExerciseStats]()
        var dup = -1
        
        //  cycle through each completed workout
        for workout in workouts {
            let exrcs = workout.0.exerciseArray
            
            //  cycle through each exercise in that workout, parse the weight/reps data, and add it to the relevant exercise stats object
            for e in exrcs {
                if exercises.count > 0 {
                    dup = -1
                    for i in 0 ..< exercises.count {
                        if exercises[i].exercise.name == e.name {
                            dup = i
                            break
                        }
                    }
                    if dup != -1 {
                        var avgWeight = 0.0
                        var avgReps = 0.0
                        for weight in e.setsArray {
                            avgWeight = avgWeight + Double(weight.0)
                        }
                        for reps in e.setsArray {
                            avgReps = avgReps +  Double(reps.1)
                        }
                        avgWeight = avgWeight / Double(e.sets)
                        avgReps = avgReps / Double(e.sets)
                        
                        let onerepmax = avgWeight/(1.0278 - (0.0278 * Double(avgReps)))
                        
                        exercises[dup].data.append((onerepmax, workout.1))
                    }
                    else {
                        var avgWeight = 0.0
                        var avgReps = 0.0
                        for weight in e.setsArray {
                            avgWeight = avgWeight + Double(weight.0)
                        }
                        for reps in e.setsArray {
                            avgReps = avgReps +  Double(reps.1)
                        }
                        avgWeight = avgWeight / Double(e.sets)
                        avgReps = avgReps / Double(e.sets)
                        
                        let onerepmax = avgWeight/(1.0278 - (0.0278 * Double(avgReps)))
                        
                        exercises.append(ExerciseStats(exercise: e, data: [(onerepmax, workout.1)]))
                    }
                    
                }
                else {
                    var avgWeight = 0.0
                    var avgReps = 0.0
                    for weight in e.setsArray {
                        avgWeight = avgWeight + Double(weight.0)
                    }
                    for reps in e.setsArray {
                        avgReps = avgReps +  Double(reps.1)
                    }
                    avgWeight = avgWeight / Double(e.sets)
                    avgReps = avgReps / Double(e.sets)
                    
                    let onerepmax = avgWeight/(1.0278 - (0.0278 * Double(avgReps)))
                    
                    exercises.append(ExerciseStats(exercise: e, data: [(onerepmax, workout.1)]))
                }
            }
        }
        
        //  return the exercise statistics on all exercises
        return exercises
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
    
    //  store the current default workouts
    class func storeDefaultWorkouts(){
        
        //  get the current default workouts
        let defaultWorkouts = DefaultWorkouts().workouts
        
        //  save each to core data
        for workout in defaultWorkouts{
            storeWorkoutTemplate(workout: workout, custom: false)
            
            //  save the individual exercises as well
            for exercise in workout.exerciseArray{
                storeExercise(exercise: exercise)
            }
        }
        
    }
    
    //  delete all the data for a given entity in core data
    class func cleanCoreData(entity: String) {
        
        //  delete all completed workouts
        if entity == "CompletedWorkoutEntity" {
            
            let fetchRequest:NSFetchRequest<CompletedWorkoutEntity> = CompletedWorkoutEntity.fetchRequest()
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }

        //  delete all workout templates
        }else if entity == "WorkoutTemplateEntity" {
            
            let fetchRequest:NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                print("deleting all contents")
                try getContext().execute(deleteRequest)
            }catch {
                print(error.localizedDescription)
            }
            
        //  delete all exercises
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
    
    }
}

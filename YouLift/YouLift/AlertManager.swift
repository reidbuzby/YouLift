//
//  AlertManager.swift
//  YouLift
//
//  Created by Andrew Garland on 5/10/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  Class that manages all possible alerts/prompts that could be called (saving, finishing, deleting, etc.)

import Foundation
import UIKit

//  class to manage all alerts
class AlertManager: UIAlertController{

    //  alert prompt that should appear when the user indicates they are finished with their workout
    class func finishAlert(sender: WorkoutDetailViewController, workout: Workout, date: Date, duration: Double){
        
        //  lets the user either finish or resume their workout
        let alert = UIAlertController(title: "Finish", message: "Would you like to end the workout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in })
        alert.addAction(UIAlertAction(title: "Finish", style: .default) { action in

            //  store the completed workout in core data
            CoreDataManager.storeCompletedWorkout(workout: workout, date: date, duration: duration)

            //  return to the workouts home page.
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        //  present the alert
        sender.present(alert, animated: true)
    }
    
    //  alert prompt that should appear when the user indicates they want to cancel their workout
    class func cancelAlert(sender: WorkoutDetailViewController){
        
        //  lets the user either cancel or resume their workout
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you would like to cancel your workout? None of your data will be recorded.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in })
        alert.addAction(UIAlertAction(title: "Cancel Workout", style: .default) { action in
            
            //  return to the workouts home page without saving any data
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        //  present the alert
        sender.present(alert, animated: true)
    }
    
    //  alert prompt that should appear when the user indicates they want to delete an existing workout template
    class func deleteAlert(sender: WorkoutDetailViewController, workout: Workout){
        
        //  lets user either delete the workout or resume
        let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you would like to delete the workout? This cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in })
        alert.addAction(UIAlertAction(title: "Delete Workout", style: .default) { action in

            //  delete the workout from core data
            CoreDataManager.deleteWorkoutTemplate(workout: workout)
            
            //  return to the workouts home page
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        //  present the alert
        sender.present(alert, animated: true)
    }
    
    //  alert prompt that should appear when the user indicates they would like to save a new workout template
    class func saveAlert(sender: CreateWorkoutTableViewController, workout: Workout, custom: Bool){
        
        //  lets user either save the workout or cancel
        let alert = UIAlertController(title: "Save Workout", message: "Are you sure that you would like to save this workout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in })
        alert.addAction(UIAlertAction(title: "Save", style: .default) { action in

            //  try to save the workout template in core data
            if CoreDataManager.storeWorkoutTemplate(workout: workout, custom: custom) {
                
                //  if successful, remove the exercises from the create view and navigate away
                sender.exercises.removeAll()
                sender.performSegue(withIdentifier: "Done", sender: self)
                
            //  if saving was unsuccessful
            } else {
                
                //  if there were no exercises in the workout
                if workout.exerciseArray.count == 0 {
                    
                    //  alert the user they need at least one exercise in the workout template
                    let invalidAlert = UIAlertController(title: "Error", message: "Please add at least one exercise to the workout.", preferredStyle: .alert)
                    invalidAlert.addAction(UIAlertAction(title: "Ok", style: .cancel) { action in })
                    
                    //  present the alert
                    sender.present(invalidAlert, animated: true)
                    
                //  otherwise an invalid name was given
                } else {
                    
                    //  send a name validation error alert
                    nameValidationError(sender: sender, name: workout.name)
                }
            }
        })
        
        //  present the alert
        sender.present(alert, animated: true)
    }
    
    //  alert prompt that should appear when the user tries use an invalid exercise/workout name
    class func nameValidationError(sender: UIViewController, name: String){
        
        var alert = UIAlertController()
        
        //  if no name was given
        if name == "" {
            alert = UIAlertController(title: "Error", message: "Please enter a valid name.", preferredStyle: .alert)
            
        //  if the name is already in use
        }else{
            alert = UIAlertController(title: "Error", message: "This name is already in use. Please enter another.", preferredStyle: .alert)
        }
        
        //  let the user continue
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { action in })
        
        //  present the alert
        sender.present(alert, animated: true)
    }
    
}

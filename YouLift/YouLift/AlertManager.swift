//
//  AlertManager.swift
//  YouLift
//
//  Created by Andrew Garland on 5/10/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import UIKit

class AlertManager: UIAlertController{

    class func finishAlert(sender: WorkoutDetailViewController, workout: Workout, date: Date, duration: Double){
        
        let alert = UIAlertController(title: "Finish", message: "Would you like to end the workout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in
            // perhaps use action.title here
            //print(false)
        })
        
        alert.addAction(UIAlertAction(title: "Finish", style: .default) { action in
            // perhaps use action.title here
            CoreDataManager.storeCompletedWorkout(workout: workout, date: date, duration: duration)
            
            //takes me to new version? has back button that takes me back to the workout
            //sender.performSegue(withIdentifier: "FinishWorkout", sender: sender)
            
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        sender.present(alert, animated: true)
        
    }
    
    class func cancelAlert(sender: WorkoutDetailViewController){
        
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you would like to cancel your workout? None of your data will be recorded.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in
            // perhaps use action.title here
            //print(false)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel Workout", style: .default) { action in
            // perhaps use action.title here

            //sender.performSegue(withIdentifier: "FinishWorkout", sender: sender)
            
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        sender.present(alert, animated: true)
        
    }
    
    class func deleteAlert(sender: WorkoutDetailViewController, workout: Workout){
        
        let alert = UIAlertController(title: "Delete Workout", message: "Are you sure you would like to delete the workout? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Resume", style: .cancel) { action in
            // perhaps use action.title here
            //print(false)
        })
        
        alert.addAction(UIAlertAction(title: "Delete Workout", style: .default) { action in
            // perhaps use action.title here
            
            //sender.performSegue(withIdentifier: "FinishWorkout", sender: sender)
            
            CoreDataManager.deleteWorkoutTemplate(workout: workout)
            sender.navigationController?.popToRootViewController(animated: true)
        })
        
        sender.present(alert, animated: true)
        
    }
    
    class func saveAlert(sender: CreateWorkoutTableViewController, workout: Workout, custom: Bool){
        
        let alert = UIAlertController(title: "Save Workout", message: "Are you sure that you would like to save this workout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            // perhaps use action.title here
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { action in
            // perhaps use action.title here
            
            if CoreDataManager.storeWorkoutTemplate(workout: workout, custom: custom) {
                //navigate away
                
                sender.exercises.removeAll()
                
                sender.performSegue(withIdentifier: "Done", sender: self)
                
            } else {
                
                if workout.exerciseArray.count == 0 {
                    let invalidAlert = UIAlertController(title: "Error", message: "Please add at least one exercise to the workout.", preferredStyle: .alert)
                    invalidAlert.addAction(UIAlertAction(title: "Ok", style: .cancel) { action in
                        // perhaps use action.title here
                    })
                    
                    sender.present(invalidAlert, animated: true)
                } else {
                    nameValidationError(sender: sender, name: workout.name)
                }
            }
        })
        
        sender.present(alert, animated: true)
    }
    
    class func nameValidationError(sender: UIViewController, name: String){
        
        var alert = UIAlertController()
        
        if name == "" {
            alert = UIAlertController(title: "Error", message: "Please enter a valid name.", preferredStyle: .alert)
        }else{
            alert = UIAlertController(title: "Error", message: "This name is already in use. Please enter another.", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { action in
            // perhaps use action.title here
        })
        
        //may or may not have to add actions to dismiss. Haven't tested yet.
        
        sender.present(alert, animated: true)
    }
    
//    class func restTimerAlert(){
//        
//    }
    
}

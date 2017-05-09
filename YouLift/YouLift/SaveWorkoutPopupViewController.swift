//
//  SaveWorkoutPopupViewController.swift
//  YouLift
//
//  Created by rbuzby on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit
import CoreData

class SaveWorkoutPopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var workout = Workout()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keepEditing(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveWorkout(_ sender: Any) {
        CoreDataManager.storeWorkoutTemplate(workout: workout)
        
        for exercise in workout.exerciseArray {
            CoreDataManager.storeExercise(exercise: exercise)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

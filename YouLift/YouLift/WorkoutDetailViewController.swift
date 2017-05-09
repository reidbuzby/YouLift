//
//  WorkoutDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, writeValueBackDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var workout = Workout()
    var exercises = [Exercise]()
    var editButton:UIBarButtonItem?
    var doneButton:UIBarButtonItem?
    
    @IBOutlet weak var workoutName: UILabel!
    
    @IBOutlet weak var durationTimer: UILabel!
    var startTime:Date?
    var timer:Timer = Timer()
    
    var inProgress:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        workoutName.text = self.workout.name
        
        exercises = self.workout.exerciseArray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if inProgress != nil {
            updateTimer()
            
            editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.edit(sender:)))
            self.navigationItem.rightBarButtonItem = editButton
            
            doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.doneEditing(sender:)))
            
        } else {
            inProgress = false
        }
    }
    
    func edit(sender: UIBarButtonItem){
        self.tableView.setEditing(true, animated: true)
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func doneEditing(sender: UIBarButtonItem){
        self.tableView.setEditing(false, animated: true)
        self.navigationItem.rightBarButtonItem = editButton
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as? ExerciseTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        // Configure the cell...
        let exercise = exercises[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        var exerciseToMove = exercises[fromIndexPath.row]
        exercises.remove(at: fromIndexPath.row)
        exercises.insert(exerciseToMove, at: toIndexPath.row)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Table View Stuff
    
    
    @IBAction func finishButton(_ sender: UIButton) {
    }
    
    func updateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayDuration), userInfo: nil, repeats: true)
    }
    
    func displayDuration() {
        let duration = Date().timeIntervalSince(startTime!)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        durationTimer.text = "Duration: " + String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func writeValueBack(value: [Exercise], next: Int) {
        // Or any other function you need to transport data
        let indexPath = self.tableView.indexPathForSelectedRow
        exercises = value
        
        if next != -1 {
            //_ = navigationController?.popViewController(animated: false)
            performSegue(withIdentifier: "ViewExercise", sender: next)
            if let nav = self.navigationController {
                var stack = nav.viewControllers
                // index starts at 0 so page three index is 2
                stack.remove(at: stack.count-2)
                nav.setViewControllers(stack, animated: false)
            }
        } else{
            tableView.reloadData()
        }
    }
    
    func updateWorkout(){
        workout = Workout(name: workout.name, exercises: exercises)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        case "ViewExercise":
            
            guard let destination = segue.destination as? ExerciseDetailViewController else{
                
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                
                guard let transition = sender as? Int else{
                    fatalError("Unexpected sender: \(sender)")
                }
                
                let exercise = exercises[transition]
                
                destination.exercise = exercise
                destination.exercises = exercises
                destination.currIndex = transition
                destination.inProgress = inProgress!
                destination.delegate = self
                
                return
                
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises[indexPath.row]
            
            destination.exercise = exercise
            destination.exercises = exercises
            destination.currIndex = indexPath.row
            destination.inProgress = inProgress!
            destination.delegate = self
            
        //begin a workout
        case "StartWorkout":
            
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.workout = workout
            destination.navigationItem.hidesBackButton = true
            destination.startTime = Date()
            destination.inProgress = true
            
        //end a workout
        case "FinishWorkout":
            guard let destination = segue.destination as? PopUpViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            updateWorkout()
            destination.workout = workout
            destination.duration = Date().timeIntervalSince(startTime!)
            
        case "AddExercise":
            guard let destination = segue.destination as? ExerciseTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.inProgress = inProgress!
            destination.currWorkout = exercises
            destination.delegate = self
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
        
    }

}

//
//  WorkoutDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  View controller for an individual workout. Holds one table with a list of exercises. Has various buttons/displays depending on state (in progress or not)

import UIKit

class WorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, writeValueBackDelegate {
    
    //  table for the workout data (exercises)
    @IBOutlet weak var tableView: UITableView!
    
    //  variables to keep track of the workout data
    var custom:Bool?
    var workout = Workout()
    var exercises = [Exercise]()
    
    //  custom button variables for editing
    var editButton:UIBarButtonItem?
    var doneButton:UIBarButtonItem?
    
    //  variables to track workout time/date
    var startTime:Date?
    var timer:Timer = Timer()
    
    //  if the workout is in progress or not
    var inProgress:Bool?
    
    //  if the workout has just begun
    var firstCall:Bool = false
    
    //  button outlets
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var add: UIButton!
    
    //  label for the workout name
    @IBOutlet weak var workoutName: UILabel!
    
    //  label to display the workout's duration
    @IBOutlet weak var durationTimer: UILabel!
    
    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the view title to YouLift
        navigationItem.title = "YouLift"
        
        //  set the view's background color
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        //  customize the appearance of the table
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = true;
        self.tableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)

        
        //  customize the appearance of buttons
        if addExerciseButton != nil {
            customizeButtonAppearance(button: addExerciseButton)
        }
        
        if add != nil {
            customizeButtonAppearance(button: add)
        }
        
        if finish != nil {
            customizeButtonAppearance(button: finish)
        }
        
        if startButton != nil {
            customizeButtonAppearance(button: startButton)
        }
        
        if deleteButton != nil {
            deleteButton.layer.cornerRadius = 4
            deleteButton.backgroundColor = UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1)
            deleteButton.layer.borderWidth = 1
        }

        //  set the workout name label to be the workout's name
        workoutName.text = self.workout.name
        
        //  set the var exercises to be the workout's exercises
        exercises = self.workout.exerciseArray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false;
        
        //  create custom edit and done bar buttons for editing the workout. Display the edit button
        editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.edit(sender:)))
        self.navigationItem.rightBarButtonItem = editButton
        
        doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.doneEditing(sender:)))
        
        //  create and use a custom back button
        self.navigationItem.hidesBackButton = true
        let defaultBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.defaultBack(sender:)))
        self.navigationItem.leftBarButtonItem = defaultBackButton
        
        //  if the workout is in progress
        if inProgress != nil {
            
            //  if the workout has just begun, jump into the first exercise
            if firstCall {
                performSegue(withIdentifier: "ViewExercise", sender: 0)
            }
            
            //  start the duration timer
            updateTimer()
            
            //  replace the back button with a button to cancel the workout
            self.navigationItem.hidesBackButton = true
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WorkoutDetailViewController.cancelButton(sender:)))
            self.navigationItem.leftBarButtonItem = cancelButton
            
        //  hide various buttons if the workout is not in progress
        } else {
            inProgress = false
            deleteButton.isHidden = true
            addExerciseButton.isHidden = true
        }
    }
    
    //  whenever the view appears, set the view title to YouLift
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "YouLift"
    }
    
    //  customize the appearance of a button
    func customizeButtonAppearance(button: UIButton) {
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
    }
    
    //  custom back button function -- pop off the current view when pressed
    func defaultBack(sender:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //  custom cancel button function -- present a cancel alert when pressed
    func cancelButton(sender: UIBarButtonItem){
        AlertManager.cancelAlert(sender: self)
    }
    
    //  custom edit button function - switch table mode to editing when pressed
    func edit(sender: UIBarButtonItem){
        self.tableView.setEditing(true, animated: true)
        
        //  switch edit button to done button
        self.navigationItem.rightBarButtonItem = doneButton
        
        //  if the workout is not in progess, show/hide various buttons
        if !inProgress! {
            startButton.isHidden = true
            deleteButton.isHidden = false
            addExerciseButton.isHidden = false
        }
    }
    
    //  custom done button function -- stop editing
    func doneEditing(sender: UIBarButtonItem){
        self.tableView.setEditing(false, animated: true)
        
        //  switch done button to edit button
        self.navigationItem.rightBarButtonItem = editButton
        
        //  reload the table
        tableView.reloadData()
        
        //  if the workout is not in progress
        if !inProgress! {
            
            //  show/hide various buttons
            deleteButton.isHidden = true
            addExerciseButton.isHidden = true
            startButton.isHidden = false
            
            //  update the current workout variables
            updateWorkout()
            
            //  update the workout template in core data
            CoreDataManager.updateWorkoutTemplate(workout: workout, custom: custom!)
        }
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
        
        //  configure the cell
        let exercise = exercises[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
        var exerciseToMove = exercises[fromIndexPath.row]
        
        //  update exercise order when the user reorders the table
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
            
            //  update exercise list and table when the user deletes an exercise
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //  custom finish button --  present a finish alert when pressed
    @IBAction func finishButton(_ sender: UIButton) {
        //  update the current workout variables
        updateWorkout()
        
        AlertManager.finishAlert(sender: self, workout: workout, date: Date(), duration: Date().timeIntervalSince(startTime!))
    }
    
    //  custom delete button -- present a delete alert when pressed
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButton(_ sender: UIButton) {
        AlertManager.deleteAlert(sender: self, workout: workout)
    }
    
    //  additional custom button outlets
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    //  function to update the duration timer every second
    func updateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayDuration), userInfo: nil, repeats: true)
    }
    
    //  function that sets the duration label
    func displayDuration() {
        //  convert the current duration to hh:mm:ss format
        let duration = Date().timeIntervalSince(startTime!)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        //  set the duration label to the duration
        durationTimer.text = "Duration: " + String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //  function used for writing back workout data from a delegate
    //  value: an updated array of exercise objects
    //  next: indicates the next exercise index to load (-1 for none)
    func writeValueBack(value: [Exercise], next: Int) {
        
        //let indexPath = self.tableView.indexPathForSelectedRow?.row ?? 0
        
        //  update exercises
        exercises = value
        
        //  if another exercise to segue to was indicated
        if next != -1 {

            //  segue to the next (indicated) exercise
            performSegue(withIdentifier: "ViewExercise", sender: next)

            //  remove excess views from the stack
            if let nav = self.navigationController {
                var stack = nav.viewControllers
                // index starts at 0 so page three index is 2
                stack.remove(at: stack.count-2)
                nav.setViewControllers(stack, animated: false)
            }
            
        //  if no other exercise was indicated, remain on this view and reload the table
        } else {
            tableView.reloadData()
        }
    }
    
    //  update the current workout variable (exercises may have changed)
    func updateWorkout(){
        workout = Workout(name: workout.name, exercises: exercises)
    }
    
    //  code to be run prior to segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
          
        //  if viewing an exercise
        case "ViewExercise":
            
            //  validate the sender/destination
            guard let destination = segue.destination as? ExerciseDetailViewController else{
                
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                
                //  if being called by exercise's next/previous button
                
                guard let transition = sender as? Int else{
                    fatalError("Unexpected sender: \(sender)")
                }
                
                
                let exercise = exercises[transition]
                
                //  pass along the relevant workout information
                destination.exercise = exercise
                destination.exercises = exercises
                destination.currIndex = transition
                destination.inProgress = inProgress!
                destination.delegate = self
                
                return
                
            }
            
            //  if called when selecting and exercise from the table
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises[indexPath.row]
            
            //  pass along the relevant workout information
            destination.exercise = exercise
            destination.exercises = exercises
            destination.currIndex = indexPath.row
            destination.inProgress = inProgress!
            destination.delegate = self
            
        //  if beginning a workout
        case "StartWorkout":
            
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //  update the workout variable
            updateWorkout()
            
            //  pass along the relevant workout information
            destination.workout = workout
            destination.navigationItem.hidesBackButton = true
            destination.startTime = Date()
            destination.inProgress = true
            destination.firstCall = true
            
        //  if adding an exercise to the workout
        case "AddExercise":
            
            guard let destination = segue.destination as? SelectExerciseTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            navigationItem.title = "Back"
            
            //  pass along the relevant workout information
            destination.existing = true
            destination.workout = exercises
            destination.delegate = self
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
        
    }

}

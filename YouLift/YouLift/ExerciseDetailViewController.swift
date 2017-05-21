//
//  ExerciseDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  View controller for an individual exercise. Displays the exercise name, description, and has a table of set data (weight/reps)

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //  delegate
    var delegate: writeValueBackDelegate?
    
    //  if the workout is in progress
    var inProgress:Bool = false
    
    //  current exercise/workout data
    var exercise = Exercise()
    var exercises = [Exercise]()
    var sets = 0
    var setsArray = [(Int, Int)]()
    
    //  position within the workout
    var currIndex = 0
    var transitionIndex = 0
    
    //  label for the exercise name
    @IBOutlet weak var exerciseName: UILabel!
    
    //  custom button to add a new set
    @IBOutlet weak var addSetButton: UIButton!
    
    //  label for the exercise description
    @IBOutlet weak var exerciseDescription: UITextView!
    
    //  custom save/cancel buttons
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //  table for the sets/reps/weight data
    @IBOutlet weak var tableView: UITableView!
    
    //  picker for the rest timer
    @IBOutlet weak var restTimerPicker: UIPickerView!
    
    //  label for displaying the current rest time
    @IBOutlet weak var countdownLabel: UILabel!
    
    //  variables for controlling the rest timer
    var countdownTimer = Timer()
    var currentMin:Int = 1
    var currentSec:Int = 0
    var countingDown:Bool = false
    var paused:Bool = false
    
    //  custom button to pause/resume the rest timer
    @IBOutlet weak var pauseButton: UIButton!
    @IBAction func pauseButton(_ sender: Any) {
        if paused {
            paused = false
            pauseButton.setTitle("Pause", for: UIControlState.normal)
            updateCountdown()
        }else{
            paused = true
            pauseButton.setTitle("Resume", for: UIControlState.normal)
            countdownTimer.invalidate()
        }
    }
    
    //  custom button to start/stop the rest timer
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startStopButton(_ sender: Any) {
        if countingDown {
            countingDown = false
            startButton.setTitle("Start", for: UIControlState.normal)
            countdownTimer.invalidate()
            pauseButton.isEnabled = false
            paused = false
            pauseButton.setTitle("Pause", for: UIControlState.normal)
            countdownLabel.isHidden = true
            restTimerPicker.isHidden = false
            currentMin = restTimerPicker.selectedRow(inComponent: 0)
            currentSec = restTimerPicker.selectedRow(inComponent: 2)
            
        }else{
            countingDown = true
            startButton.setTitle("Cancel", for: UIControlState.normal)
            currentMin = restTimerPicker.selectedRow(inComponent: 0)
            currentSec = restTimerPicker.selectedRow(inComponent: 2)
            countdownLabel.text = String(format: "%02d", currentMin) + " : " + String(format: "%02d", currentSec)
            updateCountdown()
            pauseButton.isEnabled = true
            restTimerPicker.isHidden = true
            countdownLabel.isHidden = false
        }
    }
    
    //  custom function to add a set
    @IBAction func addSetButton(_ sender: Any) {
        UIView.setAnimationsEnabled(true)
        sets += 1
        setsArray.append((0, 0))
        
        tableView.reloadData()
    }
    
    //  custom function to delete a set when pressed
    @IBAction func deleteSetButton(_ sender: UIButton) {
        
        if let superview = sender.superview {
            if let cell = superview.superview as? SetTableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                    
                setsArray.remove(at: indexPath!.row)
                sets -= 1
                    
                tableView.reloadData()
            }
        }

    }
    
    //  button that takes the user to the previous exercise in the workout (if applicable)
    @IBAction func prevButton(_ sender: UIButton) {
        
        //  temporarily disable transition animations
        UIView.setAnimationsEnabled(false)
        
        //  index for target exercise
        transitionIndex = currIndex - 1
        
        //  update the current exercise with any changes that may have occurred
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        exercises[currIndex] = newExercise
        
        //  send the updated workout data + index of next exercise to the workout detail view controller
        delegate?.writeValueBack(value: exercises, next: transitionIndex)
        
    }
    
    //  button that takes the user to the next exercise in the workout (if applicable)
    @IBAction func nextButton(_ sender: UIButton) {
        
        //  temporarily disable transition animations
        UIView.setAnimationsEnabled(false)
        
        //  index for the target exercise
        transitionIndex = currIndex + 1
        
        //  update the current exercise with any changes that may have occurred
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        exercises[currIndex] = newExercise
        
        //  send the updated workout data + index of next exercise to the workout detail view controller
        delegate?.writeValueBack(value: exercises, next: transitionIndex)
        
    }
    
    //  outlets for the next/previous buttons
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the view's title to YouLift
        navigationItem.title = "YouLift"
        
        //  enable keyboard dismissal by tapping elsewhere on the screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
        //  implement a custom back button in the nav bar
        self.navigationItem.hidesBackButton = true
        let defaultBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExerciseDetailViewController.defaultBack(sender:)))
        self.navigationItem.leftBarButtonItem = defaultBackButton
        
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
        
        //  customize button appearances
        if addSetButton != nil {
            customizeButtonAppearance(button: addSetButton)
        }
        
        if startButton != nil {
            customizeButtonAppearance(button: startButton)
        }
        
        if pauseButton != nil {
            customizeButtonAppearance(button: pauseButton)
        }
        
        //  if the workout is in progress
        if inProgress {
                        
            //  implement a different custom back button in the nav bar
            let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExerciseDetailViewController.back(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            
            //  customize button appearances
            customizeButtonAppearance(button: prevButton)
            customizeButtonAppearance(button: nextButton)
            
            //  hide buttons based on where we are in the workout
            if currIndex == 0 {
                self.prevButton.isHidden = true
            }else if currIndex == exercises.count - 1 {
                self.nextButton.isHidden = true
            }
            
            restTimerPicker.dataSource = self
            restTimerPicker.delegate = self
            
            //  show/hide buttons based on the state of the rest timer
            if !countingDown {
                pauseButton.isEnabled = false
                countdownLabel.isHidden = true
                restTimerPicker.isHidden = false

            }else{
                restTimerPicker.isHidden = true
                countdownLabel.isHidden = false
            }
            
            //  start/resume the rest timer if applicable
            if countingDown && !paused{
                updateCountdown()
            }
            
        }
        
        //  assign values to the name/description labels
        exerciseName.text = self.exercise.name
        exerciseDescription.text = self.exercise.description
        
        //  update workout variable values
        self.sets = exercise.sets
        self.setsArray = exercise.setsArray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as? SetTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        //  configre the cell with set data
        let set = setsArray[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if inProgress {
            cell.reconfigureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }else{
            cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        
        return cell
        
    }
    
    //  get the data for each set in the table
    func getSetsData(_ tableView: UITableView) -> [(Int, Int)]{
        let cells = self.tableView.visibleCells as! Array<SetTableViewCell>
        var newSetsArray = [(Int, Int)]()
        
        //  get the data from each cell
        for cell in cells {
            newSetsArray.append(cell.getSetData())
        }
        
        return newSetsArray
    }
    
    //  custom back function -- just pops the view off
    func defaultBack(sender:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //  custom back function -- updates the overarching workout data and pops the view off
    func back(sender: UIBarButtonItem) {
        
        //  enable transition animations
        UIView.setAnimationsEnabled(true)
        
        //  update the current exercise with any changes that may have occurred
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        exercises[currIndex] = newExercise
        
        //  send the updated workout data to the workout detail view controller and indicate there is no next exercise to transition to
        delegate?.writeValueBack(value: exercises, next: -1)
        
        //  go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    //  rest timer picker functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //  middle component (':') should only have 1 row
        if component == 1{
            return 1
        } else {
            return 61
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 1 {
            return ":"
        } else {
            return String(format: "%02d", row)
        }
    }
    
    //  adjust width of each picker column
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if (component == 1) {
            return 15
        } else {
            return 40
        }
    }
    
    //  timer that calls for the rest timer display to update every second
    func updateCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayCountdown), userInfo: nil, repeats: true)
    }
    
    //  function to display the current rest time remaining (counts down to 00:00)
    func displayCountdown() {
        if currentSec == 0{
            if currentMin == 0{
                startButton.sendActions(for: .touchUpInside)
            }else{
                currentMin -= 1
                currentSec = 59
            }
        }else{
            currentSec -= 1
        }
        
        countdownLabel.text = String(format: "%02d", currentMin) + " : " + String(format: "%02d", currentSec)
    }
     
}



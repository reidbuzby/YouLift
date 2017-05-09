//
//  ExerciseDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: writeValueBackDelegate?
    var inProgress:Bool = false
    
    var exercise = Exercise()
    var exercises = [Exercise]()
    var currIndex = 0
    var transitionIndex = 0
    
    var sets = 0
    var setsArray = [(Int, Int)]()

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var restTimerPicker: UIPickerView!
    @IBOutlet weak var countdownLabel: UILabel!
    var countdownTimer = Timer()
    var currentMin:Int = 1
    var currentSec:Int = 0
    var countingDown:Bool = false
    var paused:Bool = false
    
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
            
            //reseteverything
            
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
    
    @IBAction func addSetButton(_ sender: Any) {
        UIView.setAnimationsEnabled(true)
        sets += 1
        setsArray.append((0, 0))
        
        tableView.reloadData()
    }
    
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
    
    @IBAction func prevButton(_ sender: UIButton) {
        UIView.setAnimationsEnabled(false)
        transitionIndex = currIndex - 1
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        
        exercises[currIndex] = newExercise
        
        UIView.setAnimationsEnabled(false)
        delegate?.writeValueBack(value: exercises, next: transitionIndex)
        //UIView.setAnimationsEnabled(true)
        
        // Go back to the previous ViewController
        //_ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        UIView.setAnimationsEnabled(false)
        transitionIndex = currIndex + 1
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        
        exercises[currIndex] = newExercise
        
        UIView.setAnimationsEnabled(false)
        delegate?.writeValueBack(value: exercises, next: transitionIndex)
        //UIView.setAnimationsEnabled(true)
        
        // Go back to the previous ViewController
        //_ = navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
        self.navigationItem.hidesBackButton = true
        let defaultBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExerciseDetailViewController.defaultBack(sender:)))
        self.navigationItem.leftBarButtonItem = defaultBackButton
        
        
        if inProgress {
                        
            //self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExerciseDetailViewController.back(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
            
            prevButton.layer.cornerRadius = 2
            prevButton.layer.borderWidth = 1
            prevButton.layer.borderColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1).cgColor
            nextButton.layer.cornerRadius = 2
            nextButton.layer.borderWidth = 1
            nextButton.layer.borderColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1).cgColor
            
            if currIndex == 0 {
                self.prevButton.isHidden = true
                //self.prevButton.isEnabled = false
            }else if currIndex == exercises.count - 1 {
                self.nextButton.isHidden = true
                //self.nextButton.isEnabled = false
            }
            
            restTimerPicker.dataSource = self
            restTimerPicker.delegate = self
            
            if !countingDown {
                pauseButton.isEnabled = false
                countdownLabel.isHidden = true
                restTimerPicker.isHidden = false

            }else{
                restTimerPicker.isHidden = true
                countdownLabel.isHidden = false
            }
            
            if countingDown && !paused{
                updateCountdown()
            }
            
        }
        
        
        // Do any additional setup after loading the view.
        
        exerciseName.text = self.exercise.name
        exerciseDescription.text = self.exercise.description
        
        self.sets = exercise.sets
        self.setsArray = exercise.setsArray
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // Configure the cell...
        let set = setsArray[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if inProgress {
            cell.reconfigureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }else{
            cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        
        return cell
        
    }
    
    func getSetsData(_ tableView: UITableView) -> [(Int, Int)]{
        let cells = self.tableView.visibleCells as! Array<SetTableViewCell>
        var newSetsArray = [(Int, Int)]()
        
        for cell in cells {
            newSetsArray.append(cell.getSetData())
        }
        
        return newSetsArray
    }
    
    func defaultBack(sender:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func back(sender: UIBarButtonItem) {
        UIView.setAnimationsEnabled(true)
        
        // Perform your custom actions
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: sets, setsArray: getSetsData(self.tableView))
        
        exercises[currIndex] = newExercise
        
        delegate?.writeValueBack(value: exercises, next: -1)
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
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
    
    //Adjust width of each picker column
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if (component == 1) {
            return 15
        } else {
            return 40
        }
    }
    
    func updateCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayCountdown), userInfo: nil, repeats: true)
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? ""){
            
            case "SaveExercise":
            
                guard let destination = segue.destination as? ExerciseTableViewController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                if (self.exerciseName.text == nil || self.exerciseDescription.text == nil) {
                    fatalError("Full data not entered for exercise")
                }
            
                destination.appendExercise(exercise: Exercise(name: self.exerciseName.text!, description: self.exerciseDescription.text!, sets: self.sets, setsArray: self.setsArray))
            
            
            default:
                fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
        
//        guard let button = sender as? UIBarButtonItem, button === saveButton else{
//            print("The save button was not pressed")
//            
//            return
//        }
//        
//        let name = exerciseName.text ?? ""
//        let description = exerciseDescription.text ?? ""
//        //let weight = weightInput.text ?? ""
//        //let reps = repsInput.text ?? ""
//        
//        exercise = Exercise(name: name, description: description, sets: sets, setsArray: setsArray)
    
        
}



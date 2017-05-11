//
//  CreateWorkoutDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 5/1/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//


import UIKit

class CreateWorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var existing:Bool = false
    var delegate: writeValueBackDelegate?
    var workout = [Exercise]()

    var type: DetailType = .new
    var callback: ((String, String, Int, [(Int, Int)])->Void)?
    
    @IBOutlet weak var exerciseNameField: UITextField!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var exerciseDescriptionField: UITextView!
    
    @IBOutlet weak var exerciseDescriptionLabel: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addSetButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var exercise = Exercise()
    
    var overallSetsArray = [(Int, Int)]()
    
    var sets: Int = 0
    
    var edit = false
    
    var changeIndex: Int = -1
    
    @IBAction func addSet(_ sender: Any) {
        
        sets += 1
        overallSetsArray.append((0,0))
        
        tableView.reloadData()
        
    }
    
    @IBAction func removeSet(_ sender: Any) {
        if (overallSetsArray.count > 1) {
            overallSetsArray.remove(at: (overallSetsArray.count - 1))
            
            sets -= 1
            tableView.reloadData()
            
        }
        else {
            //do nothing
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        exerciseDescriptionField.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if exerciseDescriptionField != nil {
            exerciseDescriptionField.delegate = self
        }
        navigationItem.title = "YouLift"
        
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = false;
        self.tableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        if addSetButton != nil {
            addSetButton.layer.cornerRadius = 4
            addSetButton.backgroundColor = UIColor(red: 0,  green: 0.478431, blue: 1, alpha: 1)
            addSetButton.layer.borderWidth = 1
        }
        
        cancelButton.layer.cornerRadius = 4
        cancelButton.backgroundColor = UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1)
        cancelButton.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 4
        saveButton.backgroundColor = UIColor(red: 0.117, green: 0.843, blue: 0.376, alpha: 1)
        saveButton.layer.borderWidth = 1
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false;

        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            overallSetsArray.append((0,0))
            sets = 1
            tableView.reloadData()
            break
        case let .deflt(name, description, sets, setsArray):
            if exerciseNameLabel != nil {
                edit = true
                exerciseNameLabel.text = name
                exerciseDescriptionLabel.text = description
                self.sets = sets
                self.overallSetsArray = setsArray
                tableView.reloadData()
            }
        case let .update(name, description, sets, setsArray, index):
            edit = true
            exerciseNameField.text = name
            exerciseDescriptionField.text = description
            self.overallSetsArray = setsArray
            self.sets = sets
            self.changeIndex = index
            tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetTableViewCell", for: indexPath) as? SetTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        // Configure the cell...
        
        let set = overallSetsArray[indexPath.row]
        
        if edit {
            cell.reconfigureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        else {
            cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        
        
        
        return cell
    }
    
    
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        if presentingViewController is UINavigationController{
//            dismiss(animated: true, completion: nil)
//        }else if let owningNavController = navigationController{
//            owningNavController.popViewController(animated: true)
//        }else{
//            fatalError("View is not contained by a navigation controller")
//        }
//    }
    
    func getSetsData(_ tableView: UITableView) -> [(Int, Int)]{
        let cells = self.tableView.visibleCells as! Array<SetTableViewCell>
        
        print(cells)
        var newSetsArray = [(Int, Int)]()
        
        for cell in cells {
            newSetsArray.append(cell.getSetData())
        }
        
        return newSetsArray
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    @IBAction func cancelDefault(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    @IBAction func saveDefaultExercise(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        let tableController = viewControllers[0] as! CreateWorkoutTableViewController
        
        let setsArray = getSetsData(tableView)
        
        exercise.name = exerciseNameLabel.text ?? ""
        exercise.description = exerciseDescriptionLabel.text ?? ""
        exercise.sets = setsArray.count
        exercise.setsArray = setsArray
        
        tableController.exercises.append(exercise)
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func saveCustomExercise(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        let setsArray = getSetsData(tableView)
        
        exercise = Exercise(name: exerciseNameField.text!, description: exerciseDescriptionField.text!, sets: setsArray.count, setsArray: setsArray)
        
        if !CoreDataManager.storeExercise(exercise: exercise) {
            AlertManager.nameValidationError(sender: self, name: exercise.name)
            return
        }
        
        if existing {
            
            workout.append(exercise)
            
            delegate?.writeValueBack(value: workout, next: -1)
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            
        } else {
        
            let tableController = viewControllers[0] as! CreateWorkoutTableViewController
        
            if edit {
                tableController.exercises[changeIndex] = exercise
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
            }
            else {
                tableController.exercises.append(exercise)
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
            
        case "SaveDefaultExercise":
        
            tableView.reloadData()
        
            let setsArray = getSetsData(tableView)
        
            exercise.name = exerciseNameLabel.text ?? ""
            exercise.description = exerciseDescriptionLabel.text ?? ""
            exercise.sets = setsArray.count
            exercise.setsArray = setsArray
            
            guard let destination = segue.destination as? CreateWorkoutTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.exercises.append(exercise)
            
        case "SaveCustomExercise":
            
            let setsArray = getSetsData(tableView)
            
            exercise.name = exerciseNameField.text ?? ""
            exercise.description = exerciseDescriptionField.text ?? ""
            exercise.sets = setsArray.count
            exercise.setsArray = setsArray
            
            guard let destination = segue.destination.childViewControllers[0] as? CreateWorkoutTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            destination.exercises.append(exercise)
            
            
        case "Exit":
            //do nothing
            break
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
    
    
}


enum DetailType{
    case new
    case update(String, String, Int, [(Int, Int)], Int)
    case deflt(String, String, Int, [(Int, Int)])
}

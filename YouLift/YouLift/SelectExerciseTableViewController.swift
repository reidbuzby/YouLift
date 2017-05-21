//
//  SelectExerciseTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  This file is the view controller for the view shown when Add Exercise is pressed on the main screen of Create
//
//  The screen lets the user choose between a table of premade exercises (either hardcoded or created by the user before)
//  or they can create a new custom exercise
//
//  The file sends data to CreateWorkoutDetailViewController on the exercise the user has selected

import UIKit

class SelectExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  variables for keeping track of workout data
    var exercises: [Exercise] = []
    var workout = [Exercise]()
    var existing:Bool = false

    //  delegate (for use in workout tab)
    var delegate: writeValueBackDelegate?

    //  button to add a custom exercise
    @IBOutlet weak var addCustomButton: UIButton!
    
    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the view's title to YouLift
        navigationItem.title = "YouLift"
        
        tableView.delegate = self
        tableView.dataSource = self
        

        //  fetch all existing exercises from core data and sort them alphabetically
        exercises = CoreDataManager.fetchExercises()
        exercises = exercises.sorted(by: {$0.name.uppercased() < $1.name.uppercased()})
        
        //exercises.append(Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]))
        

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
        
        //  customize the appearance of the button
        addCustomButton.layer.cornerRadius = 4
        addCustomButton.backgroundColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        addCustomButton.layer.borderWidth = 1
        
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false;
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  table that holds all the exercises
    @IBOutlet weak var tableView: UITableView!
    
    //table view functions
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
        
        //  configure the cell with the relevant exercise data
        let exercise = exercises[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        return cell
    }
    

    //  custom back button (for use in create tab)
    @IBAction func goBack(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //  if the workout is in progress, write the relevant exercise data back to the overarching workout
        if existing {
            let exercise = exercises[indexPath.row]
            let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: 1, setsArray: [(0,0)])
            
            workout.append(newExercise)
        
            delegate?.writeValueBack(value: workout, next: -1)
            _ = navigationController?.popViewController(animated: true)
        }
    }

    
    // MARK: - Navigation


    // code to be run prior to segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? ""){
            

        //  if user selects an existing exercise (create tab)
        case "SelectDefault":
            
            //  validate the sender/destination
            guard let destination = segue.destination as? CreateWorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            //  pass the relevant exercise data to the next view
            let exercise = exercises[indexPath.row]
            destination.type = .deflt(exercise.name, exercise.description, exercise.sets, exercise.setsArray)
        
        case "AddCustom"://when Add Custom Exercise is pressed
            
            //  if the workout is in progress
            if existing {
                guard let destination = segue.destination as? CreateWorkoutDetailViewController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //  pass the relevant workout data to the next view
                destination.existing = existing
                destination.delegate = delegate
                destination.workout = workout
            }
            
            break
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
}

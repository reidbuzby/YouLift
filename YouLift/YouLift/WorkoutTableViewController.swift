//
//  WorkoutTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  View controller for the main workouts tab. Holds two tables, one for default workouts and one for custom workouts.

import UIKit
import CoreData

class WorkoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  table views for default and custom workout templates
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customTableView: UITableView!
    
    //  current table color
    let tableColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
    
    //  arrays to keep track of the workout templates
    private var workouts = [(Workout, Bool)]()
    private var defaultWorkouts = [Workout]()
    private var customWorkouts = [Workout]()
    
    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the view's title to YouLift
        navigationItem.title = "YouLift"
        
        //  set the view's background color
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        //  customize the appearance of both tables
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = true;
        
        self.customTableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.customTableView!.layer.shadowColor = UIColor.black.cgColor
        self.customTableView!.layer.shadowRadius = 5
        self.customTableView!.layer.shadowOpacity = 0.3
        self.customTableView!.layer.masksToBounds = false;
        self.customTableView!.clipsToBounds = true;
        
        self.tableView!.backgroundColor = tableColor
        self.customTableView!.backgroundColor = tableColor

        
        tableView.delegate = self
        tableView.dataSource = self
        
        customTableView.delegate = self
        customTableView.dataSource = self
        
        tableView.alwaysBounceVertical = false;
        customTableView.alwaysBounceVertical = false;
    
        //  store the default workouts
        CoreDataManager.storeDefaultWorkouts()
        
        //  get the data for the tables from core data
        getTableData()
        
    }
    
    //  whenever the view appears
    override func viewWillAppear(_ animated: Bool) {
        //  get the table data from core data
        getTableData()
        
        //  reload the tables
        tableView.reloadData()
        customTableView.reloadData()
    }
    
    //  get the table data from core data
    func getTableData(){
        
        //  fetch all workout templates
        workouts = CoreDataManager.fetchWorkoutTemplates()
        customWorkouts = [Workout]()
        defaultWorkouts = [Workout]()
        
        //  divide the workout templates based on if they are custom vs default
        for workout in workouts {
            if workout.1 {
                customWorkouts.append(workout.0)
            }else{
                defaultWorkouts.append(workout.0)
            }
        }
        
        //  sort the workouts alphabetically
        customWorkouts = customWorkouts.sorted(by: {$0.name < $1.name})
        defaultWorkouts = defaultWorkouts.sorted(by: {$0.name < $1.name})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.customTableView {
            return customWorkouts.count
        }else{
            return defaultWorkouts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var workout = Workout()
        
        //  set the cell color to be the same as the table color
        UITableViewCell.appearance().backgroundColor = tableColor
        
        //  get the cell (error if wrong type)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        //  get the workout corresponding to the table/row
        if tableView == self.tableView {
            workout = defaultWorkouts[indexPath.row]
        } else {
            workout = customWorkouts[indexPath.row]
        }
        
        //  configure the cell
        cell.configureCell(workout: workout)
        return cell
    }
    
    //  code to be run prior to segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        
        //  if viewing a default workout
        case "ViewDefaultWorkout":
            
            //  validate the sender/destination
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            //  pass the relevant workout data to the next view
            destination.custom = false
            destination.workout = defaultWorkouts[indexPath.row]
          
        //  if viewing a custom workout
        case "ViewCustomWorkout":
            
            //  validate the sender/destination
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = customTableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            //  pass the relevant workout data to the next view
            destination.custom = true
            destination.workout = customWorkouts[indexPath.row]
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
    
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tableView.reloadData()
    }

}

//
//  StatsViewController.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  table view for the completed workouts
    @IBOutlet weak var workoutTableView: UITableView!
    //@IBOutlet weak var exerciseTableView: UITableView!
    
    //  array of all the completed workouts
    var completedWorkouts = [(Workout, Date, Double)]()
    
    
    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the background color
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        //  customize the appearance of the table
        self.workoutTableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.workoutTableView!.layer.shadowColor = UIColor.black.cgColor
        self.workoutTableView!.layer.shadowRadius = 5
        self.workoutTableView!.layer.shadowOpacity = 0.3
        self.workoutTableView!.layer.masksToBounds = false;
        self.workoutTableView!.clipsToBounds = true;
        self.workoutTableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //CoreDataManager.cleanCoreData(entity: "CompletedWorkoutEntity")
        
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        workoutTableView.alwaysBounceVertical = false;
        
        //exerciseTableView.delegate = self
        //exerciseTableView.dataSource = self
        
        //  get the table data from core data
        getTableData()
    }
    
    //  whenever the view appears (not just is loaded)
    override func viewWillAppear(_ animated: Bool) {
        
        //  set the view's title to be YouLift
        navigationItem.title = "YouLift"
        
        //  get the table data from core data
        getTableData()
        
        //  reload the data in the table
        workoutTableView.reloadData()
    }
    
    //  get the table data from core data
    func getTableData(){
        
        //  fetch and sort all completed workouts
        completedWorkouts = CoreDataManager.fetchCompletedWorkouts()
        completedWorkouts = completedWorkouts.sorted(by: {$0.1 > $1.1})
        
        //fetch exercise data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return completedWorkouts.count

        
//        if tableView == self.workoutTableView {
//            return completedWorkouts.count
//        }else{
//            //return defaultWorkouts.count
//            return 1
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if tableView == self.workoutTableView {
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
                        
        //  Configure the cell with the proper data
        let workout = completedWorkouts[indexPath.row].0
        let date = completedWorkouts[indexPath.row].1
        cell.configureDateCell(workout: workout, date: date)
            
        return cell
        //}
            
//        else{
//            
//            print("w/e")
//            return UITableViewCell()
//            
//        }
    }
    
    //  code to be run prior to segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        //  if seguing to a past workout
        case "ViewPastWorkout":
            
            //  check that we have a valid sender/destination
            guard let destination = segue.destination as? StatsDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = workoutTableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            //  pass the relevant workout/date/duration data to the next view
            destination.workout = completedWorkouts[indexPath.row].0
            destination.date = completedWorkouts[indexPath.row].1
            destination.duration = completedWorkouts[indexPath.row].2
            
            //  set the current view's title to "Back" (temporary work around)
            navigationItem.title = "Back"
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
}

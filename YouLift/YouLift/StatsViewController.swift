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
    
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var exerciseTableView: UITableView!
    
    var completedWorkouts = [(Workout, Date, Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        getTableData()
        
        //CoreDataManager.cleanCoreData(entity: "CompletedWorkoutEntity")
    }
    
    func getTableData(){
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
        
        if tableView == self.workoutTableView {
            return completedWorkouts.count
        }else{
            //return defaultWorkouts.count
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.workoutTableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            // Configure the cell...
            let workout = completedWorkouts[indexPath.row].0
            let date = completedWorkouts[indexPath.row].1
            cell.configureDateCell(workout: workout, date: date)
            
            return cell
        }
            
        else{
            
            print("w/e")
            return UITableViewCell()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        case "ViewPastWorkout":
            
            guard let destination = segue.destination as? StatsDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = workoutTableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            destination.workout = completedWorkouts[indexPath.row].0
            destination.date = completedWorkouts[indexPath.row].1
            destination.duration = completedWorkouts[indexPath.row].2
            
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
}

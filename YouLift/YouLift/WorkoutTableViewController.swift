//
//  WorkoutTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit
import CoreData

class WorkoutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customTableView: UITableView!
    
    //var fetchedResultsController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        customTableView.delegate = self
        customTableView.dataSource = self
        
        //CoreDataManager.cleanCoreData(entity: "WorkoutTemplateEntity")
        //CoreDataManager.cleanCoreData(entity: "CompletedWorkoutEntity")
        
        var workoutOne = Workout(name: "Leg Day", exercises: [Exercise(name:"Squat", description:"This is how to do a squat", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
                                                              Exercise(name: "Leg Press", description: "This is how to do a leg press", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Deadlift", description: "This is how to do a deadlift", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Leg Curl", description: "This is how to do a leg curl", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Calf Raises", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])])
        
        var workoutTwo = Workout(name: "A Leg Day", exercises: [Exercise(name:"Squat", description:"This is how to do a squat", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
                                                              Exercise(name: "Leg Press", description: "This is how to do a leg press", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Deadlift", description: "This is how to do a deadlift", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Leg Curl", description: "This is how to do a leg curl", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
                                                              Exercise(name: "Calf Raises", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])])
        
        CoreDataManager.storeWorkoutTemplate(workout: workoutOne)
        CoreDataManager.storeWorkoutTemplate(workout: workoutTwo)
        
        getTableData()
        
        print(CoreDataManager.fetchCompletedWorkouts())
    }
    
    func getTableData(){
        workouts = CoreDataManager.fetchWorkoutTemplates()
        
        for workout in workouts {
            if workout.1 {
                customWorkouts.append(workout.0)
            }else{
                defaultWorkouts.append(workout.0)
            }
            
            customWorkouts = customWorkouts.sorted(by: {$0.name < $1.name})
            defaultWorkouts = defaultWorkouts.sorted(by: {$0.name < $1.name})
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private var workouts = [(Workout, Bool)]()
    private var defaultWorkouts = [Workout]()
    private var customWorkouts = [Workout]()

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
        if tableView == self.tableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            // Configure the cell...
            let workout = defaultWorkouts[indexPath.row]
            cell.configureCell(workout: workout)
            
            return cell
        }
            
        else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else{
                fatalError("Can't get cell of the right kind")
            }
            
            // Configure the cell...
            let workout = customWorkouts[indexPath.row]
            cell.configureCell(workout: workout)
            
            return cell

        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        
        case "ViewDefaultWorkout":
            
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let workout = defaultWorkouts[indexPath.row]
            
            destination.workout = workout
            
        case "ViewCustomWorkout":
            
            guard let destination = segue.destination as? WorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? WorkoutTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = customTableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let workout = customWorkouts[indexPath.row]
            
            destination.workout = workout
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
    
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tableView.reloadData()
    }

}

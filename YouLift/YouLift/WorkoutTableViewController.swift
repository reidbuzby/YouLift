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
    
    let tableColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
    
    //var fetchedResultsController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.navigationItem.title = "YouLift"
        
        navigationItem.title = "YouLift"
        
         self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
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
        
        self.tableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        self.customTableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        customTableView.delegate = self
        customTableView.dataSource = self
        
        tableView.alwaysBounceVertical = false;
        customTableView.alwaysBounceVertical = false;
                
        CoreDataManager.cleanCoreData(entity: "WorkoutTemplateEntity")
        CoreDataManager.cleanCoreData(entity: "CompletedWorkoutEntity")
        
        var workoutOne = Workout(name: "Leg Day", exercises: [
            Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slowly stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
            Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name: "Deadlift", description: "Grab the weight on the floor with an overhand grip and pull it up to your thighs while keeping your lower back straight, lower weight back to floor and repeat.", sets: 3, setsArray: [(75, 5), (100, 5), (125, 5)]),
            Exercise(name: "Leg Curl", description: "Sit on the machine with the back of your lower legs on the padded lever, pull the lever back to your thighs slowly return to the start position and repeat.", sets: 3, setsArray: [(120, 3), (120, 3), (120, 3)]),
            Exercise(name: "Calf Raises", description: "Stand on the edge of a step with the balls of your feet on it, and raise your heels a few inches, hold it for a second, lower, and repeat.", sets: 3, setsArray: [(100, 4), (100, 4), (100, 4)])])
        
        var workoutTwo = Workout(name: "Try Hard", exercises: [
            Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(200, 3), (200, 3), (200, 3)]),
            Exercise(name: "Deadlift", description: "Grab the weight on the floor with an overhand grip and pull it up to your thighs while keeping your lower back straight, lower weight back to floor and repeat.", sets: 3, setsArray: [(100, 5), (100, 5), (100, 5)]),
            Exercise(name: "Floor Press", description: "Lie on the floor on your back and hold two dumbells on your chest, explosively press teh dumbells up and then slowly lower them.", sets: 3, setsArray: [(80, 4), (80, 4), (100, 4)]),
            Exercise(name: "Leg Curl", description: "Sit on the machine with the back of your lower legs on the padded lever, pull the lever back to your thighs slowly return to the start position and repeat.", sets: 3, setsArray: [(75, 5), (75, 5), (75, 5)]),
            Exercise(name: "Bicep Curl", description: "Hold a dumbbell in each hand at arm's length, keep your elbows close to your torso and rotate the palms of your hands until they are facing forward. This will be your starting position. Keeping the upper arms stationary curl the weights while contracting your biceps.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name: "Ab Crunch", description: "Sit in the ab crunch machine and place your feet under the pads and grab the top handles. Lift your legs and crunch your torso in, hold it for a second and slowly return to the starting position.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])])
        
        var workoutThree = Workout(name: "Sunday Morning", exercises: [
            Exercise(name: "Bicep Curl", description: "Hold a dumbbell in each hand at arm's length, keep your elbows close to your torso and rotate the palms of your hands until they are facing forward. This will be your starting position. Keeping the upper arms stationary curl the weights while contracting your biceps.", sets: 3, setsArray: [(75, 3), (75, 3), (75, 3)]),
            Exercise(name: "Shoulder Press", description: "Sitting down, hold the dumbbells at ear level, push the dumbells so they touch above your head and slowly lower them back down.", sets: 3, setsArray: [(50, 2), (50, 2), (50, 2)]),
            Exercise(name: "Floor Press", description: "Lie on the floor on your back and hold two dumbells on your chest, explosively press teh dumbells up and then slowly lower them.", sets: 3, setsArray: [(50, 3), (50, 3), (50, 3)]),
            Exercise(name: "Ab Crunch", description: "Sit in the ab crunch machine and place your feet under the pads and grab the top handles. Lift your legs and crunch your torso in, hold it for a second and slowly return to the starting position.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]),
            Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slowly stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)]),
            Exercise(name: "Calf Raises", description: "Stand on the edge of a step with the balls of your feet on it, and raise your heels a few inches, hold it for a second, lower, and repeat.", sets: 3, setsArray: [(40, 3), (40, 3), (40, 3)])])
        
        CoreDataManager.storeWorkoutTemplate(workout: workoutOne)
        CoreDataManager.storeWorkoutTemplate(workout: workoutTwo)
        CoreDataManager.storeWorkoutTemplate(workout: workoutThree)
        
        getTableData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTableData()
        tableView.reloadData()
        customTableView.reloadData()
    }
    
    func getTableData(){
        workouts = CoreDataManager.fetchWorkoutTemplates()
        customWorkouts = [Workout]()
        defaultWorkouts = [Workout]()
        
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
        
        UITableViewCell.appearance().backgroundColor = tableColor
        
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

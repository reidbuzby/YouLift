//
//  ExerciseTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/27/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit
import CoreData

class ExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exercises = [(Exercise)]()
    var delegate: writeValueBackDelegate?
    var inProgress:Bool = false
    var currWorkout = [Exercise]()

    
//    func appendExercise(exercise: Exercise) {
//        exercises.add(exercise: exercise)
//    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "YouLift"
        
         self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = false;
        
        var exercise1 = Exercise(name:"Squat", description:"Stand up straight with feet shoulders width apart holding desired weight, and slowly bend knees down to a 90 degree angle while keeping your back straight, and then slowly stand up back to the starting position.", sets:3, setsArray:[(100, 2), (100, 2), (100, 2)])
        
        var exercise2 = Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        var exercise3 = Exercise(name: "Deadlift", description: "Grab the weight on the floor with an overhand grip and pull it up to your thighs while keeping your lower back straight, lower weight back to floor and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        var exercise4 = Exercise(name: "Leg Curl", description: "Sit on the machine with the back of your lower legs on the padded lever, pull the lever back to your thighs slowly return to the start position and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        var exercise5 = Exercise(name: "Calf Raises", description: "Stand on the edge of a step with the balls of your feet on it, and raise your heels a few inches, hold it for a second, lower, and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        
        var exercise6 = Exercise(name: "Bicep Curl", description: "csxdgfgcxg", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        var exercise7 = Exercise(name: "Shoulder Press", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        var exercise8 = Exercise(name: "Ab Crunch", description: "This is how to do a calf raise", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)])
        
        CoreDataManager.storeExercise(exercise: exercise1)
        CoreDataManager.storeExercise(exercise: exercise2)
        CoreDataManager.storeExercise(exercise: exercise3)
        CoreDataManager.storeExercise(exercise: exercise4)
        CoreDataManager.storeExercise(exercise: exercise5)
        CoreDataManager.storeExercise(exercise: exercise6)
        CoreDataManager.storeExercise(exercise: exercise7)
        CoreDataManager.storeExercise(exercise: exercise8)
        
        //getTableData()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if inProgress {
            self.navigationItem.hidesBackButton = true
            let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ExerciseTableViewController.back(sender:)))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
        
        tableView.delegate = self
        tableView.dataSource = self
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
        return exercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as? ExerciseTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        // Configure the cell...
        exercises = CoreDataManager.fetchExercises()
        
        for exercise in exercises {
            exercises = exercises.sorted(by: {$0.name < $1.name})
        let exercise = exercises[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = exercises[indexPath.row]
        let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: 1, setsArray: [(0,0)])
        currWorkout.append(newExercise)
        
        delegate?.writeValueBack(value: currWorkout, next: -1)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        case "ViewExercise":
            
            guard let destination = segue.destination as? ExerciseDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises[indexPath.row]
            
            destination.exercise = exercise
            
        case "AddExercise":
            
            guard let destination = segue.destination as? ExerciseDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises[indexPath.row]
            
            destination.exercise = exercise
                        
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }


}

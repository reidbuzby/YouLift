//
//  ExerciseTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/27/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let exercises = ExerciseCollection()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        return exercises.collection.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as? ExerciseTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        // Configure the cell...
        let exercise = exercises.collection[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        return cell
        
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
            
            guard let destination = segue.destination as? ExerciseDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises.collection[indexPath.row]
            
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
            
            let exercise = exercises.collection[indexPath.row]
            
            destination.exercise = exercise
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }


}
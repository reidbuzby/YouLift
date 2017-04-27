//
//  ExerciseDetailViewController.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var exercise = Exercise()
    
    var sets = 0
    var setsArray = [(Int, Int)]()

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //@IBOutlet weak var weightInput: UITextField!
    //@IBOutlet weak var repsInput: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        
        return cell
        
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
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            
            return
        }
        
        let name = exerciseName.text ?? ""
        let description = exerciseDescription.text ?? ""
        //let weight = weightInput.text ?? ""
        //let reps = repsInput.text ?? ""
        
        exercise = Exercise(name: name, description: description, sets: sets, setsArray: setsArray)
        
    }

}

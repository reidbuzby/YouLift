//
//  BookDetailViewController.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/6/17.
//  Copyright © 2017 Christopher Andrews. All rights reserved.
//

import UIKit

class CreateWorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var type: DetailType = .new
    var callback: ((String, String, Int, [(Int, Int)])->Void)?
    
    @IBOutlet weak var exerciseNameField: UITextField!
    
    @IBOutlet weak var exerciseDescriptionField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var exercise = Exercise()
    
    var overallSetsArray = [(Int, Int)]()
    
    var sets: Int = 0
    
    var edit = false
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            overallSetsArray.append((0,0))
            sets = 1
            tableView.reloadData()
            break
        case let .update(name, description, sets, setsArray):
            edit = true
            exerciseNameField.text = name
            exerciseDescriptionField.text = description
            self.overallSetsArray = setsArray
            self.sets = sets
            tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
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
        print("set:", set, "\n")
        
        if !edit {
            cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        else {
            cell.reconfigureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        }
        
        
        
        return cell
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }
    
    func getSetsData(_ tableView: UITableView) -> [(Int, Int)]{
        let cells = self.tableView.visibleCells as! Array<SetTableViewCell>
        
        print(cells)
        var newSetsArray = [(Int, Int)]()
        
        for cell in cells {
            newSetsArray.append(cell.getSetData())
        }
        
        return newSetsArray
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        tableView.reloadData()
        
        let setsArray = getSetsData(tableView)
        
        exercise.name = exerciseNameField.text ?? ""
        exercise.description = exerciseDescriptionField.text ?? ""
        exercise.sets = setsArray.count
        exercise.setsArray = setsArray
    }
    
    
}


enum DetailType{
    case new
    case update(String, String, Int, [(Int, Int)])
}

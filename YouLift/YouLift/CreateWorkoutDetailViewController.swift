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
    
    @IBAction func addSet(_ sender: Any) {
        
        overallSetsArray.append((0,0))
        
        tableView.reloadData()
        
    }
    
    @IBAction func removeSet(_ sender: Any) {
        if (overallSetsArray.count > 1) {
            overallSetsArray.remove(at: (overallSetsArray.count - 1))
        
            tableView.reloadData()
        }
        else {
            //do nothing
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hue: 0.4, saturation: 0.05, brightness: 0.9, alpha: 1.0)
        
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = false;
        
        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .update(exerciseName, exerciseDescription, sets, setsArray):
            navigationItem.title = exerciseName
            exerciseNameField.text = exerciseName
            exerciseDescriptionField.text = exerciseDescription
        }
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        overallSetsArray.append(contentsOf: [(100, 3)])
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallSetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetTableViewCell", for: indexPath) as? SetTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        // Configure the cell...
        
        let set = overallSetsArray[indexPath.row]
        
        cell.configureCell(setNumber: indexPath.row + 1, weight: set.0, numberOfReps: set.1)
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        
        exercise.name = exerciseNameField.text ?? ""
        exercise.description = exerciseDescriptionField.text ?? ""
        exercise.sets = overallSetsArray.count
        exercise.setsArray = overallSetsArray
        
//        let exerciseName = exerciseNameField.text ?? ""
//        let exerciseDescription = exerciseDescriptionField.text ?? ""
//        let sets = overallSetsArray.count
//        
//        if callback != nil{
//            callback!(exerciseName, exerciseDescription, sets, overallSetsArray)
//        }
    }
    
    
}


enum DetailType{
    case new
    case update(String, String, Int, [(Int, Int)])
}

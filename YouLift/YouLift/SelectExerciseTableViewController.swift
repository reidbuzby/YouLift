//
//  SelectExerciseTableViewController.swift
//  YouLift
//
//  Created by rbuzby on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class SelectExerciseTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var exercises: [Exercise] = []
    var workout = [Exercise]()
    var delegate: writeValueBackDelegate?
    var existing:Bool = false

    @IBOutlet weak var addCustomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "YouLift"

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Uncomment following line when fetchExercises() is working
        exercises = CoreDataManager.fetchExercises()
        exercises = exercises.sorted(by: {$0.name.uppercased() < $1.name.uppercased()})
        
        exercises.append(Exercise(name: "Leg Press", description: "Place your legs on the platform and push them forward until they fully extend, then slow bring your legs back to a 90 degree angle and repeat.", sets: 3, setsArray: [(100, 3), (100, 3), (100, 3)]))
        
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        self.tableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tableView!.layer.shadowColor = UIColor.black.cgColor
        self.tableView!.layer.shadowRadius = 5
        self.tableView!.layer.shadowOpacity = 0.3
        self.tableView!.layer.masksToBounds = false;
        self.tableView!.clipsToBounds = false;
        self.tableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        
        addCustomButton.layer.cornerRadius = 4
        addCustomButton.backgroundColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        addCustomButton.layer.borderWidth = 1
        
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false;
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
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
        let exercise = exercises[indexPath.row]
        cell.configureCell(exercise: exercise)
        
        return cell
    }
    
    @IBAction func goBack(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if existing {
            let exercise = exercises[indexPath.row]
            let newExercise = Exercise(name: exercise.name, description: exercise.description, sets: 1, setsArray: [(0,0)])
            
            workout.append(newExercise)
        
            delegate?.writeValueBack(value: workout, next: -1)
            _ = navigationController?.popViewController(animated: true)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        case "SelectDefault":
            guard let destination = segue.destination as? CreateWorkoutDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExerciseTableViewCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            let exercise = exercises[indexPath.row]
            
            destination.type = .deflt(exercise.name, exercise.description, exercise.sets, exercise.setsArray)
        
        case "AddCustom":
            //do nothing
            
            if existing {
                guard let destination = segue.destination as? CreateWorkoutDetailViewController else{
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                destination.existing = existing
                destination.delegate = delegate
                destination.workout = workout
            }
            
            break
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
    }
}

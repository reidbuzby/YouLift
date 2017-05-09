//
//  StatsDetailViewController.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation
import UIKit

class StatsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var workout = Workout()
    var date = Date()
    var duration = Double()
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var statsTableView: UITableView!
    
    //each cell in the table will basically be one big formatted text box with all the data (Exercise name, sets, reps, weight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        statsTableView.delegate = self
        statsTableView.dataSource = self
        
        //statsTableView.estimatedRowHeight = 44.0*4
        //statsTableView.rowHeight = 44.0*4//UITableViewAutomaticDimension

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        
        workoutNameLabel.text = workout.name
        durationLabel.text = String(duration)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workout.exerciseArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatsTableViewCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        //cell.sizeToFit()
        //cell.textLabel?.numberOfLines = 0
        
        cell.configureCell(exercise: workout.exerciseArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(22.0 * Double(workout.exerciseArray[indexPath.row].sets) + 22)
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        tableView.estimatedRowHeight = 44.0 * 3 // standard tableViewCell height
//        tableView.rowHeight = UITableViewAutomaticDimension
//        
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
}

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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let cell = statsTableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell", for: indexPath) as? StatsTableViewCell else{
//            fatalError("Can't get cell of the right kind")
//        }
//        
//    
//        return cell
//    }
    
}

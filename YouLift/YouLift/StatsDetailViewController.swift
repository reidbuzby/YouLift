//
//  StatsDetailViewController.swift
//  YouLift
//
//  Created by Andrew Garland on 5/8/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  View controller for viewing past workout data. Displays the relevant information (workout name, date, duration) and has a table listing the specifics of the workout (exercises, weights, reps)

import Foundation
import UIKit

class StatsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  variables keeping track of the workout data
    var workout = Workout()
    var date = Date()
    var duration = Double()
    
    //  labels to display the workout data
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    //  table holding the workout data
    @IBOutlet weak var statsTableView: UITableView!

    //  when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  set the background color
        self.view.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.51, alpha: 1.0)
        
        //  customize the appearance of the table
        self.statsTableView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.statsTableView!.layer.shadowColor = UIColor.black.cgColor
        self.statsTableView!.layer.shadowRadius = 5
        self.statsTableView!.layer.shadowOpacity = 0.3
        self.statsTableView!.layer.masksToBounds = false;
        self.statsTableView!.clipsToBounds = true;
        self.statsTableView!.backgroundColor = UIColor(red: 0.73, green: 0.89, blue: 0.94, alpha: 1)
        
        //  set the title of the view to YouLift
        navigationItem.title = "YouLift"
        
        statsTableView.delegate = self
        statsTableView.dataSource = self
        statsTableView.alwaysBounceVertical = false;

        //  convert the date to a dd/MM/yyyy string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: date)

        //  connect labels to their relevant data
        workoutNameLabel.text = workout.name
        durationLabel.text = "Duration: " + timeFromDouble(time: duration)
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
        
        //  configure the cell with the exercise data
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.configureCell(exercise: workout.exerciseArray[indexPath.row])
        
        return cell
    }
    
    //  set the height of each cell based on the number of sets for that exercise
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(22.0 * Double(workout.exerciseArray[indexPath.row].sets) + 22)
        
    }
    
    //  convert time from seconds to a displayable string (hh:mm:ss)
    func timeFromDouble(time: Double) -> String {
        
        let ti = NSInteger(time)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
}

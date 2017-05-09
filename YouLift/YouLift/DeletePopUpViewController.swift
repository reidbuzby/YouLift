//
//  DeletePopUpViewController.swift
//  YouLift
//
//  Created by Andrew Garland on 5/9/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit
import Foundation

class DeletePopUpViewController: UIViewController {
    
    var workout:Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishLabel.numberOfLines = 0
        finishLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        finishLabel.text = "Are you sure you would like to delete the workout? This cannot be undone.";
        
    }
    
    @IBOutlet weak var finishLabel: UILabel!
    
    
    @IBAction func resumeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func deleteWorkout(){
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        //delete the workout
        
    }
    
}

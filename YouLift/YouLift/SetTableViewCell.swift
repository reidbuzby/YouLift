//
//  SetTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//
//  A cell representing an individual set for an exercise. Consists of set #, weight (lbs), and # of reps. weight/reps is either fixed or editable depending on context

import UIKit

class SetTableViewCell: UITableViewCell {

    //  labels
    @IBOutlet weak var setNumber: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var numberOfReps: UILabel!
    
    //  text input fields
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //  set the cell labels based on the parameters
    func configureCell(setNumber: Int, weight: Int, numberOfReps: Int) {
        if self.setNumber != nil {
            self.setNumber.text = String(setNumber)
        }
        if self.weight != nil {
            self.weight.text = String(weight)
        }
        if self.numberOfReps != nil {
            self.numberOfReps.text = String(numberOfReps)
        }
    }
    
    //  set the cell labels/input field text based on the parameters
    func reconfigureCell(setNumber: Int, weight: Int, numberOfReps: Int) {
        if self.setNumber != nil {
            self.setNumber.text = String(setNumber)
        }
        if self.weightInput != nil {
            self.weightInput.text = String(weight)
        }
        if self.repsInput != nil {
            self.repsInput.text = String(numberOfReps)
        }
    }
    
    //  get the weight/reps data in the cell (defaults to (0, 0))
    func getSetData() -> (Int, Int){
        var weightData = 0
        var repsData = 0
        
        if weightInput.text != "" {
            weightData = Int(weightInput.text!)!
        }
        
        if repsInput.text != "" {
            repsData = Int(repsInput.text!)!
        }
        
        return (weightData, repsData)
    }

}

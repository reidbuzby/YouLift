//
//  SetTableViewCell.swift
//  YouLift
//
//  Created by rbuzby on 4/26/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {

    @IBOutlet weak var setNumber: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var numberOfReps: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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

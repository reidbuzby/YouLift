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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(setNumber: Int, weight: Int, numberOfReps: Int) {
        self.setNumber.text = String(setNumber)
        self.weight.text = String(weight)
        self.numberOfReps.text = String(numberOfReps)
    }

}

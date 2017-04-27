//
//  PopUpViewController.swift
//  YouLift
//
//  Created by Andrew Garland on 4/27/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class FinishPrompt: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.finishLabel.text = "Would you like to end the workout?";
    }
    
    @IBOutlet weak var finishLabel: UILabel!
    
    
    @IBAction func resumeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishButton(_ sender: Any) {
    }
    
}

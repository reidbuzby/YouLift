//
//  CustomNavigationBar.swift
//  YouLift
//
//  Created by Andrew Garland on 5/10/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    //trying to disable sliding animation of nav bar title when navigating between views. Currently does not work.
    
    override func popItem(animated: Bool) -> UINavigationItem? {
        return super.popItem(animated: false)
    }
    
    override func pushItem(_ item: UINavigationItem, animated: Bool){
        return super.pushItem(item, animated: false)
    }
    

}

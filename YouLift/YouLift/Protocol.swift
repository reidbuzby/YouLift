//
//  Protocol.swift
//  YouLift
//
//  Created by Andrew Garland on 5/2/17.
//  Copyright © 2017 rbuzby. All rights reserved.
//

import Foundation

//  protocol for writing back workout data
protocol writeValueBackDelegate {
    func writeValueBack(value: [Exercise], next: Int)
}

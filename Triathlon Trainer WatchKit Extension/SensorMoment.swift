//
//  SensorMoment.swift
//  Triathlon Trainer WatchKit Extension
//
//  Created by Justin Schaffner on 10/24/17.
//

import Foundation
import CoreMotion

class SensorSample{
    var Ax : Double
    var Ay : Double
    var Az : Double
    var Gx : Double
    var Gy : Double
    var Gz : Double
    var timestamp : Date
    
    init(){
        Ax = 0.0; Ay = 0.0; Az = 0.0; Gx = 0.0; Gy = 0.0; Gz = 0.0
        timestamp = Date.init()
    }
    init(acX: Double, acY: Double, acZ: Double, gyX: Double, gyY: Double, gyZ: Double, ts: Date ){
        Ax = acX; Ay = acY; Az = acZ; Gx = gyX; Gy = gyY; Gz = gyZ
        timestamp = ts
    }
}

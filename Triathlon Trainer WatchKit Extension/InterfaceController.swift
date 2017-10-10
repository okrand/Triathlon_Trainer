//
//  InterfaceController.swift
//  Triathlon Trainer WatchKit Extension
//
//  Created by Justin Schaffner on 10/1/17.
//
//

import WatchKit
import CoreMotion
import Foundation


class InterfaceController: WKInterfaceController {
    let motion = CMMotionManager()
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

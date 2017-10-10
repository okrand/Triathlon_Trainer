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
            
            // Configure a timer to fetch the data.
            let timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    let x = data.acceleration.x
                                    let y = data.acceleration.y
                                    let z = data.acceleration.z
                                    
                                    // Use the accelerometer data in your app.
                                    var XAxis: WKInterfaceLabel!
                                    XAxis.setText(String(x))
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
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

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
    @IBOutlet weak var XAxis: WKInterfaceLabel!
    @IBOutlet weak var YAxis: WKInterfaceLabel!
    @IBOutlet weak var ZAxis: WKInterfaceLabel!
    let motion = CMMotionManager()
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            let timer = Timer(fire: Date(), interval: (1.0/2.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    let x = String(format: "%.4f", data.acceleration.x)
                                    let y = String(format: "%.4f", data.acceleration.y)
                                    let z = String(format: "%.4f", data.acceleration.z)
                                    
                                    // Use the accelerometer data in your app.
                                    self.XAxis.setText("X: "+x)
                                    self.YAxis.setText("Y: "+y)
                                    self.ZAxis.setText("Z: "+z)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        startAccelerometers()
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

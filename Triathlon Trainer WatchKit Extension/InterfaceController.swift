//
//  InterfaceController.swift
//  Triathlon Trainer WatchKit Extension
//
//  Created by Justin Whitlock and Orkun Krand on 10/1/17.
//
//

import WatchKit
import CoreMotion
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var XAxis: WKInterfaceLabel!
    @IBOutlet weak var YAxis: WKInterfaceLabel!
    @IBOutlet weak var ZAxis: WKInterfaceLabel!
    @IBOutlet weak var XRotAxis: WKInterfaceLabel!
    @IBOutlet weak var YRotAxis: WKInterfaceLabel!
    @IBOutlet weak var ZRotAxis: WKInterfaceLabel!
    @IBOutlet weak var XMagAxis: WKInterfaceLabel!
    @IBOutlet weak var YMagAxis: WKInterfaceLabel!
    @IBOutlet weak var ZMagAxis: WKInterfaceLabel!
    let motion = CMMotionManager()
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
        }
        if self.motion.isGyroAvailable{
            self.motion.gyroUpdateInterval = 1.0 / 60.0 //60 Hz
            self.motion.startGyroUpdates()
        }
        if self.motion.isMagnetometerAvailable{
            self.motion.magnetometerUpdateInterval = 1.0 / 60.0 //60 Hz
            self.motion.startMagnetometerUpdates()
        }
            // Configure a timer to fetch the data.
            let timer = Timer(fire: Date(), interval: (1.0/2.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let adata = self.motion.accelerometerData {
                                    let x = String(format: "%.4f", adata.acceleration.x)
                                    let y = String(format: "%.4f", adata.acceleration.y)
                                    let z = String(format: "%.4f", adata.acceleration.z)
                                    
                                    // Use the accelerometer data in your app.
                                    self.XAxis.setText("X: "+x)
                                    self.YAxis.setText("Y: "+y)
                                    self.ZAxis.setText("Z: "+z)
                                }
                                if let rdata = self.motion.gyroData {
                                    let x = String(format: "%.4f", rdata.rotationRate.x)
                                    let y = String(format: "%.4f", rdata.rotationRate.y)
                                    let z = String(format: "%.4f", rdata.rotationRate.z)
                                    
                                    self.XRotAxis.setText("X: "+x)
                                    self.YRotAxis.setText("Y: "+y)
                                    self.ZRotAxis.setText("Z: "+z)
                                }
                                if let mdata = self.motion.magnetometerData {
                                    let x = String(format: "%.4f", mdata.magneticField.x)
                                    let y = String(format: "%.4f", mdata.magneticField.y)
                                    let z = String(format: "%.4f", mdata.magneticField.z)
                                    
                                    self.XMagAxis.setText("X: "+x)
                                    self.YMagAxis.setText("Y: "+y)
                                    self.ZMagAxis.setText("Z: "+z)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        
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

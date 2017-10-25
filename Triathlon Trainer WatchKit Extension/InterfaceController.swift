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


extension CMSensorDataList: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}

class InterfaceController: WKInterfaceController {
    let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
    
    @IBOutlet weak var theButton: WKInterfaceButton!
    @IBOutlet weak var Tim: WKInterfaceTimer!
    @IBOutlet weak var XAxis: WKInterfaceLabel!
    @IBOutlet weak var YAxis: WKInterfaceLabel!
    @IBOutlet weak var ZAxis: WKInterfaceLabel!
    @IBOutlet weak var XRotAxis: WKInterfaceLabel!
    @IBOutlet weak var YRotAxis: WKInterfaceLabel!
    @IBOutlet weak var ZRotAxis: WKInterfaceLabel!
    @IBOutlet weak var XMagAxis: WKInterfaceLabel!
    @IBOutlet weak var YMagAxis: WKInterfaceLabel!
    @IBOutlet weak var ZMagAxis: WKInterfaceLabel!
    @IBOutlet weak var XMotAxis: WKInterfaceLabel!
    @IBOutlet weak var YMotAxis: WKInterfaceLabel!
    @IBOutlet weak var ZMotAxis: WKInterfaceLabel!
    @IBOutlet weak var HMot: WKInterfaceLabel!
    
    let motion = CMMotionManager()
    var timer: Timer!
    var recordTimer: Timer!
    var startTime: Date!
    var endTime: Date!
    var latestDate = Date.distantPast
    var recording = false
    var recordCounter = 60
    @IBAction func pressButton(newbool: Bool = false){
        recording = newbool
        if recording == false {
            startTime = Date()
            recording = true
            let recorder = CMSensorRecorder()
            recorder.recordAccelerometer(forDuration: 60)  // Record for 1 minutes
            updateButtonText(newText: "Recording")
            recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
            let timerEnd = Date(timeIntervalSinceNow: 60)
            Tim.setDate(timerEnd)
            Tim.start()
        }
        else {
            endTime = Date()
            recording = false
            updateButtonText(newText: "Start Recording")
        }
    }
    func updateCounter(){
        if recordCounter > 0{
            recordCounter -= 1
            updateButtonText(newText: String(recordCounter))
        }
        else{
            pressButton(newbool: false)
        }
    }
    
    func startAccelerometers() {
        if CMSensorRecorder.isAccelerometerRecordingAvailable() {
            updateButtonText(newText: "Start Recording")
        }
        else{
            updateButtonText(newText: "Not Ready!!")
        }
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
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0 // 60 Hz
            self.motion.startDeviceMotionUpdates()
        }
            // Configure a timer to fetch the data.
            timer = Timer(fire: Date(), interval: (1.0/2.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let adata = self.motion.accelerometerData {
                                    let x = String(format: "%.4f", adata.acceleration.x)
                                    let y = String(format: "%.4f", adata.acceleration.y)
                                    let z = String(format: "%.4f", adata.acceleration.z)
                                    
                                 //Use the accelerometer data in your app.
                                    self.XAxis.setText("X: "+x)
                                    self.YAxis.setText("Y: "+y)
                                    self.ZAxis.setText("Z: "+z)
                                }
                                //if let rdata = self.motion.gyroData {
                                    //let rx = String(format: "%.4f", rdata.rotationRate.x)
                                    //let ry = String(format: "%.4f", rdata.rotationRate.y)
                                    //let rz = String(format: "%.4f", rdata.rotationRate.z)
                                    
                                    //self.XRotAxis.setText("X: "+rx)
                                    //self.YRotAxis.setText("Y: "+ry)
                                    //self.ZRotAxis.setText("Z: "+rz)
                                //}
                                if let mdata = self.motion.magnetometerData {
                                    let mx = String(format: "%.4f", mdata.magneticField.x)
                                    let my = String(format: "%.4f", mdata.magneticField.y)
                                    let mz = String(format: "%.4f", mdata.magneticField.z)
                                    
                                    self.XMagAxis.setText("X: "+mx)
                                    self.YMagAxis.setText("Y: "+my)
                                    self.ZMagAxis.setText("Z: "+mz)
                                }
                                if let odata = self.motion.deviceMotion{
                                    let Ax = String(format: "%.4f", odata.userAcceleration.x)
                                    let Ay = String(format: "%.4f", odata.userAcceleration.y)
                                    let Az = String(format: "%.4f", odata.userAcceleration.z)
                                    let Rx = String(format: "%.4f", odata.rotationRate.x)
                                    let Ry = String(format: "%.4f", odata.rotationRate.y)
                                    let Rz = String(format: "%.4f", odata.rotationRate.z)
                                    var H = " "
                                    if #available(watchOSApplicationExtension 4.0, *) {
                                        H = String(format: "%.4f", odata.heading)
                                    }
                                    self.XMotAxis.setText("Ax: " + Ax)
                                    self.YMotAxis.setText("Ay: " + Ay)
                                    self.ZMotAxis.setText("Az: " + Az)
                                    self.HMot.setText("H: " + H)
                                    self.XRotAxis.setText("X: "+Rx)
                                    self.YRotAxis.setText("Y: "+Ry)
                                    self.ZRotAxis.setText("Z: "+Rz)
                                }
            })

        
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        
    }
    
    func updateButtonText(newText: String){
        theButton.setTitle(newText)
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

//
//  ExtensionDelegate.swift
//  Triathlon Trainer WatchKit Extension
//
//  Created by Justin Schaffner on 10/1/17.
//
//

import WatchKit
import CoreMotion
import HealthKit
import WatchConnectivity


extension CMSensorDataList: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}


class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, HKWorkoutSessionDelegate {
    let interface = InterfaceController()
    
    let healthStoreManager = HealthStoreManager()
    var workoutSession: HKWorkoutSession!
    
    var urlPath = String()
    let motion = CMMotionManager()
    var datalist = CMSensorDataList()
    var timer: Timer!
    var dict = [String: String]()
    var dat = Data()
    var dict2 = [String: String]()
    var recording: Bool! = false
    var recordTimer: Timer!
    var recordCounter = 60
    var startTime: Date!
    var endTime: Date!
    let session = WCSession.default
    let dateformat = DateFormatter()
    let recorder = CMSensorRecorder()
    let haveAccelerometer = CMSensorRecorder.isAccelerometerRecordingAvailable()
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print(error)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    
    func writeDict(dict: [String:String]){
        print("Got Dictionary")
        var outString = ""
        for x in dict{
            outString += x.key + "," + x.value
            print (x.key + "," + x.value)
        }
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd H:m:ss +SSSS"
        let fileName = dateformat.string(from: Date())
        //let dir = try? FileManager.default.url(for: .documentDirectory,
        //                                       in: .userDomainMask, appropriateFor: nil, create: true)
        
        let FM = FileManager()
        let dir = FM.containerURL(forSecurityApplicationGroupIdentifier: "group.triathlon.trainer")
        //let dir = try? FileManager.containerURL(FileManager)
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("csv") {
        
            
            // Write to the file named Test
            do {
                try outString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            urlPath = fileURL.relativePath
            print(urlPath)
            // Then reading it back from the file
//            var inString = ""
//            do {
//                inString = try String(contentsOf: fileURL)
//                print(inString)
//            } catch {
//                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
//            }
//            print("Read from the file: \(inString)")
        }
        else {print("Couldn't create fileURL")}
    }
    
    
    func startRecording(){
        dict.removeAll()
        startTime = Date()
        recording = true
        // Start a workout session
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .indoor
        
        // Create a workout session with the workout configuration
        do {
            workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError(error.localizedDescription)
        }
        workoutSession.delegate = self
        healthStoreManager.start(workoutSession)
        print("workoutstarted")
        recorder.recordAccelerometer(forDuration: 5 * 60)  // Record for 5 minutes
        if self.motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 1.0 / 30.0 // 30 Hz
            self.motion.startDeviceMotionUpdates(to: OperationQueue.current!) {deviceManager, error in
                let Ax = String(format: "%.4f", (deviceManager?.userAcceleration.x)!)
                let Ay = String(format: "%.4f", (deviceManager?.userAcceleration.y)!)
                let Az = String(format: "%.4f", (deviceManager?.userAcceleration.z)!)
                let Rx = String(format: "%.4f", (deviceManager?.rotationRate.x)!)
                let Ry = String(format: "%.4f", (deviceManager?.rotationRate.y)!)
                let Rz = String(format: "%.4f", (deviceManager?.rotationRate.z)!)
                let time:String = String(format:"%f", (deviceManager?.timestamp)!)
                let rec: String = Ax + "," + Ay + "," + Az + "," + Rx + "," + Ry + "," + Rz + " \n"
                //self.dateformat.dateFormat = "yyyy-MM-dd H:m:ss +SSSS"
                //let currentTime = self.dateformat.string(from: time)
                self.dict[time] = rec
                print(time + "," + rec)
            }
        }
        if haveAccelerometer{
            //print("recording")
            //recorder.recordAccelerometer(forDuration: 5 * 60)  // Record for 5 minutes
            
        }
        // Configure a timer to fetch the data.
        /*timer = Timer(fire: Date(), interval: (1.0/60.0),
                      repeats: true, block: { (timer) in
                        
                        if let odata = self.motion.deviceMotion{
                            let Ax = String(format: "%.4f", odata.userAcceleration.x)
                            let Ay = String(format: "%.4f", odata.userAcceleration.y)
                            let Az = String(format: "%.4f", odata.userAcceleration.z)
                            let Rx = String(format: "%.4f", odata.rotationRate.x)
                            let Ry = String(format: "%.4f", odata.rotationRate.y)
                            let Rz = String(format: "%.4f", odata.rotationRate.z)
                            
                            
                            //If recording, add values to the dict
                            let rec: String = Ax + "," + Ay + "," + Az + "," + Rx + "," + Ry + "," + Rz + " \n"
                            self.dateformat.dateFormat = "yyyy-MM-dd H:m:ss +SSSS"
                            let currentTime = self.dateformat.string(from: Date())
                            self.dict[currentTime] = rec
                        }
        })*/
        // Add the timer to the current run loop.
        //RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        
    }
    
    func stopRecording() throws {
        self.recording = false
        self.motion.stopDeviceMotionUpdates()
        endTime = Date()
        
        healthStoreManager.end(workoutSession)
        print("HKWorkout Ended")
        /*datalist = recorder.accelerometerData(from: startTime, to: endTime)!
        for (index, data) in datalist.enumerated(){
            let d = data as! CMRecordedAccelerometerData
            dict2[String(index)] = String(d.acceleration.x) + "," + String(d.acceleration.y) + "," + String(d.acceleration.z)
            print (String(index) + "," + String(d.acceleration.x) + "," + String(d.acceleration.y) + "," + String(d.acceleration.z))
        }*/
        
        writeDict(dict: dict)
        print("File created")
        //let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docurl = URL.init(fileURLWithPath: urlPath)
        session.transferFile(docurl, metadata: dict)
        print("file sent")
        interface.updateLabelText(newText: "file sent")
        self.dict.removeAll()
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        //let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        //infoPlist = NSDictionary(contentsOfFile: path)
        
        // wake up session to phone
        session.delegate = self
        session.activate()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }

}

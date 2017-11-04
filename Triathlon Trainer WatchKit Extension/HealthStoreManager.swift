/*
 See LICENSE.txt for this sample’s licensing information.
 
 Abstract:
 Manager for reading from and saving data into HealthKit
 */

import WatchKit
import HealthKit
import CoreLocation

class HealthStoreManager: NSObject, CLLocationManagerDelegate {
    
    
    private let healthStore = HKHealthStore()
    private var activeDataQueries = [HKQuery]()
    private var locationManager: CLLocationManager!
    
    // MARK: - Health Store Wrappers
    
    func start(_ workoutSession: HKWorkoutSession) {
        healthStore.start(workoutSession)
    }
    
    func end(_ workoutSession: HKWorkoutSession) {
        healthStore.end(workoutSession)
    }
    
    func pause(_ workoutSession: HKWorkoutSession) {
        healthStore.pause(workoutSession)
    }
    
    func resume(_ workoutSession: HKWorkoutSession) {
        healthStore.resumeWorkoutSession(workoutSession)
    }
}


/*
See LICENSE.txt for this sample’s licensing information.

Abstract:
UIApplication delegate.
*/

import UIKit
import HealthKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let manager = CLLocationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)
                     -> Bool {
        requestAccessToHealthKit()
        requestLocationServices()
        return true
    }

    private func requestAccessToHealthKit() {
        let healthStore = HKHealthStore()

        let allTypes = Set([HKObjectType.workoutType(),
                            HKSeriesType.workoutRoute(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    private func requestLocationServices() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestAlwaysAuthorization()
        }
    }
}

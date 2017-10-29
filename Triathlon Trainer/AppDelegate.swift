//
//  AppDelegate.swift
//  Triathlon Trainer
//
//  Created by Justin Schaffner on 10/1/17.
//
//

import UIKit
import CoreMotion
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print ("session active")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print ("Session Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    var window: UIWindow?
    var dict: [String: String] = [:]
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("App started")
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("WCSession started")
        }
        else{
            print("WCSession not supported")
        }
        return true
    }
    
    func session(_ session: WCSession,
                          didReceiveApplicationContext applicationContext: [String : String]){
        dict = applicationContext
        print("Got Dictionary")
        let times = Array(dict.keys)
        let values = Array(dict.values)
        for x in dict{
            print (x.key + "," + x.value)
        }
        let file = "file.csv" //this is the file. we will write to and read from it
        
        let text = "some text" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {print("Couldn't write to file")}
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


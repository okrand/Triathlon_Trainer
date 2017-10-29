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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dict: [String: String] = [:]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func session(_ session: WCSession,
                          didReceiveApplicationContext applicationContext: [String : String]){
        dict = applicationContext
        print(create(directory: "LALALA"))
        if store(dictionary: dict, in: "watchData", at: "LALALA"){
            print ("Store successful")
        }
    }
    
    func store(dictionary: Dictionary<String, String>, in fileName: String, at directory: String) -> Bool {
        let fileExtension = "txt"
        let directoryURL = create(directory:directory)
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            try data.write(to: directoryURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension))
            return true
        }  catch {
            print(error)
            return false
        }
    }
    
    func create(directory: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsDirectory.appendingPathComponent(directory)
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            fatalError("Error creating directory: \(error.localizedDescription)")
        }
        return directoryURL
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


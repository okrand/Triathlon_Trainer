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
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, UIPageViewControllerDelegate {
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
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("csv") {
            print(fileURL)
            
            // Write to the file named Test
            do {
                try outString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            //Then reading it back from the file
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
    
    
    func session(_ session: WCSession,
                          didReceive file: WCSessionFile){
        //let FM = FileManager()
        //let dir = FM.containerURL(forSecurityApplicationGroupIdentifier: "group.triathlon.trainer")
        let fileManager  = FileManager()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd H:m:ss +SSSS"
        let fileName = dateformat.string(from: Date())
        let dir2 = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName).appendingPathExtension("csv")
        do{
            try fileManager.moveItem(at: file.fileURL, to: dir2!)
            //try fileManager.moveItem(atPath: file.fileURL.relativePath, toPath: (dir2?.relativePath)!)
            print ("File Moved")
            print (dir2?.absoluteString ?? "dont know current directory")
        }
        catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
            print("Couldn't move file, don't know why Here's the file location")
            print(file.fileURL.relativePath)
            print("Here's the destination")
            print(dir2?.relativePath ?? "Don't know")
        }
    }
    
//    func session(_ session: WCSession,
//                          didReceiveApplicationContext applicationContext: [String : String]){
//        dict = applicationContext
//
//    }
    
   
    
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

//
//  AppDelegate.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import MBProgressHUD
import IQKeyboardManagerSwift

import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //appcare bundle id:- co.in.appcare.MyFishingBoat
    //client bundle id:- com.appcare.co.in.MyFishingBoat
    
    // let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Keyboard
        IQKeyboardManager.shared.enable = true
        
        //sleep the thread for displaying launch screen
        Thread.sleep(forTimeInterval: 2)
        
        //Google maps AIzaSyAW2rpP1Gn5-YQjRPslUI3bIQPCdtcmcPE
        GMSServices.provideAPIKey("AIzaSyBF-3N0u9TsMaEFyS7WuS-2qNB9gbhich0")
        GMSPlacesClient.provideAPIKey("AIzaSyBF-3N0u9TsMaEFyS7WuS-2qNB9gbhich0")
        
        //old self id
//        GMSServices.provideAPIKey("AIzaSyCxMewng1ajrBm_Z_5zGYBAIgD9LbsrmQY")
//        GMSPlacesClient.provideAPIKey("AIzaSyCxMewng1ajrBm_Z_5zGYBAIgD9LbsrmQY")
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
func applicationWillTerminate(_ application: UIApplication) {
      self.saveContext()
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyFishingBoatDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


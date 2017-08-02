//
//  AppDelegate.swift
//  TwitterClone
//
//  Created by Madhusudhan B.R on 7/25/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import CoreData

let appdelegate = UIApplication.shared.delegate as! AppDelegate
let redColor  = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let greenColor  = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)
var user: NSDictionary? 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundImageView = UIImageView()
    var errorViewShowing = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        user = UserDefaults.standard.value(forKey: "user") as! NSDictionary
        if user != nil{
            if let id = user?["id"] {
                login()
            }
        }
        
        backgroundImageView.image = UIImage(named: "mainbg.jpg")
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: window!.bounds.height * 1.668, height: window!.bounds.height)
        self.window?.addSubview(backgroundImageView)
        moveLeft()
        return true
    }
    
    func moveLeft(){
        UIView.animate(withDuration: 20, animations: {
            self.backgroundImageView.frame.origin.x = -self.backgroundImageView.frame.width + self.window!.bounds.width
        }) { (completed) in
            self.moveRight()
        }
    }
    
    
    func moveRight(){
        UIView.animate(withDuration: 20, animations: {
            self.backgroundImageView.frame.origin.x = 0
        }) { (completed) in
            self.moveLeft()
        }
    }
    
    //error view 
    
    func infoView(message: String, color: UIColor){
        if errorViewShowing == false {
            errorViewShowing = true
            let height = self.window!.bounds.height / 14.2
            let errorView = UIView(frame: CGRect(x: 0, y: -height , width: self.window!.bounds.width, height: height))
            errorView.backgroundColor = color
            self.window?.addSubview(errorView)
            
            let errorLabel = UILabel()
            errorLabel.numberOfLines = 0
            errorLabel.text = message
            errorLabel.textColor = UIColor.white
            
            errorView.addSubview(errorLabel)
            errorLabel.frame.size.width = errorView.bounds.width
            errorLabel.frame.size.height = errorView.bounds.height + UIApplication.shared.statusBarFrame.height/2
            errorLabel.font = UIFont(name: "HelveticaNeue", size: 11)
            errorLabel.textAlignment = .center
            
            
            UIView.animate(withDuration: 0.2, animations: {
                errorView.frame.origin.y = 0
            }, completion: { (done) in
                
                
                UIView.animate(withDuration: 0.2, delay: 4, options: .curveEaseOut, animations: {
                
                    errorView.frame.origin.y = -height
                }, completion: { (done2) in
                    errorView.removeFromSuperview()
                    errorLabel.removeFromSuperview()
                    self.errorViewShowing = false
                })
            })
        }
        
    }
    
    func login()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        window?.rootViewController = tabBar 
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TwitterClone")
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


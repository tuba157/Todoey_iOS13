//
//  AppDelegate.swift
//  Todoey_iOS13
//
//  Created by Tuba  Yalcinoz on 19.09.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // It gets called when the app gets loaded up.
        // First thing that happens, even before viewDidLoad
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // It gets triggered when the app is in the foreground. For example  when the user gets a phone call. This is the place where we can prevent that the user loses data. For example if they are filling a form.
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the backgroung state.
        // Use this metthod to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to relase shared ressources, save user data, invalidate timers, and store enough application state information to restore your application to its cuurent state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user wuits.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save the data if appropriate. See also applicationDidEnterBackground:.
        // Can be user or system triggered.
        // When the ressourses been reclaimed.
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


}


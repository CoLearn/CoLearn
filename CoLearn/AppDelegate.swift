//
//  AppDelegate.swift
//  CoLearn
//
//  Created by Rahul Krishna Vasantham on 2/24/16.
//  Copyright © 2016 CoLearn. All rights reserved.
//

import UIKit
import Parse
//import ParseFacebookUtilsV4
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set up app appearance
        UITabBar.appearance().tintColor = UIColor(hex: 0x71C9FF, alpha: 1)
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor(hex: 0x71C9FF, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
//        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurView = UIVisualEffectView(effect: lightBlur)
//        blurView.frame = UITabBar.appearance().bounds
//        UITabBar.appearance().addSubview(blurView)
//        UINavigationBar.appearance().addSubview(blurView)
        
//        let bounds = UINavigationBar.appearance().bounds as CGRect!
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
//        UIVisualEffectView.appearance().frame = bounds
//        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        UINavigationBar.appearance().addSubview(visualEffectView)
        
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "CoLearn"
                configuration.clientKey = "key-key-key"
                configuration.server = "http://colearnapp.herokuapp.com/parse"
            })
        )
//        Parse.setApplicationId("CoLearn", clientKey: "key-key-key")
        let result = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewControllerWithIdentifier("MainPageViewController")
            window?.rootViewController = vc
            return true
        } else {
            return result
        }
//        return true
    }
    
    /* After the Authentication, the application is redirected here */
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


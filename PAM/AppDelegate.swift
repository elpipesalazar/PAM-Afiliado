//
//  AppDelegate.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 10-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CRToast
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let types:UIUserNotificationType = ([.Alert, .Badge, .Sound])
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        GMSServices.provideAPIKey("AIzaSyCWWK5upI685vvq5PVpYbEH3iCD-ijh6RA")
        
        let backgroundColor = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        let foregroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        // status bar text color (.LightContent = white, .Default = black)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // solid or translucent background?
        UINavigationBar.appearance().translucent = false
        // remove bottom shadow
        UINavigationBar.appearance().shadowImage = UIImage()
        // background color
        UINavigationBar.appearance().setBackgroundImage(backgroundColor.toImage(), forBarMetrics: UIBarMetrics.Default)
        // controls and icons color
        UINavigationBar.appearance().tintColor = foregroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Poppins-Medium", size: 18)!, NSForegroundColorAttributeName: foregroundColor]
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if(UIApplication.sharedApplication().applicationIconBadgeNumber > 0){
            let destinationViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("TabViewController") as! TabViewController
            destinationViewController.selectedIndex = 1
            
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appDelegate.window?.rootViewController = destinationViewController
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
        
        SocketIOManager.sharedInstance.establishConnection()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.        
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        print(deviceTokenString)
        self.prefs.setValue(deviceTokenString, forKey: "deviceToken")
        self.prefs.synchronize()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let temp: NSDictionary = userInfo
        
        print(temp)
        
        let messageNotification = temp.valueForKey("aps")!.valueForKey("alert")!.valueForKey("body") as! String
        
        var badge:Int?
        
        if temp.valueForKey("aps")!.valueForKey("badge") != nil {
            badge = temp.valueForKey("aps")!.valueForKey("badge") as? Int
        }
        
        
        if application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background {
            let destinationViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("TabViewController") as! TabViewController
            destinationViewController.selectedIndex = 1
            
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appDelegate.window?.rootViewController = destinationViewController
            
        } else {
            
            let infoNotification = temp.valueForKey("aps")!.valueForKey("alert")!.valueForKey("data")! as! [NSObject : AnyObject]
            let type = infoNotification["type"] as? String
            
            // Opciones para la notificacion TOAST
            var options: Dictionary<NSObject, AnyObject> = [
                kCRToastNotificationTypeKey : CRToastType.NavigationBar.rawValue,
                kCRToastNotificationPresentationTypeKey : CRToastPresentationType.Cover.rawValue,
                kCRToastTimeIntervalKey : 5.0,
                kCRToastTextAlignmentKey : NSTextAlignment.Left.rawValue,
                kCRToastBackgroundColorKey : UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0),
                kCRToastAnimationInTypeKey : CRToastAnimationType.Gravity.rawValue,
                kCRToastAnimationOutTypeKey : CRToastAnimationType.Gravity.rawValue,
                kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
                kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue,
                kCRToastInteractionRespondersKey : [CRToastInteractionResponder(interactionType: CRToastInteractionType.Tap, automaticallyDismiss: true) { (r:CRToastInteractionType) -> Void in
                    
                    let destinationViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("TabViewController") as! TabViewController
                    destinationViewController.selectedIndex = 1
                    
                    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                    appDelegate.window?.rootViewController = destinationViewController
                    
                    }]
            ]
            
            options[kCRToastFontKey] = UIFont(name: "Poppins-Medium", size: 14.0)
            
            
            // Obtiene la vista actual
            let topController = UIApplication.topViewController()
            
            if(topController is NotificationsViewController){
                if let notificationView = topController as? NotificationsViewController {
                    notificationView.getNotifications(0)
                }
                
            } else {
                if badge != nil {
                    (topController!.tabBarController!.tabBar.items![1]).badgeValue = "\(badge!)"
                }
                
                options[kCRToastTextKey] = "\(messageNotification)"
                CRToastManager.showNotificationWithOptions(options, completionBlock: nil)
            }
        }

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error, terminator: "")
    }
}

extension UIColor{
    func toImage() -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, 100))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

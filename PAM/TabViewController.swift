//
//  TabViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 03-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 0/255.0, green: 136.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = color
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        let selectedColor = UIColor(red: 21.0/255.0, green: 130.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(selectedColor, size: CGSizeMake(tabBar.frame.width/3, tabBar.frame.height))
        
        // Uses the original colors for your images, so they aren't not rendered as grey automatically.
        for item in self.tabBar.items as [UITabBarItem]! {
            if let image = item.image {
                item.image = image.imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

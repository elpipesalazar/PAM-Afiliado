//
//  MenuViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 10-12-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    @IBOutlet var menu: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menu.scrollEnabled = false
        self.menu.delegate      =   self
        self.menu.dataSource    =   self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.row == 4){
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setValue("", forKey: "cveafiliado")
            prefs.setValue("", forKey: "idcuenta")
            prefs.setInteger(0, forKey: "isloggedin")
            prefs.synchronize()
            
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
        
        
        if(indexPath.row == 0){
            return false
        } else {
            return true
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

}

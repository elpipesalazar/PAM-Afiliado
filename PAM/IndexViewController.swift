//
//  IndexViewController.swift
//  MyTeam
//
//  Created by Francisco Miranda Gutierrez on 20-08-15.
//  Copyright (c) 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Controlador que maneja la validacion inicial
 */
class IndexViewController: UIViewController {
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta cada vez que carga la vista.
     
     - Checkea si el usuario esta logueado y segun la opcion es la vista que muestra (Login o Home)
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("isloggedin") as Int
        
        if (isLoggedIn == 1) {
            self.performSegueWithIdentifier("goToHome", sender: self)
            
        } else {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
    }
    
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     Metodo que se ejecuta cuando hay un warning de memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

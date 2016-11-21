//
//  AboutViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 16-02-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

/**
 Controlador que maneja la vista "En tus zapatos"
 */
class AboutViewController: UIViewController, UIWebViewDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webview: UIWebView!
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     
     - Instancia el menu hamburguesa (revealViewController)
     - Instancia el metodo loadAdressUrl()
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.delegate = self
        self.loadAdressUrl()
    }
    
    /**
     Metodo que se ejecuta cuando hay un warning de memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     Metodo que carga la URL de "https://es.americanassist.com/organizacion" en el webview correspondiente
     */
    func loadAdressUrl(){
        self.showLoading()
        
        let requestURL = NSURL(string: "https://es.americanassist.com/organizacion")
        let request = NSURLRequest(URL: requestURL!)
        self.webview.loadRequest(request)
    }
    
    /**
     Metodo que se ejecuta cuando el webview carga la pagina web
     */
    func webViewDidFinishLoad(webView: UIWebView){
        self.hideLoading()
    }
    
    /**
     Muestra la ventana de cargando general.
     */
    func showLoading() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Cargando"
        loadingNotification.yOffset = -20.0
    }
    
    /**
     Oculta la ventana de cargando.
     */
    func hideLoading() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }

}

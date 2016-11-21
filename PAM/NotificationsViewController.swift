//
//  NotificationsViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 28-09-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

/**
 Controlador que maneja los metodos de la vista "Notificaciones"
 */
class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables Generales
    /// Constante que instancia NotificationList()
    let notificationList = NotificationList()
    
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var assistId:Int?
    
    var page:Int = 0
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     
     - Instancia la celda para la tabla
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "NotificationCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.alpha = 0
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 56.0
        
        self.getNotifications(self.page)
        
        // change indicator view style to white
        tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (tableView) -> Void in
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            //let indexPaths = [NSIndexPath]() // index paths of updated rows
            
            // make sure you update tableView before calling -finishInfiniteScroll
            //tableView.beginUpdates()
            //tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            //tableView.endUpdates()
            
            self.getNotifications(self.page)
            print("Pagina: \(self.page)")
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.page = 0
        notificationList.items.removeAll()
        self.getNotifications(self.page)
        
        print("Pagina: \(self.page)")
        
        (self.tabBarController!.tabBar.items![1]).badgeValue = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Metodo que devuelve los planes del cliente.
     
     Envia los datos a la API que despues son enviadas al servidor.
     */
    func getNotifications(page: Int){
        self.showTitleActivityIndicator()
        //Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        //let limit:Int = 5
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.getNotifications(self.notificationList, cveUser: cveUser, limit: page, country: country, responseBlock: {
            (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //Loading.hideLoading(self.view)
                self.hideTitleActivityIndicator()
                
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let messageError = res.valueForKey("message") as! String
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: messageError)
                    } else if(error && code != 200 && code != 408) {
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                    } else {
                        self.page = self.notificationList.items.count
                        //self.page = self.page + 5
                        self.checkItemsTable()
                    }
                }
            })
            
        })
    }
    
    
    // Arribar proveedores
    func arrivalProv(assistId: Int, notificationId: Int, indexPath: NSIndexPath){
        Loading.showLoading(self.view, offset: 10.0, title: "Cargando")
        
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.arrivalProv(assistId, notificationId:notificationId, country:country, responseBlock: {
            (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Loading.hideLoading(self.view)
                
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let messageError = res.valueForKey("message") as! String
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: messageError)
                        
                    } else if(error && code != 200 && code != 408) {
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                    } else {
                        Alerts.showSimpleAlert(self, title: "Muchas Gracias!", message: "Se ha enviado su aviso.")
                        
                        self.notificationList.items.removeAtIndex(indexPath.row)
                        
                        self.tableView.beginUpdates()
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        self.tableView.endUpdates()
                        self.tableView.reloadData()
                        
                        self.checkItemsTable()
                    }
                }
            })
            
        })
    }
    
    
    /**
     Metodo que revisa si el array del modelo Plan tiene datos. Si tiene muestra la tabla, de lo contrario no la muestra
     */
    func checkItemsTable(){
        if(notificationList.items.count > 0){
            self.tableView.reloadData()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.alpha = 1
            })
        } else {
            self.tableView.alpha = 0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NotificationViewCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell") as! NotificationViewCell
        let item = self.notificationList.items[indexPath.row]
        
        let typeNotification = item.typeNotification
        
        var icoNotification = ""
        
        if(typeNotification == "conf_llegada_proveedor") {
            icoNotification = "Info"
        } else if(typeNotification == "reasig_prov" || typeNotification == "serv_sin_cobertura") {
            icoNotification = "Problem"
        } else {
            icoNotification = "Good"
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if(typeNotification == "encuesta" || typeNotification == "conf_llegada_proveedor"){
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        cell.icoNotification.image = UIImage(named: icoNotification)
        cell.notificationText.text = "\(item.message)"
        
        return cell
    }
    
    
    final func showArrival(assistId:Int, notificationId:Int, indexPath:NSIndexPath){
        let alert = UIAlertController(title: "Atención", message: "Por favor informanos si el proveedor a llegado.", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Si, ha llegado", style: .Default, handler: { (action) -> Void in
            self.arrivalProv(assistId, notificationId: notificationId, indexPath:indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /**
     Metodo que permite el envio y proceso de datos a traves de los "segue"
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToPoll"){
            let vc = segue.destinationViewController as! PollNotificationViewController
            vc.assistId = self.assistId!
        }
    }
    
    
    //MARK: TableView Delegate
    /**
     Metodo que se ejecuta cuando presionas una celda de la tabla.
     
     Al pinchar la celda envia al usuario a la siguiente vista.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.notificationList.items[indexPath.row]
        
        let notificationId = item.id
        let typeNotification = item.typeNotification
        
        if(typeNotification == "conf_llegada_proveedor") {
            if let assistId = item.assistId {
                self.showArrival(assistId, notificationId: notificationId, indexPath:indexPath)
            }
        }
        
        if(typeNotification == "encuesta") {
            if let assistId = item.assistId {
                self.assistId = assistId
                
                self.performSegueWithIdentifier("goToPoll", sender: self)
            }
        }
        
        if(typeNotification == "serv_sin_cobertura") {
            let phone = item.phone
            Alerts.showCallAlert(self, title: "Llamar al Call Center", message: "¿Desea llamar al call center para poder solucionar su problema?", phone: "\(phone!)", closeView: false)
        }
    }
    
    
    func showTitleActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.frame = CGRectMake(0, 0, 44, 44)
        activityIndicatorView.color = UIColor.whiteColor()
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = "Cargando"
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 16)
        titleLabel.textColor = UIColor.whiteColor()
        
        let fittingSize = titleLabel.sizeThatFits(CGSizeMake(200.0, activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRectMake(activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width - 6, 10, fittingSize.width, fittingSize.height)
        
        
        let titleView = UIView(frame: CGRectMake(((activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2), ((activityIndicatorView.frame.size.height) / 2), (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width), (activityIndicatorView.frame.size.height)))
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    func hideTitleActivityIndicator() {
        self.navigationItem.titleView = nil
    }
}

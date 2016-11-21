//
//  TrackingViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 10-12-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class TrackingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let trackingList = TrackingList()
    var selectedItem: TrackingItem?
    
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TrackingCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TrackingCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.alpha = 0
        
        self.getRequestsUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getRequestsUser(){
        Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        //let clientId:String = self.prefs.objectForKey("idcuenta") as! String
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.getRequestsUser(self.trackingList, cveUser: cveUser, country: country, responseBlock: {
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
                        Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estes conectado a internet por favor.")
                    } else {
                        self.checkItemsTable()
                    }
                }
            })
            
        })
    }
    
    func cancelRequest(assistId: String, reason: String, indexPath: NSIndexPath){
        Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.cancelRequest(self.trackingList, assistId: assistId, reason: reason, country: country, responseBlock: {
            (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Loading.hideLoading(self.view)
                
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let messageError = res.valueForKey("message") as! String
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: messageError)
                        
                    } else if(error && code != 200 && code != 408 && code != 401) {
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estes conectado a internet por favor.")

                    } else {
                        self.trackingList.items.removeAtIndex(indexPath.row)
                        
                        self.tableView.beginUpdates()
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        self.tableView.endUpdates()
                        self.tableView.reloadData()
                        
                        self.checkItemsTable()
                        
                        let messageSuccess = res.valueForKey("message") as! String
                        Alerts.showSimpleAlert(self, title: "Muy Bien!", message: messageSuccess)
                    }
                }
                
            })
            
        })
    }
    
    //MARK: Metodos tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackingList.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TrackingViewCell = tableView.dequeueReusableCellWithIdentifier("TrackingCell") as! TrackingViewCell
        let item = self.trackingList.items[indexPath.row]
        
        cell.service.text = "\(item.service)"
        
        let arrayDate = item.dateRequest.componentsSeparatedByString(" ")
        let date = arrayDate[0]
        let hour = arrayDate[1]
        
        cell.dateRequest.text = "\(self.trackingList.convertDateFormater(date).capitalizedString) a las \(self.trackingList.convertHourFormater(hour))"
        
        let assistId = item.id
        
        let exitButton = MGSwipeButton(title: "Cancelar", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.showCancelAlert("Atención!", message: "¿Estás seguro que quieres cancelar esta solicitud?", assistId: assistId, indexPath: indexPath)
            self.tableView.editing = false
            
            return true
        })
        
        exitButton.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
        
        cell.rightButtons = [exitButton]
        
        return cell
    }
    
    //MARK: Metodos tableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.trackingList.getItem(indexPath.row)
        
        if(selectedItem!.status == true){
            if let _ = self.selectedItem?.lat {
                self.performSegueWithIdentifier("goToMapTracking", sender: self)
            }
        } else {
            showAlert("Lo sentimos!", message: "Aun su solicitud no ha sido asignada. Por favor espere unos minutos.")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }
    

    func showCancelAlert(title:String, message:String, assistId:String, indexPath:NSIndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Ingrese Motivo"
        }
        
        alert.addAction(UIAlertAction(title: "Si", style: .Default, handler: { action in
            let reasonUser = alert.textFields![0].text
            
            if(reasonUser != ""){
                self.cancelRequest(assistId, reason: reasonUser!, indexPath: indexPath)
            } else {
                self.showAlert("Alerta", message: "Debes ingresar el motivo por el cual deseas cancelar esta solicitud")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { action in
           
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkItemsTable(){
        if(self.trackingList.items.count > 0){
            self.tableView.reloadData()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.alpha = 1
            })
        } else {
            self.tableView.alpha = 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToMapTracking"){
            let vc = segue.destinationViewController as! MapTrackingViewController
            vc.trackingItem = self.selectedItem
        }
    }

}

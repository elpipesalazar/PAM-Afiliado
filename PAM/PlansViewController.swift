//
//  PlansViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

/**
 Controlador que maneja los metodos de la vista "Planes"
 */
class PlansViewController: UIViewController, UITableViewDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: Variables Generales
    /// Constante que instancia PlanList()
    let planList = PlanList()
    
    /// Variable que guarda el item (plan) seleccionado
    var selectedItem: PlanItem?
    
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     
     - Instancia el menu hamburguesa (revealViewController)
     - Instancia la celda para la tabla
     - Ejecuta el metodo getPlansByClient() que devuelve los planes del usuario
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        let nib = UINib(nibName: "PlanCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PlanCell")
        
        self.tableView.dataSource = planList
        self.tableView.delegate = self
        self.tableView.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.getPlansByClient()
    }
    
    /**
     Metodo que se ejecuta cuando hay un warning de memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Metodo que devuelve los planes del cliente.
     
     Envia los datos a la API que despues son enviadas al servidor.
     */
    func getPlansByClient(){
        Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        let clientId:String = self.prefs.objectForKey("idcuenta") as! String
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.getPlansByClient(self.planList, cveUser: cveUser, clientId: clientId, country: country, responseBlock: {
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
        if(planList.items.count > 0){
            self.tableView.reloadData()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.alpha = 1
            })
        } else {
            self.tableView.alpha = 0
        }
    }
    
    /**
     Metodo que permite el envio y proceso de datos a traves de los "segue"
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToAssists"){
            //print("id elemento seleccionado \(self.selectedItem!.id)")
            let vc = segue.destinationViewController as! AssistsViewController
            vc.planItem = self.selectedItem
        }
    }
    
    
    //MARK: TableView Delegate
    /**
     Metodo que se ejecuta cuando presionas una celda de la tabla.
     
     Al pinchar la celda envia al usuario a la siguiente vista.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.planList.getItem(indexPath.row)
        self.performSegueWithIdentifier("goToAssists", sender: self)
    }
    
    /**
     Define el alto que tendran las celdas en la tabla.
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }

}

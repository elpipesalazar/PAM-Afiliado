//
//  AssistsViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD
import SwiftyJSON

/**
 Controlador que maneja los metodos de la vista "Asistencias"
 */
class AssistsViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // MARK: Variables Generales
    /// Constante de locationManager
    let locationManager = CLLocationManager()
    /// Variable que almacena coordenadas
    var coordinate: CLLocationCoordinate2D!
    /// Variable que almacena un string para definir el status
    var locationStatus: NSString = "Not Started"
    /// Variable tipo Bool para definir si la locacion ha sido generada
    var locationFixAchieved: Bool = false
    
    /// Variable que almacena el id de la asistencia
    var assistId:String?
    /// Variable que define si es una emergencia o no
    var esemergencia:Bool = false
    /// Variable que almacena el telefono del usuario
    var phoneUser:String?
    /// Variable que almacena la direccion del usuario
    var addressUser:String?
    /// Variable que almacena la observacion del usuario
    var referenceUser:String?
    
    var lat:Double?
    var lng:Double?
    
    /// Constante que instancia AssistanceList()
    let assistanceList = AssistanceList()
    
    /// Variable que instancia PlanItem
    var planItem: PlanItem!
    
    /// Variable que guarda el item (asistencia) seleccionado
    var selectedItem: AssistanceItem?
    
    var listQuestions: [QuestionItem] = []
    
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     
     - Modifica el color de fondo de la cabecera y el color del texto
     - Instancia la celda para la tabla
     - Ejecuta el metodo getAssistsByPlan() que devuelve las asistencia del plan seleccionado
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        let foregroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        navigationController!.navigationBar.translucent = false
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.setBackgroundImage(backgroundColor.toImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.tintColor = foregroundColor
        navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Poppins-Medium", size: 18)!, NSForegroundColorAttributeName: foregroundColor]
        
        self.backButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()],
            forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = self.backButton

        let nib = UINib(nibName: "AssistanceCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AssistanceCell")
        
        self.tableView.dataSource = assistanceList
        self.tableView.delegate = self
        self.tableView.alpha = 0
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 62.0
        
        self.getAssistsByPlan(self.planItem.id)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.locationFixAchieved = false
        self.listQuestions.removeAll()
    }
    
    /**
     Metodo que se ejecuta cuando hay un warning de memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Metodo que permite cerrar la vista y volver a la anterior
     */
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /**
     Metodo que devuelve las asistencias del plan seleccionado.
     
     Envia los datos a la API que despues son enviadas al servidor.
     
     - Parameters:
        - planId: id de plan
     */
    func getAssistsByPlan(planId: String){
        Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        let clientId:String = self.prefs.objectForKey("idcuenta") as! String
        let country:String = self.prefs.objectForKey("country") as! String
        
        API.getAssistsByPlan(self.assistanceList, cveUser: cveUser, clientId: clientId, planId: planId, country: country, responseBlock: {
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
     Checkea la localizacion y afirma que es una emergencia
     
     - Parameters:
        - assistId: String
        - phoneUser: String
        - addressUser: String
        - esemergencia: Bool
     */
    func sendSOANNG(assistId:String, phoneUser:String, addressUser:String, referenceUser:String, esemergencia:Bool){
        //Loading.showLoading(self.view, offset: nil, title: "Enviando")
        
        self.assistId = assistId
        self.esemergencia = esemergencia
        self.phoneUser = phoneUser
        self.addressUser = addressUser
        self.referenceUser = referenceUser
        
        if(addressUser != ""){
            self.lat = 0.0
            self.lng = 0.0
            
            let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
            let clientId:String = self.prefs.objectForKey("idcuenta") as! String
            let country:String = self.prefs.objectForKey("country") as! String
            
            let planId:String = self.planItem.id
            let assistId:String = self.assistId!
            let esemergencia:Bool = self.esemergencia
            let phoneUser:String = self.phoneUser!
            let addressUser:String = self.addressUser!
            let referenceUser:String = self.referenceUser!
            
            Loading.showLoading(self.view, offset: nil, title: "Cargando")
            
            self.sendAssistToSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: self.lat!, lng: self.lng!, esemergencia: esemergencia, country: country, phone: phoneUser, address: addressUser, reference: referenceUser)
        } else {
           self.initLocationManager()
        }
        
    }
    
    
    //cveUser:String, clientId:String, planId:String, assistId:String, lat:Double, lng:Double, esemergencia:Bool, country:String, phone:String, address:String, reference:String
    
    /**
     Envia la informacion al SOANNG
     
     - Parameters:
        - cveUser: String
        - clientId: String
        - planId: String
        - assistId: Bool
        - lat: Double
        - lng: Double
        - addressUser: String
        - esemergencia: Bool
        - country: String
        - phone: String
        - address: String
        - reference: String
     */
    func sendAssistToSOANNG(cveUser:String, clientId:String, planId:String, assistId:String, lat:Double, lng:Double, esemergencia:Bool, country:String, phone:String, address:String, reference:String){
        
        API.sendSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: lat, lng: lng, esemergencia: esemergencia, date: "", phone: phone, address: address, reference: reference, description: "", country: country, responseBlock: { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    self.locationFixAchieved = false
                    
                    let json = JSON(res)
                    
                    if(error && code == 200){
                        let phone = json["result"]["numero_cuenta"]
                        let messageError = res.valueForKey("message") as! String
                        
                        Alerts.showCallAlert(self, title: "Lo sentimos!", message: messageError, phone: "\(phone)", closeView: false)
                        
                    } else if(error && code != 200 && code != 408) {
                        Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                    } else {
                        
                        //let json = JSON(res)
                        let questions = json["result"]["preguntas"]
                        
                        //print(questions)
                        
                        if(questions.count > 0){
                            for (_, data):(String, JSON) in questions {
                                //print("jsonData: \(data)")
                                
                                let question = QuestionItem()
                                question.id = Int(data["id"].stringValue)
                                question.type = data["type"].stringValue
                                question.label = data["label"].stringValue
                                question.placeholder = data["placeholder"].stringValue
                                question.parentQuestion = data["parent"].stringValue
                                question.childrens = data["childrens"].arrayObject
                                
                                let optionsQuestion = data["options"].array
                                
                                if optionsQuestion?.count > 0 {
                                    var optionArray:[OptionQuestionItem] = []
                                    
                                    for option in optionsQuestion! {
                                        let optionItem = OptionQuestionItem()
                                        optionItem.option = option["option"].stringValue
                                        optionItem.valueOption = option["value"].stringValue
                                        optionItem.isNewQuestion = option["isNewQuestion"].stringValue
                                        optionItem.childQuestion = Int(option["child"].stringValue)
                                        optionItem.exitQuestion = option["exit"].stringValue
                                        
                                        optionArray.append(optionItem)
                                    }
                                    
                                    question.options = optionArray
                                    
                                    //print("Cantidad de opciones: \(question.options?.count)")
                                } else {
                                    question.options = []
                                }
                                
                                print("Pregunta: \(question.label)")
                                
                                self.listQuestions.append(question)
                            }
                            
                            self.performSegueWithIdentifier("goToForm", sender: self)
                        } else {
                            Alerts.showSimpleAlert(self, title: "Muy Bien!", message: "Hemos recibido tu solicitud")
                        }
                
                    }
                    
                    Loading.hideLoading(self.view)
                }
            })
            
        })
    }
    
    /**
     Inicia la consulta para obtener la geolocalizacion del usuario.
     */
    func initLocationManager() {
        Loading.showLoading(self.view, offset: nil, title: "Cargando")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    /**
     Metodo que muestra una alerta consultando si es una emergencia o no.
     */
    func showEmergencyAlert() {
        let alertEmergency = UIAlertController(title: "¿Esto es una emergencia?", message: "Por favor indicanos si es una emergencia, de lo contrario podemos programar la visita.", preferredStyle: .Alert)
        
        self.presentViewController(alertEmergency, animated: true, completion: nil)
        
        alertEmergency.addAction(UIAlertAction(title: "Si", style: .Default, handler: { (action) -> Void in
            //print("respuesta Si")
            self.showMoreInfoInputAlert()
        }))
        
        alertEmergency.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action) -> Void in
            self.performSegueWithIdentifier("goToProgramming", sender: self)
        }))
        
        alertEmergency.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: { (action) -> Void in
            
        }))
    }
    
    
    /**
     Metodo que muestra una alerta pidiendo mas informacion.
     */
    func showMoreInfoInputAlert() {
        // IF IOS 8
        let enterPhoneAlert = UIAlertController(title: "Necesitamos mas información", message: "Por favor indicanos un número de teléfono al cual contactarnos, si la emergencia no es en el lugar que te encuentras indicanos la dirección y si estas en un edificio indicanos el piso y departamento en el campo Observacion.", preferredStyle: .Alert)
        
        enterPhoneAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Ingrese Nº de teléfono"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        enterPhoneAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Ingrese Dirección (Opcional)"
        }
        
        enterPhoneAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Ingrese Referencia (Opcional)"
        }
        
        enterPhoneAlert.addAction(UIAlertAction(title: "Solicitar", style: .Cancel, handler: { (action) -> Void in
            let phoneUser = enterPhoneAlert.textFields![0].text
            let addressUser = enterPhoneAlert.textFields![1].text
            let referenceUser = enterPhoneAlert.textFields![2].text
            
            if(phoneUser == ""){
                Alerts.showSimpleAlert(self, title: "Alerta!", message: "Debes ingresar un Nº de teléfono")
            } else {
                var address:String = ""
                
                if addressUser == nil {
                    address = ""
                } else {
                    address = addressUser!
                }
                
                var reference:String = ""
                
                if referenceUser == nil {
                    reference = ""
                } else {
                    reference = referenceUser!
                }
                
                //print("Se envia a soaang")
                
                self.sendSOANNG(self.assistId!, phoneUser: phoneUser!, addressUser: address, referenceUser: reference, esemergencia: true)
            }
        }))
        
        enterPhoneAlert.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: { (action) -> Void in
            enterPhoneAlert.textFields![0].resignFirstResponder()
            enterPhoneAlert.textFields![1].resignFirstResponder()
            enterPhoneAlert.textFields![2].resignFirstResponder()
        }))
        
        self.presentViewController(enterPhoneAlert, animated: true, completion: nil)
    }
    
    
    /**
     Metodo que revisa si el array del modelo Asistencia tiene datos. Si tiene muestra la tabla, de lo contrario no la muestra
     */
    func checkItemsTable(){
        if(assistanceList.items.count > 0){
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
        if(segue.identifier == "goToProgramming"){
            let vc = segue.destinationViewController as! ProgrammingViewController
            
            let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
            let clientId:String = self.prefs.objectForKey("idcuenta") as! String
            let planId:String = self.planItem.id
            let assistId:String = self.assistId!
            let esemergencia:Bool = false
            //let lat = self.coordinate.latitude
            //let lng = self.coordinate.longitude
            
            vc.cveUserVc = cveUser
            vc.clientIdVc = clientId
            vc.planIdVc = planId
            vc.assistIdVc = assistId
            vc.esemergenciaVc = esemergencia
            //vc.latVc = lat
            //vc.lngVc = lng
            
        }
        
        if(segue.identifier == "goToForm"){
            let vc = segue.destinationViewController as! FormViewController
            
            vc.listQuestions.removeAll()
            vc.listQuestions = self.listQuestions
            
            let planId:String = self.planItem.id
            let assistId:String = self.assistId!
            let esemergencia:Bool = self.esemergencia
            let phoneUser:String = self.phoneUser!
            let addressUser:String = self.addressUser!
            let referenceUser:String = self.referenceUser!
            
            vc.planId = planId
            vc.assistId = assistId
            vc.lat = self.lat!
            vc.lng = self.lng!
            vc.esemergencia = esemergencia
            vc.phone = phoneUser
            vc.address = addressUser
            vc.reference = referenceUser
        }
    }
    
    // MARK: CLocation Delegate
    /**
     Al ejecutarse obtiene las coordenadas del usuario y ejecuta el metodo sendAssistToSOANNG
     
     - Parameters:
        - manager: Informacion del tipo CLLocationManager
        - locations: Array del tipo CLLocation (Entrega las coordenadas)
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Loading.hideLoading(self.view)
        
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        let clientId:String = self.prefs.objectForKey("idcuenta") as! String
        let country:String = self.prefs.objectForKey("country") as! String
        
        let planId:String = self.planItem.id
        let assistId:String = self.assistId!
        let esemergencia:Bool = self.esemergencia
        let phoneUser:String = self.phoneUser!
        let addressUser:String = self.addressUser!
        let referenceUser:String = self.referenceUser!
        
        if (locationFixAchieved == false){
            locationFixAchieved = true
            manager.stopUpdatingLocation()
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            
            self.coordinate = locationObj.coordinate
            
            self.lat = self.coordinate.latitude
            self.lng = self.coordinate.longitude
            
            self.sendAssistToSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: self.lat!, lng: self.lng!, esemergencia: esemergencia, country: country, phone: phoneUser, address: addressUser, reference: referenceUser)
        }
        
        //else {
        //    self.lat = self.coordinate.latitude
        //    self.lng = self.coordinate.longitude
            
        //    self.sendAssistToSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: self.lat!, lng: self.lng!, esemergencia: esemergencia, country: country, phone: phoneUser, address: addressUser, reference: referenceUser)
       // }
    }
    
    /**
     Se ejecuta al existir un cambio en los permisos para la obtencion de coordenadas
     
     - Parameters:
        - manager: Informacion del tipo CLLocationManager
        - status: Informacion del tipo CLAuthorizationStatus (Tiene una gama de opciones como: .Restricted, .Denied, .NotDetermined, etc)
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location"
            shouldIAllow = true
        }
        
        if(shouldIAllow == true) {
            print("Location to allowed", terminator: "")
        } else {
            print("Denied access: \(locationStatus)", terminator: "")
            
            if (locationStatus != "Status not determined"){
                Loading.hideLoading(self.view)
                
                let alert = UIAlertController(title: "Activa el GPS", message: "Para poder enviar la solicitud debes habilitar el GPS. Lo puedes hacer en Ajustes -> PAM -> Localización.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Habilitar GPS", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
                    
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: { (action) -> Void in
                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    /**
     Metodo que se ejecuta cuando hay un error en la solicitud de coordenadas
     
     - Parameters:
        - manager: Informacion del tipo CLLocationManager
        - error: Informacion del tipo NSError
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)", terminator: "")
    }

    //MARK: TableView Delegate
    /**
     Metodo que se ejecuta cuando presionas una celda de la tabla.
     
     Al pinchar la celda envia al usuario a la siguiente vista.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.showEmergencyAlert()
        
        self.selectedItem = self.assistanceList.getItem(indexPath.row)
        self.assistId = self.selectedItem!.id
        
    }

}

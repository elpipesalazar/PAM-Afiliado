//
//  LoginViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 10-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

/**
    Controlador que maneja los metodos de la vista "Login"
*/
class LoginViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var validateAccountButton: UIButton!
    @IBOutlet weak var contUsername: UIView!
    @IBOutlet weak var contPassword: UIView!
    
    // MARK: Variables Generales
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /// Constante de locationManager
    let locationManager = CLLocationManager()
    /// Variable que almacena coordenadas
    var coordinate: CLLocationCoordinate2D!
    /// Variable que almacena un string para definir el status
    var locationStatus: NSString = "Not Started"
    /// Variable tipo Bool para definir si la locacion ha sido generada
    var locationFixAchieved: Bool = false
    
    /// Variable con instancia de UIPickerView (Para poder mostrar una lista)
    var clientsListPicker = UIPickerView()
    
    /// Variable tipo String que almacena el tipo de identificador
    var identificationType:String = ""
    
    
    // MARK: Metodos
    /**
        Metodo que se ejecuta una sola vez cuando carga la vista.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.scrollViewTapped(_:)))
        self.scrollView.addGestureRecognizer(theTap)
        
        self.initLocationManager()
    }
    
    /**
        Metodo que se ejecuta cuando hay un warning de memoria
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
        Inicia la consulta para obtener la geolocalizacion del usuario.
    */
    func initLocationManager() {
        Loading.showLoading(self.view, offset: nil, title: "Buscando tu ubicación")
        
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
        Envia la consulta de login al servidor.
     
        - Returns: Si hay algun error devuelve una alerta, si no hay error ejecuta el "segue" correspondiente para mostrar la vista principal
    */
    @IBAction func login(sender: UIButton) {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if (username == "" || password == "") {
            Alerts.showSimpleAlert(self, title: "Alerta!", message: "Debe ingresar su usuario y contraseña por favor.")
            
        } else {
            Loading.showLoading(self.view, offset: nil, title: "Ingresando")
            
            var deviceToken:String = ""
            
            if let token = self.prefs.objectForKey("deviceToken") {
                deviceToken = token as! String
            }
            
            //let country:String = self.prefs.objectForKey("country") as! String
            
            API.login(username!, password: password!, deviceToken: deviceToken, responseBlock: {
                (response) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Loading.hideLoading(self.view)
                    
                    if let res = response {
                        let error = res.valueForKey("error") as! Bool
                        let code = res.valueForKey("code") as! Int
                        
                        if(error && code == 200){
                            let messageError = res.valueForKey("message") as! String
                            Alerts.showSimpleAlert(self, title: "Alerta", message: messageError)
                            
                        } else if(error && code != 200 && code != 408) {
                            Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                        } else if(error && code == 408) {
                            Alerts.showSimpleAlert(self, title: "Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                        } else {
                            self.performSegueWithIdentifier("goToHome", sender: self)
                        }
                    }
                })
                
            })
        }
    }
    
    /**
        Envia al usuario a la vista de registro.
    */
    @IBAction func validateAccount(sender: UIButton) {
        self.performSegueWithIdentifier("goToValidateAccount", sender: self)
    }
    
    
    /**
        Oculta el teclado cuando se hace tap en el scrollview
    */
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.scrollView.endEditing(true)
    }
    
    /**
        Metodo que permite el envio y proceso de datos a traves de los "segue"
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToValidateAccount"){
            //let navVC = segue.destinationViewController as! UINavigationController
            //let vc = navVC.viewControllers.first as! RegisterViewController
            
            //vc.codeClient = self.codeClient
            //vc.cveUser = self.usernameTextField.text!
        }
    }
    
    
    // MARK: CLocation Delegate
    /**
        Se ejecuta cuando exista una actualizacion de la posicion del usuario
     
        - Parameters:
            - manager: Informacion del tipo CLLocationManager
            - locations: Array del tipo CLLocation (Entrega las coordenadas)
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false){
            locationFixAchieved = true
            
            manager.stopUpdatingLocation()
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            
            self.coordinate = locationObj.coordinate
            
            CLGeocoder().reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil){
                    Loading.hideLoading(self.view)
                    Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tiene problemas con su conexión.")
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    self.displayLocationInfo(pm)
                } else {
                    Loading.hideLoading(self.view)
                    Alerts.showSimpleAlert(self, title: "Lo sentimos!", message: "Tiene problemas con su conexión.")
                    print("Problem with the data received from geocoder")
                }
            })
            
            
        }
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
                
                let alert = UIAlertController(title: "Activa el GPS", message: "Para poder mostrar los clientes disponibles debes habilitar el GPS. Lo puedes hacer en Ajustes -> PAM -> Localización.", preferredStyle: UIAlertControllerStyle.Alert)
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
        Obtiene el pais del usuario y lo guarda en memoria local
     
        - Parameters:
            - placemark: Informacion proveniente de un geocoder
    */
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            //self.locationManager.stopUpdatingLocation()
            
            //let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            //let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            //let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
           
            //print(locality)
            //print(postalCode)
            //print(administrativeArea)
            print(country?.lowercaseString)
            
            Loading.hideLoading(self.view)
            
            //let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            //prefs.setValue(country!.lowercaseString, forKey: "country")
            //prefs.setValue("colombia", forKey: "country")
            //prefs.synchronize()
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
        Loading.hideLoading(self.view)
        self.initLocationManager()
    }

}

//
//  RegisterViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 10-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

/**
 Controlador que maneja los metodos de la vista "Registro"
*/
class RegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var clientsTextField: UITextField!
    @IBOutlet weak var cveAfiliadoText: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    // MARK: Variables Generales
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /// Variable con instancia de UIPickerView (Para poder mostrar una lista)
    var clientsListPicker = UIPickerView()
    
    /// Variable con instancia del modelo ClientList
    var clientList = ClientList()
    
    /// Variable tipo String que almacena el tipo de identificador
    var identificationType:String = ""
    /// Variable tipo String que almacena el codigo de cliente
    var codeClient:String = ""
    /// Variable tipo String que almacena el ultimo cliente que se selecciona en el listado de clientes
    var lastClient: String = ""
    
    // MARK: Metodos
    
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.scrollViewTapped(_:)))
        self.scrollView.addGestureRecognizer(theTap)
        
        
        let placeholderColor = UIColor(red:165.0/255.0, green:165.0/255.0, blue:165.0/255.0, alpha:1.0)
        
        self.clientsTextField.attributedPlaceholder = NSAttributedString(string:"Puedes seleccionar el que desees",
        attributes:[NSForegroundColorAttributeName: placeholderColor])
        
        self.instanceClientsListPicker()
        
        let country:String = self.prefs.objectForKey("country") as! String
        
        print("pais: \(country)")
        self.getClientsByCountry(country)
    }

    /**
     Metodo que se ejecuta cuando hay un warning de memoria
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Metodo que permite cerrar la vista y volver a la anterior
    */
    @IBAction func backView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Metodo que obtiene los clientes segun el pais que se ingrese
     
     - Parameters:
        - country: Pais a buscar
    */
    func getClientsByCountry(country: String) {
        self.showLoading()
        
        API.getClientsByCountry(clientList, country: country, responseBlock: {
            (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideLoading()
                
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let messageError = res.valueForKey("message") as! String
                        self.showAlert("Lo sentimos!", message: messageError)
                        
                    } else if(error && code != 200 && code != 408) {
                        self.showAlert("Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        self.showAlert("Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                    } else {
                    
                        
                    }
                }
            })
            
        })
    }
            
    
    /**
     Metodo que instancia y configura el selector de clientes (Picker)
    */
    func instanceClientsListPicker() {
        self.clientsListPicker.delegate = self
        
        let toolBarGroups = UIToolbar()
        toolBarGroups.barStyle = UIBarStyle.Default
        toolBarGroups.translucent = true
        toolBarGroups.sizeToFit()
        
        let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        
        // Create buttons
        let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: "doneClientsPicker")
        doneClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                 forState: UIControlState.Normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelClientsPicker")
        cancelClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                   forState: UIControlState.Normal)
        
        toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
        toolBarGroups.userInteractionEnabled = true
        
        self.clientsTextField.inputView = self.clientsListPicker
        self.clientsTextField.inputAccessoryView = toolBarGroups
    }
    
    
    /**
     Metodo que se ejecuta al presionar ok en el selector de clientes. 
     
     Muestra el nombre del cliente seleccionado
     */
    func doneClientsPicker(){
        let items = self.clientList.items.count
        
        if(items > 0){
            let rowPicker = self.clientsListPicker.selectedRowInComponent(0)
            let dataClient = self.clientList.getItem(rowPicker)
            
            self.codeClient = dataClient.code
            
            let nameClient = dataClient.name!
            self.clientsTextField.text = nameClient.capitalizedString
            self.lastClient = nameClient.capitalizedString
        }
        
        self.clientsTextField.resignFirstResponder()
    }
    
    /**
     Metodo que se ejecuta al presionar Cancelar en el selector de clientes. 
     
     Oculta el selector de clientes.
     */
    func cancelClientsPicker(){
        self.clientsTextField.text = self.lastClient
        self.clientsTextField.resignFirstResponder()
    }
    
    /**
     Metodo que se ejecuta al presionar Registrarme.
     
     Envia los datos a la API que despues son enviadas al servidor
    */
    @IBAction func register(sender: UIButton) {
        let codeClient = self.codeClient
        let cveUser = self.cveAfiliadoText.text
        let email = self.emailTextField.text
        let phone = self.phoneTextField.text
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if(codeClient == "" || cveUser == "" || email == "" || phone == "" || username == "" || password == ""){
            self.showAlert("Alerta!", message: "Debe completar todos los campos por favor.")
        } else {
            self.showLoading()
            
            API.register(codeClient, cveUser: cveUser!, phone: phone!, email: email!, password: password!, username: username!, responseBlock: {
                (response) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.hideLoading()
                    
                    if let res = response {
                        let error = res.valueForKey("error") as! Bool
                        let code = res.valueForKey("code") as! Int
                        
                        if(error && code == 200){
                            let messageError = res.valueForKey("message") as! String
                            self.showAlert("Lo sentimos!", message: messageError)
                            
                        } else if(error && code != 200 && code != 408) {
                            self.showAlert("Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                        } else if(error && code == 408) {
                            self.showAlert("Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                        } else {
                            let messageResponse = res.valueForKey("message") as! String
                            self.showAlertSuccess("Muy Bien!", message: messageResponse)
                        }
                    }
                })
                
            })
        }
    }
    
    /**
     Metodo que permite mostrar una alerta en general.
     
     - Parameters:
        - title: String
        - message: String
     */
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Metodo que muestra una alerta de exito y devuelve al usuario a la vista de login
     */
    func showAlertSuccess(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Metodo que muestra la ventana de cargando.
     */
    func showLoading() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Cargando"
    }
    
    /**
     Metodo que oculta la ventana de cargando.
     */
    func hideLoading() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    
    /**
     Oculta el teclado cuando se hace tap en el scrollview
     */
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.scrollView.endEditing(true)
    }
    
    
    // MARK: PickerView Delegate
    /**
     Define cuantos elementos estaran en el selector
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let items = self.clientList.items
        return items.count
    }
    
    /**
     Aplica atributos visuales a cada celda del selector ademas de mostrar el titulo.
     */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let dataClient = self.clientList.getItem(row)
        let titleData = dataClient.name.capitalizedString
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        
        return myTitle
        
    }
    
    /**
     Metodo que se ejecuta al seleccionar una opcion de la lista.
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let items = self.clientList.items.count
        
        if(items > 0){
            let dataClient = self.clientList.getItem(row)
            self.codeClient = dataClient.code
            
            let nameClient = dataClient.name
            self.clientsTextField.text = nameClient.capitalizedString
        }
        
    }
}

//
//  ProgrammingViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProgrammingViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    // MARK: IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // MARK: Variables Generales
    /// Variable que instancia AssistanceItem
    var item: AssistanceItem!
    
    /// Variable con instancia de UIPickerView (Para poder mostrar una lista)
    var datePicker = UIDatePicker()
    //var initialHourPicker = UIDatePicker()
    //var finalHourPicker = UIDatePicker()
    
    /// Variable tipo String que almacena el cve del usuario
    var cveUserVc:String?
    /// Variable tipo String que almacena el clientId
    var clientIdVc:String?
    /// Variable tipo String que almacena el planId
    var planIdVc:String?
    /// Variable tipo String que almacena el assistId
    var assistIdVc:String?
    // Variable que define si es una emergencia o no
    var esemergenciaVc:Bool?
    /// Variable tipo Double que almacena la latitud
    var latVc:Double?
    /// Variable tipo Double que almacena la longitud
    var lngVc:Double?
    
    /// Variable tipo String que almacena la fecha
    var dateMatch:String = ""
    
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Metodos
    /**
     Metodo que se ejecuta una sola vez cuando carga la vista.
     
     - Modifica el color de fondo de la cabecera y el color del texto
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
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 16)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()],
            forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = self.backButton

        self.instanceDatePicker()
        //self.instanceInitialHourPicker()
        //self.instanceFinalHourPicker()
        
        let theTap = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
        self.scrollView.addGestureRecognizer(theTap)
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
     Metodo que valida que los parametros no esten vacios antes de enviar a SOAANG
     */
    @IBAction func sendAssist(sender: UIButton) {
        let date = self.dateMatch
        let phone = self.phoneTextField.text
        let address = self.addressTextField.text
        let description = self.descriptionText.text
        let country:String = self.prefs.objectForKey("country") as! String
        
        if(date == "" || phone == "" || address == "" || description == ""){
            print("\(date) | \(phone) | \(address) | \(description)")
            self.showAlert("Alerta!", message: "Debes completar todos los campos por favor.")
        } else {
            self.sendAssistToSOANNG(cveUserVc!, clientId: clientIdVc!, planId: planIdVc!, assistId: assistIdVc!, lat: 0.0, lng: 0.0, esemergencia: false, date: date, phone: phone!, address: address!, description: description, country: country)
        }
    }
    
    /**
     Envia la informacion al SOANNG
     
     - Parameters:
        - cveUser: String
        - clientId: String
        - planId: String
        - assistId: Bool
        - lat: Double
        - lng: Double
        - esemergencia: Bool
        - date: String
        - phone: String
        - address: String
        - description: String
        - country: String
     */
    func sendAssistToSOANNG(cveUser:String, clientId:String, planId:String, assistId:String, lat:Double, lng:Double, esemergencia:Bool, date:String, phone:String, address:String, description:String, country:String){
        self.showLoading()
        
        API.sendSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: lat, lng: lng, esemergencia: esemergencia, date: date, phone: phone, address: address, reference: "", description: description, country: country, responseBlock: { (response) -> Void in
            
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
                        
                        self.showAlert("Muy Bien!", message: "Hemos recibido tu solicitud")
                        
                        self.dateTextField.text = nil
                        self.phoneTextField.text = nil
                        self.addressTextField.text = nil
                        self.descriptionText.text = nil
                        
                    }
                }
            })
            
        })
    }
    
    /**
     Metodo que instancia y configura el selector de fecha (Picker)
     */
    func instanceDatePicker() {
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        
        //let currentDate: NSDate = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar
        
        let currentDate: NSDate = NSDate()
        self.datePicker.minimumDate = currentDate
        self.datePicker.addTarget(self, action: "changeDate", forControlEvents: UIControlEvents.ValueChanged)
        
        let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        // Create toolbar
        let toolBarDate = UIToolbar()
        toolBarDate.barStyle = UIBarStyle.Default
        toolBarDate.translucent = true
        toolBarDate.sizeToFit()
        
        // Create buttons
        let doneDateButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: "doneDatePicker")
        doneDateButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        let cancelDateButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelDatePicker")
        cancelDateButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        
        // Assign buttons to toolbar
        toolBarDate.setItems([cancelDateButton, spaceButton, doneDateButton], animated: true)
        toolBarDate.userInteractionEnabled = true
        
        self.dateTextField.inputView = datePicker
        self.dateTextField.inputAccessoryView = toolBarDate
    }
    
    /*
    // MARK: Instancia Picker de horas inicial
    func instanceInitialHourPicker() {
        let colorFontToolbar = UIColor(red: 56.0/255.0, green: 225.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        self.initialHourPicker.datePickerMode = UIDatePickerMode.Time
        self.initialHourPicker.addTarget(self, action: "changeInitialHour", forControlEvents: UIControlEvents.ValueChanged)
        
        // Create toolbar
        let toolBarHour = UIToolbar()
        toolBarHour.barStyle = UIBarStyle.Default
        toolBarHour.translucent = true
        toolBarHour.sizeToFit()
        
        // Create buttons
        let doneHourButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: "doneInitialHourPicker")
        doneHourButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        let cancelHourButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelInitialHourPicker")
        cancelHourButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        
        // Assign buttons to toolbar
        toolBarHour.setItems([cancelHourButton, spaceButton, doneHourButton], animated: true)
        toolBarHour.userInteractionEnabled = true
        
        self.initialHourTextField.inputView = initialHourPicker
        self.initialHourTextField.inputAccessoryView = toolBarHour
    }
    */
    
    /*
    // MARK: Instancia Picker de horas final
    func instanceFinalHourPicker() {
        let colorFontToolbar = UIColor(red: 56.0/255.0, green: 225.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        self.finalHourPicker.datePickerMode = UIDatePickerMode.Time
        self.finalHourPicker.addTarget(self, action: "changeFinalHour", forControlEvents: UIControlEvents.ValueChanged)
        
        // Create toolbar
        let toolBarHour = UIToolbar()
        toolBarHour.barStyle = UIBarStyle.Default
        toolBarHour.translucent = true
        toolBarHour.sizeToFit()
        
        // Create buttons
        let doneHourButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: "doneFinalHourPicker")
        doneHourButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        let cancelHourButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelFinalHourPicker")
        cancelHourButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Poppins-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
            forState: UIControlState.Normal)
        
        
        // Assign buttons to toolbar
        toolBarHour.setItems([cancelHourButton, spaceButton, doneHourButton], animated: true)
        toolBarHour.userInteractionEnabled = true
        
        self.finalHourTextField.inputView = finalHourPicker
        self.finalHourTextField.inputAccessoryView = toolBarHour
    }
    */
    
    /**
     Metodo que se ejecuta al seleccionar una fecha con el scroll.
     
     Muestra la fecha seleccionada
     */
    func changeDate(){
        let dateString = datePicker.date.formattedDate
        self.dateMatch = dateString
        self.dateTextField.text = convertDateFormater(dateString).capitalizedString
    }
    
    /**
     Metodo que se ejecuta al presionar ok en el selector de fecha.
     
     Muestra la fecha seleccionada
     */
    func doneDatePicker(){
        let dateString = datePicker.date.formattedDate
        self.dateMatch = dateString
        self.dateTextField.text = convertDateFormater(dateString).capitalizedString
        self.dateTextField.resignFirstResponder()
    }
    
    /**
     Metodo que se ejecuta al presionar Cancelar en el selector de fecha.
     
     Oculta el selector de fecha.
     */
    func cancelDatePicker() {
        self.dateTextField.resignFirstResponder()
    }
    
    
    /*
    // MARK: Metodos picker seleccion de hora inicial
    func changeInitialHour() {
        self.initialHourTextField.text = initialHourPicker.date.formattedHour
    }
    
    func doneInitialHourPicker() {
        // Al presionar ok
        // guarda en memoria la ultima hora registrada antes de cambiarla
        self.initialHourTextField.text = initialHourPicker.date.formattedHour
        self.initialHourTextField.resignFirstResponder()
    }
    
    func cancelInitialHourPicker() {
        self.initialHourTextField.resignFirstResponder()
    }
    
    
    // MARK: Metodos picker seleccion de hora final
    func changeFinalHour() {
        self.finalHourTextField.text = finalHourPicker.date.formattedHour
    }
    
    func doneFinalHourPicker() {
        // Al presionar ok
        // guarda en memoria la ultima hora registrada antes de cambiarla
        self.finalHourTextField.text = finalHourPicker.date.formattedHour
        self.finalHourTextField.resignFirstResponder()
    }
    
    func cancelFinalHourPicker() {
        self.finalHourTextField.resignFirstResponder()
    }
    */
    
    /**
     Metodo que convierte el formato de la fecha que viene del selector a un lenguaje entendible.
     
     Muestra la fecha seleccionada
     */
    func convertDateFormater(date: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
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
     Metodo que muestra la ventana de cargando.
     */
    func showLoading() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Cargando"
        loadingNotification.yOffset = -20.0
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
}

extension NSDate {
    var formattedDate: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "Y-MM-dd"
        return formatter.stringFromDate(self)
    }
    
    var formattedHour: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(self)
    }
}


//
//  PollNotificationViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 14-11-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

class PollNotificationViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textQuestion1: UITextField!
    @IBOutlet weak var textQuestion2: UITextField!
    @IBOutlet weak var textQuestion3: UITextField!
    
    var assistId:Int!
    
    /// Variable que almacena la informacion guardada en memoria
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /// Variable con instancia de UIPickerView (Para poder mostrar una lista)
    var optionsListPicker = UIPickerView()
    var optionsListPicker2 = UIPickerView()
    var optionsListPicker3 = UIPickerView()
    
    let optionsPicker = [["option": "Seleccione", "value": ""], ["option": "Malo", "value": "1"], ["option": "Regular", "value": "2"], ["option": "Bueno", "value": "3"], ["option": "Muy bueno", "value": "4"], ["option": "Excelente", "value": "5"]]
    
    let optionsPicker2 = [["option": "Seleccione", "value": ""], ["option": "Si", "value": "1"], ["option": "No", "value": "2"]]
    
    /// Variable tipo String que almacena el ultimo cliente que se selecciona en el listado de opciones
    var lastOption1: String = ""
    /// Variable tipo String que almacena el ultimo cliente que se selecciona en el listado de opciones
    var lastOption2: String = ""
    /// Variable tipo String que almacena el ultimo cliente que se selecciona en el listado de opciones
    var lastOption3: String = ""
    
    /// Variable tipo Int que almacena el value de la lista de opciones
    var valueOption1: String = ""
    /// Variable tipo Int que almacena el value de la lista de opciones
    var valueOption2: String = ""
    /// Variable tipo Int que almacena el value de la lista de opciones
    var valueOption3: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.scrollViewTapped(_:)))
        self.scrollView.addGestureRecognizer(theTap)

        self.textQuestion1.tag = 1
        self.textQuestion2.tag = 2
        self.textQuestion3.tag = 3
        
        self.instanceOptionsListPicker1()
        self.instanceOptionsListPicker2()
        self.instanceOptionsListPicker3()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /**
     Metodo que instancia y configura el selector de clientes (Picker)
     */
    func instanceOptionsListPicker1() {
        self.optionsListPicker.delegate = self
        self.optionsListPicker.tag = 1
        
        let toolBarGroups = UIToolbar()
        toolBarGroups.barStyle = UIBarStyle.Default
        toolBarGroups.translucent = true
        toolBarGroups.sizeToFit()
        
        let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        
        // Create buttons
        let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.doneOptionsPicker(_:)))
        doneClientsButton.tag = 1
        doneClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                 forState: UIControlState.Normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.cancelOptionsPicker(_:)))
        cancelClientsButton.tag = 1
        cancelClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                   forState: UIControlState.Normal)
        
        toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
        toolBarGroups.userInteractionEnabled = true
        
        self.textQuestion1.inputView = self.optionsListPicker
        self.textQuestion1.inputAccessoryView = toolBarGroups
    }
    
    /**
     Metodo que instancia y configura el selector de clientes (Picker)
     */
    func instanceOptionsListPicker2() {
        self.optionsListPicker2.delegate = self
        self.optionsListPicker2.tag = 2
        
        let toolBarGroups = UIToolbar()
        toolBarGroups.barStyle = UIBarStyle.Default
        toolBarGroups.translucent = true
        toolBarGroups.sizeToFit()
        
        let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        
        // Create buttons
        let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.doneOptionsPicker(_:)))
        doneClientsButton.tag = 2
        doneClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                 forState: UIControlState.Normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.cancelOptionsPicker(_:)))
        cancelClientsButton.tag = 2
        cancelClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                   forState: UIControlState.Normal)
        
        toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
        toolBarGroups.userInteractionEnabled = true
        
        self.textQuestion2.inputView = self.optionsListPicker2
        self.textQuestion2.inputAccessoryView = toolBarGroups
    }
    
    /**
     Metodo que instancia y configura el selector de clientes (Picker)
     */
    func instanceOptionsListPicker3() {
        self.optionsListPicker3.delegate = self
        self.optionsListPicker3.tag = 3
        
        let toolBarGroups = UIToolbar()
        toolBarGroups.barStyle = UIBarStyle.Default
        toolBarGroups.translucent = true
        toolBarGroups.sizeToFit()
        
        let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        
        // Create buttons
        let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.doneOptionsPicker(_:)))
        doneClientsButton.tag = 3
        doneClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                 forState: UIControlState.Normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PollViewController.cancelOptionsPicker(_:)))
        cancelClientsButton.tag = 3
        cancelClientsButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 16)!,
            NSForegroundColorAttributeName : colorFontToolbar],
                                                   forState: UIControlState.Normal)
        
        toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
        toolBarGroups.userInteractionEnabled = true
        
        self.textQuestion3.inputView = self.optionsListPicker3
        self.textQuestion3.inputAccessoryView = toolBarGroups
    }
    
    /**
     Metodo que se ejecuta al presionar ok en el selector de opciones de cobertura.
     
     Muestra el nombre del cliente seleccionado
     */
    func doneOptionsPicker(sender: UIBarButtonItem){
        let tagId = sender.tag
        let inputPickerInfo = self.view.viewWithTag(tagId) as? UITextField
        
        let valueInput = inputPickerInfo?.text
        
        if (valueInput == "Seleccione" || valueInput == "") {
            inputPickerInfo?.text = nil
        } else {
            if(tagId == 1){
                let rowPicker = self.optionsListPicker.selectedRowInComponent(0)
                let dataOptions = self.optionsPicker[rowPicker]
                
                self.valueOption1 = dataOptions["value"]!
                
                let option = dataOptions["option"]!
                self.textQuestion1.text = option.capitalizedString
                self.lastOption1 = option.capitalizedString
                
            } else if(tagId == 2){
                let rowPicker = self.optionsListPicker2.selectedRowInComponent(0)
                let dataOptions = self.optionsPicker[rowPicker]
                
                self.valueOption2 = dataOptions["value"]!
                
                let option = dataOptions["option"]!
                self.textQuestion2.text = option.capitalizedString
                self.lastOption2 = option.capitalizedString
                
            } else if(tagId == 3){
                let rowPicker = self.optionsListPicker3.selectedRowInComponent(0)
                let dataOptions = self.optionsPicker2[rowPicker]
                
                self.valueOption3 = dataOptions["value"]!
                
                let option = dataOptions["option"]!
                self.textQuestion3.text = option.capitalizedString
                self.lastOption3 = option.capitalizedString
            }
        }
        
        if(tagId == 1){
            self.textQuestion1.resignFirstResponder()
        } else if(tagId == 2){
            self.textQuestion2.resignFirstResponder()
        } else if(tagId == 3){
            self.textQuestion3.resignFirstResponder()
        }
        
    }
    
    /**
     Metodo que se ejecuta al presionar Cancelar en el selector de opciones de cobertura.
     
     Oculta el selector de clientes.
     */
    func cancelOptionsPicker(sender: UIBarButtonItem){
        let tagId = sender.tag
        
        if(tagId == 1){
            self.textQuestion1.text = self.lastOption1
            self.textQuestion1.resignFirstResponder()
            
        } else if(tagId == 2){
            self.textQuestion2.text = self.lastOption2
            self.textQuestion2.resignFirstResponder()
            
        } else if(tagId == 3){
            self.textQuestion3.text = self.lastOption3
            self.textQuestion3.resignFirstResponder()
        }
    }
    
    
    // MARK: PickerView Delegate
    /**
     Define cuantos elementos estaran en el selector
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerTag = pickerView.tag
        
        var countPicker = 0
        
        if(pickerTag == 1 || pickerTag == 2){
            let items = self.optionsPicker
            countPicker = items.count
        } else if (pickerTag == 3){
            let items = self.optionsPicker2
            countPicker = items.count
        } else {
            countPicker = 0
        }
        
        return countPicker
    }
    
    /**
     Aplica atributos visuales a cada celda del selector ademas de mostrar el titulo.
     */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerTag = pickerView.tag
        
        var dataOptions:[String:String] = [:]
        
        if(pickerTag == 1 || pickerTag == 2){
            dataOptions = self.optionsPicker[row]
            
        } else if (pickerTag == 3){
            dataOptions = self.optionsPicker2[row]
        }
        
        let titleData = dataOptions["option"]
        
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        
        return myTitle
        
    }
    
    /**
     Metodo que se ejecuta al seleccionar una opcion de la lista.
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerTag = pickerView.tag
        
        var dataOptions:[String:String] = [:]
        
        if(pickerTag == 1){
            dataOptions = self.optionsPicker[row]
            
            let option = dataOptions["option"]
            self.textQuestion1.text = option!.capitalizedString
            
        } else if(pickerTag == 2){
            dataOptions = self.optionsPicker[row]
            
            let option = dataOptions["option"]
            self.textQuestion2.text = option!.capitalizedString
            
        } else if (pickerTag == 3){
            dataOptions = self.optionsPicker2[row]
            
            let option = dataOptions["option"]
            self.textQuestion3.text = option!.capitalizedString
        }
    }
    

    @IBAction func sendPoll(sender: UIButton) {
        let question1 = self.textQuestion1.text
        let question2 = self.textQuestion2.text
        let question3 = self.textQuestion3.text
        
        if(question1 == "" || question2 == "" || question3 == ""){
            Alerts.showSimpleAlert(self, title: "Alerta", message: "Debes completar todos los campos")
        } else {
            Loading.showLoading(self.view, offset: nil, title: "Enviando")
            
            let assistId = self.assistId
            let country:String = self.prefs.objectForKey("country") as! String
            
            print("Valor 1: \(self.valueOption1)")
            print("Valor 2: \(self.valueOption2)")
            print("Valor 3: \(self.valueOption3)")
            
            
            API.sendPoll(assistId, rp1: self.valueOption1, rp2: self.valueOption2, rp3: self.valueOption3, country: country, responseBlock: { (response) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
                            let messageSuccess = res.valueForKey("message") as! String
                            Alerts.showNavigationAlert(self, title: "Muy Bien!", message: messageSuccess)
                        }
                        
                        Loading.hideLoading(self.view)
                    }
                })
                
            })
        }
    }
    
    /// Hide Keyboard when tap in scrollview
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.scrollView.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

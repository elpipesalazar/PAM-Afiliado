//
//  FormViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 03-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class FormViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // Variable que almacena los objetos con las preguntas
    var listQuestions: [QuestionItem] = []
    
    //var sendDataArray:[Dictionary<String,String>] = []
    var sendDataArray = [[String: String]]()
    
    var lastRow:Int? = nil
    
    var lastExitSelect:String = "false"
    
    var planId:String!
    var assistId:String!
    var lat:Double!
    var lng:Double!
    var esemergencia:Bool!
    var phone:String!
    var address:String!
    var reference:String!
    
    //var inputsIds:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initForm()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    let widthView:CGFloat = UIScreen.mainScreen().bounds.width
    var topItems:CGFloat = 20
    
    func initForm() {
        for info in self.listQuestions {
            //print(info)
            
            let isParent = info.parentQuestion
            
            if(isParent == "true"){
                let typeElement = info.type
                let idElement = info.id
                let labelElement = info.label
                
                let labelTitle = UILabel(frame: CGRectMake(15, topItems, (widthView - 30), 30))
                labelTitle.text = labelElement
                labelTitle.tag = Int("99999\(idElement!)")!
                labelTitle.font = UIFont(name: "Poppins-Regular", size: 15.0)
                labelTitle.textColor = UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
                
                self.scrollView.addSubview(labelTitle)
                
                let topDistanceLabel = labelTitle.frame.origin.y
                
                if typeElement == "lista" {
                    let inputTextField = UITextField(frame: CGRectMake(15, (topDistanceLabel + 30), (widthView - 30), 40))
                    inputTextField.backgroundColor = UIColor.whiteColor()
                    inputTextField.placeholder = info.placeholder
                    inputTextField.tag = idElement!
                    inputTextField.font = UIFont(name: "Poppins-Medium", size: 18.0)
                    
                    self.scrollView.addSubview(inputTextField)
                    
                    let optionsListPicker = UIPickerView()
                    
                    optionsListPicker.delegate = self
                    optionsListPicker.tag = idElement!
                    
                    let toolBarGroups = UIToolbar()
                    toolBarGroups.barStyle = UIBarStyle.Default
                    toolBarGroups.translucent = true
                    toolBarGroups.sizeToFit()
                    
                    let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
                    
                    // Create buttons
                    let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doneClientsPicker(_:)))
                    doneClientsButton.tag = idElement!
                    doneClientsButton.setTitleTextAttributes([
                        NSFontAttributeName : UIFont(name: "Poppins-Regular", size: 14)!,
                        NSForegroundColorAttributeName : colorFontToolbar],
                                                             forState: UIControlState.Normal)
                    
                    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                    
                    let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancelClientsPicker(_:)))
                    cancelClientsButton.tag = idElement!
                    cancelClientsButton.setTitleTextAttributes([
                        NSFontAttributeName : UIFont(name: "Poppins-Regular", size: 14)!,
                        NSForegroundColorAttributeName : colorFontToolbar],
                                                               forState: UIControlState.Normal)
                    
                    toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
                    toolBarGroups.userInteractionEnabled = true
                    
                    inputTextField.inputView = optionsListPicker
                    inputTextField.inputAccessoryView = toolBarGroups
                    
                    topItems = topItems + 85
                    
                } else if typeElement == "input" {
                    let inputTextField = UITextField(frame: CGRectMake(15, (topDistanceLabel + 30), (widthView - 30), 40))
                    inputTextField.backgroundColor = UIColor.whiteColor()
                    inputTextField.placeholder = info.placeholder
                    inputTextField.tag = idElement!
                    inputTextField.font = UIFont(name: "Poppins-Medium", size: 18.0)
                    
                    self.scrollView.addSubview(inputTextField)
                    
                    topItems = topItems + 85
                    
                } else if typeElement == "text" {
                    let inputTextView = UITextView(frame: CGRectMake(15, (topDistanceLabel + 30), (widthView - 30), 120))
                    inputTextView.layer.borderColor = UIColor.grayColor().CGColor
                    inputTextView.layer.borderWidth = 1.0;
                    inputTextView.tag = idElement!
                    inputTextView.font = UIFont(name: "Poppins-Medium", size: 16.0)
                    
                    self.scrollView.addSubview(inputTextView)
                    
                    //topItems = topItems + 85
                    topItems = topItems + 170
                }
                
            }
            
        }
        
        let button = UIButton(frame: CGRect(x: 15, y: (topItems + 20), width: (widthView - 30), height: 50))
        button.backgroundColor = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        button.setTitle("Solicitar", forState: .Normal)
        button.tag = 99999
        button.enabled = true
        //button.alpha = 0.5
        button.alpha = 1.0
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(button)
        
        self.scrollView.frame = self.view.bounds; // Instead of using auto layout
        self.scrollView.contentSize.height = (topItems + 90); // Or whatever you want it to be.*/
    }
    
    
    func showForm(questionId: Int){
        let arrayRow = self.listQuestions.indexOf({$0.id == questionId})
        let infoPicker = self.listQuestions[arrayRow!]
        
        let optionsPicker = infoPicker.options![self.lastRow!]
        //let valueOptionPicker = optionsPicker.valueOption
        let isNewQuestionPicker = optionsPicker.isNewQuestion
        let childQuestionId = optionsPicker.childQuestion
        
        if (isNewQuestionPicker == "true") {
            let arraySubQuestionRow = self.listQuestions.indexOf({$0.id == childQuestionId})
            
            //print("child question id: \(childQuestionId)")
            //print("ArraySubQuestion: \(arraySubQuestionRow)")
            
            let infoSubQuestionPicker = self.listQuestions[arraySubQuestionRow!]
            
            let typeElement = infoSubQuestionPicker.type
            let idElement = infoSubQuestionPicker.id
            let labelElement = infoSubQuestionPicker.label
            
            
            var checkInput = false
            
            if (typeElement == "input" || typeElement == "lista") {
                if let _ = self.view.viewWithTag(idElement) as? UITextField {
                    checkInput = true
                } else {
                    checkInput = false
                }
                
                
            } else if (typeElement == "text") {
                if let _ = self.view.viewWithTag(idElement) as? UITextView {
                    checkInput = true
                } else {
                    checkInput = false
                }
            }

            
            if (checkInput == false){
                let labelTitle = UILabel(frame: CGRectMake(15, topItems, (widthView - 30), 30))
                labelTitle.text = labelElement
                labelTitle.tag = Int("99999\(idElement!)")!
                labelTitle.font = UIFont(name: "Poppins-Regular", size: 15.0)
                labelTitle.textColor = UIColor(red: 104.0/255.0, green: 104.0/255.0, blue: 104.0/255.0, alpha: 1.0)
                
                self.scrollView.addSubview(labelTitle)
                
                let topDistanceLabel = labelTitle.frame.origin.y
                
                if typeElement == "lista" {
                    let inputTextField = UITextField(frame: CGRectMake(15, (topDistanceLabel + 30), (widthView - 30), 40))
                    inputTextField.placeholder = infoSubQuestionPicker.placeholder
                    inputTextField.tag = idElement!
                    inputTextField.font = UIFont(name: "Poppins-Medium", size: 18.0)
                    
                    self.scrollView.addSubview(inputTextField)
                    
                    let optionsListPicker = UIPickerView()
                    
                    optionsListPicker.delegate = self
                    optionsListPicker.tag = idElement!
                    
                    let toolBarGroups = UIToolbar()
                    toolBarGroups.barStyle = UIBarStyle.Default
                    toolBarGroups.translucent = true
                    toolBarGroups.sizeToFit()
                    
                    let colorFontToolbar = UIColor(red: 27.0/255.0, green: 120.0/255.0, blue: 177.0/255.0, alpha: 1.0)
                    
                    // Create buttons
                    let doneClientsButton = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doneClientsPicker(_:)))
                    doneClientsButton.tag = idElement!
                    doneClientsButton.setTitleTextAttributes([
                        NSFontAttributeName : UIFont(name: "Poppins-Regular", size: 14)!,
                        NSForegroundColorAttributeName : colorFontToolbar],
                                                             forState: UIControlState.Normal)
                    
                    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                    
                    let cancelClientsButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancelClientsPicker(_:)))
                    cancelClientsButton.tag = idElement!
                    cancelClientsButton.setTitleTextAttributes([
                        NSFontAttributeName : UIFont(name: "Poppins-Regular", size: 14)!,
                        NSForegroundColorAttributeName : colorFontToolbar],
                                                               forState: UIControlState.Normal)
                    
                    toolBarGroups.setItems([cancelClientsButton, spaceButton, doneClientsButton], animated: true)
                    toolBarGroups.userInteractionEnabled = true
                    
                    inputTextField.inputView = optionsListPicker
                    inputTextField.inputAccessoryView = toolBarGroups
                    
                    topItems = topItems + 85
                    
                }
                
                let buttonRequest = self.view.viewWithTag(99999) as? UIButton
                buttonRequest!.frame = CGRect(x: 15, y: (topItems + 20), width: (widthView - 30), height: 50)
                buttonRequest?.enabled = false
                buttonRequest?.alpha = 0.5
                
                self.scrollView.contentSize.height = (topItems + 90);
            }
        } else {
            let buttonRequest = self.view.viewWithTag(99999) as? UIButton
            buttonRequest?.enabled = true
            buttonRequest?.alpha = 1.0
        }
        
    }
    
    
    func buttonAction(sender: UIButton!) {
        self.sendDataArray.removeAll()
    
        for info in self.listQuestions {
            let typeElement = info.type as String
            let tagId = info.id as Int
            
            var textInput = ""
         
            if (typeElement == "lista") {
                if let inputInfo = self.view.viewWithTag(tagId) as? UITextField {
                    textInput = inputInfo.text!
                    
                    let rowOption = info.options!.indexOf({$0.option == textInput})
                    
                    self.addResponses(tagId, rowOption: rowOption, questionResponse: textInput, typeInput: "lista")
                }
                
            } else if (typeElement == "input"){
                if let inputInfo = self.view.viewWithTag(tagId) as? UITextField {
                    textInput = inputInfo.text!
                    
                    self.addResponses(tagId, rowOption: nil, questionResponse: textInput, typeInput: "input")
                }
                
            } else if (typeElement == "text") {
                if let inputInfo = self.view.viewWithTag(tagId) as? UITextView {
                    textInput = inputInfo.text!
                    
                    self.addResponses(tagId, rowOption: nil, questionResponse: textInput, typeInput: "text")
                }
            }
        }
    
        let cveUser:String = self.prefs.objectForKey("cveafiliado") as! String
        let clientId:String = self.prefs.objectForKey("idcuenta") as! String
        let country:String = self.prefs.objectForKey("country") as! String
    
        //print("respuestas: \(self.sendDataArray)")
    
        self.sendResponsesToSOANNG(cveUser, clientId: clientId, planId: self.planId, assistId: self.assistId, lat: self.lat, lng: self.lng, esemergencia: self.esemergencia, country: country, phone: self.phone, address: self.address, reference: self.reference, responses: self.sendDataArray)
    }
    
    
    func addResponses(questionId:Int, rowOption:Int?, questionResponse:String, typeInput:String){
        if(typeInput == "lista"){
            let arrayPickerRow = self.listQuestions.indexOf({$0.id == questionId})
            let infoPicker = self.listQuestions[arrayPickerRow!]
            
            if questionResponse == "" {
                Alerts.showSimpleAlert(self, title: "Alerta", message: "Debes completar todos los campos")
            } else {
                let optionsPicker = infoPicker.options![rowOption!]
                let valueOptionPicker = optionsPicker.valueOption
                
                let arrayRow = self.sendDataArray.indexOf({$0["id"] == "\(questionId)"})
                
                if arrayRow != nil {
                    self.sendDataArray[arrayRow!]["respuesta"]! = "\(questionResponse)"
                    self.sendDataArray[arrayRow!]["valor"]! = "\(valueOptionPicker.uppercaseString)"
                    
                } else {
                    let objectInfo: [String: String] = ["id": "\(questionId)", "respuesta": questionResponse, "valor": valueOptionPicker.uppercaseString]
                    
                    self.sendDataArray.append(objectInfo)
                }
            }
        } else if(typeInput == "input" || typeInput == "text"){
            if questionResponse == "" {
                Alerts.showSimpleAlert(self, title: "Alerta", message: "Debes completar todos los campos")
            } else {
                let objectInfo: [String: String] = ["id": "\(questionId)", "respuesta": questionResponse, "valor": questionResponse]
                
                self.sendDataArray.append(objectInfo)
            }
        }
        
        
    }
    
    
    /**
     Metodo que se ejecuta al presionar ok en el selector de clientes.
     
     Muestra el nombre del cliente seleccionado
     */
    func doneClientsPicker(sender: UIBarButtonItem){
        let tagId = sender.tag
        let inputPickerInfo = self.view.viewWithTag(tagId) as? UITextField
        
        let valueInput = inputPickerInfo?.text
        
        if (valueInput == "Seleccione" || valueInput == "") {
            inputPickerInfo?.text = nil
        } else {
            
            let arrayRow = self.listQuestions.indexOf({$0.id == tagId})
            let infoQuestion = self.listQuestions[arrayRow!]
            
            // Valida y elimina las preguntas que esten despues de este elemento
            let childrensArray = infoQuestion.childrens as! NSArray
            
            if childrensArray.count > 0 {
                for childId in childrensArray {
                    if(childId as! String != ""){
                        if let labelInfo = self.view.viewWithTag(Int("99999\(childId)")!) as? UILabel {
                            labelInfo.removeFromSuperview()
                            topItems = topItems - 40
                        }
                        
                        if let inputInfo = self.view.viewWithTag(Int("\(childId as! String)")!) as? UITextField {
                            inputInfo.removeFromSuperview()
                            topItems = topItems - 45
                        }
                    }
                }
                
                
                let buttonRequest = self.view.viewWithTag(99999) as? UIButton
                buttonRequest!.frame = CGRect(x: 15, y: (topItems + 20), width: (widthView - 30), height: 50)
                
                self.scrollView.contentSize.height = (topItems + 90);
            }
            
            self.showForm(tagId)
        }
        
        inputPickerInfo?.resignFirstResponder()
    }
    
    /**
     Metodo que se ejecuta al presionar Cancelar en el selector.
     
     Oculta el selector.
     */
    func cancelClientsPicker(sender: UIBarButtonItem){
        let tagId = sender.tag
        
        let inputPickerInfo = self.view.viewWithTag(tagId) as? UITextField
        inputPickerInfo?.resignFirstResponder()
    }
    
    
    func sendResponsesToSOANNG(cveUser:String, clientId:String, planId:String, assistId:String, lat:Double, lng:Double, esemergencia:Bool, country:String, phone:String, address:String, reference:String, responses:[[String: String]]){
        
        Loading.showLoading(self.view, offset: nil, title: "Enviando Solicitud")
        
        API.sendResponsesToSOANNG(cveUser, clientId: clientId, planId: planId, assistId: assistId, lat: lat, lng: lng, esemergencia: esemergencia, date: "", phone: phone, address: address, reference: reference, description: "", country: country, responses: responses, responseBlock: { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let json = JSON(res)
                        
                        let phone = json["result"]["numero_cuenta"]
                        let messageError = res.valueForKey("message") as! String
                        
                        Alerts.showCallAlert(self, title: "Lo sentimos!", message: messageError, phone: "\(phone)", closeView: false)
                        
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
        let pickerId = pickerView.tag
        
        let arrayRow = self.listQuestions.indexOf({$0.id == pickerId})
        let infoPicker = self.listQuestions[arrayRow!]
            
        let countOptions = infoPicker.options?.count
        
        return countOptions!
    }
    
    /**
     Aplica atributos visuales a cada celda del selector ademas de mostrar el titulo.
     */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerId = pickerView.tag
        let arrayRow = self.listQuestions.indexOf({$0.id == pickerId})
        let infoPicker = self.listQuestions[arrayRow!]
        
        let optionsPicker = infoPicker.options![row]
        let nameOptionPicker = optionsPicker.option
        
        let myTitle = NSAttributedString(string: nameOptionPicker, attributes: [NSFontAttributeName:UIFont(name: "Poppins", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        
        return myTitle
    }
    
    /**
     Metodo que se ejecuta al seleccionar una opcion de la lista.
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerId = pickerView.tag
        let arrayRow = self.listQuestions.indexOf({$0.id == pickerId})
        let infoPicker = self.listQuestions[arrayRow!]
        
        let optionsPicker = infoPicker.options![row]
        let nameOptionPicker = optionsPicker.option
        let existOptionPicker = optionsPicker.exitQuestion
        
        self.lastExitSelect = existOptionPicker
        
        let inputPickerInfo = self.view.viewWithTag(pickerId) as? UITextField
        inputPickerInfo!.text = nameOptionPicker
        
        self.lastRow = row
    }
    
}

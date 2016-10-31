//
//  ViewControllerCalculator.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 26/09/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import UIKit
import Foundation

class ViewControllerCalculator: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textNumberChangeTo: UILabel!
    @IBOutlet weak var textFieldChangeFrom: UITextField!
    @IBOutlet weak var textChangeTo: UILabel!
    @IBOutlet weak var textChangeFrom: UILabel!

    var calcStruct : ExchangeStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldChangeFrom.delegate = self
        setInfo()
        //tap to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //allow custom characters only
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet

        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        
        let filtered = components.joinWithSeparator("")
        
        return string == filtered
    }
    
    
    @IBAction func textFieldEditingDidChange(sender: AnyObject) {
        var result : Float
        
        let textIn = textFieldChangeFrom.text
        var dotCounter = 0
        //check if textfield isn't empty to prevent errors
        if textIn != ""{
            //count dots so we can later prevent errors
            for letter in (textIn?.characters)!{
                if(letter == "."){
                    dotCounter += 1
                }
            }
            //prevent to start text with dot
            if textFieldChangeFrom.text![(textFieldChangeFrom.text?.startIndex)!] == "."{
                clearNumberInfo()
            }
            //prevent to have more dots so the value stays float
            else if dotCounter>1{
                textFieldChangeFrom.text?.removeAtIndex((textIn?.endIndex.predecessor())!)
            }
            //if the value is correct, convert it to another rate and display it
            else{
                let numberFrom : Float = Float(textFieldChangeFrom.text!)!
                result = numberFrom * (calcStruct?.numberTo)!
                result = Float(result).roundTo(2)
                textNumberChangeTo.text = String(result)
                
            }
        }
        //clear textfield change from and text number change to, so it's blank when user delete characters from text field
        else {
            clearNumberInfo()
        }

    }
    //button to switch rates
    @IBAction func buttonSwitch(sender: AnyObject) {
        let textSwitch : String = (calcStruct?.textFrom)!
        let numberSwitch : Float = (calcStruct?.numberFrom)!
        
        calcStruct?.textFrom = (calcStruct?.textTo)!
        calcStruct?.numberFrom = (calcStruct?.numberTo)!
        
        calcStruct?.textTo = textSwitch
        calcStruct?.numberTo = numberSwitch
        setInfo()
        clearNumberInfo()
        
    }
    
    
    func setInfo(){
        textChangeFrom.text = calcStruct?.textFrom
        textChangeTo.text = calcStruct?.textTo
    }
    
    func clearNumberInfo(){
        textFieldChangeFrom.text = ""
        textNumberChangeTo.text = "0"
    }
}


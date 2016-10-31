//
//  ViewController.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 13/09/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBase: UILabel!
    @IBOutlet weak var textFieldChange: UITextField!
    
    var rateObject = RateObject?()
    var arrayRates = [(String, Float)]()
    
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        picker.dataSource = self
        picker.delegate = self
        connect("EUR")
        textFieldChange.inputView = picker
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let rateName = self.arrayRates[indexPath.row].0 + " : " + String(self.arrayRates[indexPath.row].1.roundTo(2))
        
        cell.textLabel?.text = rateName
        
        return cell
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayRates.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textBase.text = "Base: " + self.arrayRates[row].0
        self.textFieldChange.text = self.arrayRates[row].0
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayRates[row].0
    }
    
    //function to parse json
    func connect(rate: String){
        RestApiManager.sharedInstance.setBaseUrl(rate)
        RestApiManager.sharedInstance.getLatestRates{(json: JSON) in
            
            
            
            self.rateObject = RateObject(json: json)
            self.createArray()
            dispatch_async(dispatch_get_main_queue()){
                self.textBase.text = "Base: " + (self.rateObject?.base)!
                self.tableView.reloadData()
                self.textFieldChange.text = (self.rateObject?.base)!
            }
        }
        
    }
    //function to take values from rate object and append them to array
    func createArray(){
        
        self.arrayRates.removeAll()
        
        for (rateKey, rateValue) in (self.rateObject?.rateDictionary)!{
            self.arrayRates.append(rateKey, rateValue.floatValue)
        }
        self.arrayRates.sortInPlace{$0.0 < $1.0}
    }
    
    //create struct and push it to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let destViewCont = segue.destinationViewController as! ViewControllerCalculator
        
        let exchangeStruct = ExchangeStruct(textFrom: self.rateObject!.base, textTo: self.arrayRates[indexPath!.row].0, numberFrom: 1/self.arrayRates[indexPath!.row].1, numberTo: self.arrayRates[indexPath!.row].1)
        
        destViewCont.calcStruct = exchangeStruct
    }
    @IBAction func buttonChangeTapped(sender: AnyObject) {
        connect(textFieldChange.text!)
        viewWillAppear(true)
    }
}
//extension to round numbers
extension Float{
    func roundTo(places: Int) -> Float{
        let divisor = pow(10.0, Float(places))
        return round((self * divisor)) / divisor
    }
}


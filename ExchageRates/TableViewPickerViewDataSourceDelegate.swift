//
//  TableViewPickerViewDataSourceDelegate.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 02/11/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var rateObject = RateObject?()
    private var arrayRates = [(String, Float)]()
    
    private var baseName: String = ""
    
    //TABLE VIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let rateName = self.arrayRates[indexPath.row].0 + " : " + String(self.arrayRates[indexPath.row].1.roundTo(2))
        
        cell.textLabel?.text = rateName
        cell.textLabel?.textColor = UIColor.darkBlue()
        
        return cell
    }
    
    //function to parse json
    func connect(rate: String, tableViewToUpdate : UITableView){
        RestApiManager.sharedInstance.setBaseUrl(rate)
        RestApiManager.sharedInstance.getLatestRates{(json: JSON) in
            
            self.rateObject = RateObject(json: json)
            self.createArray()
            dispatch_async(dispatch_get_main_queue()){
                tableViewToUpdate.reloadData()
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
    
    func setExchangeStruct(indexPath: Int) -> ExchangeStruct{
        let exchangeStruct = ExchangeStruct(textFrom: self.rateObject!.base, textTo: self.arrayRates[indexPath].0, numberFrom: 1/self.arrayRates[indexPath].1, numberTo: self.arrayRates[indexPath].1)
        return exchangeStruct
    }
    
    //PICKER VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayRates.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        baseName = self.arrayRates[row].0
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayRates[row].0
    }
    
    func getBaseName() -> String{
        return baseName
    }
    
}

extension UIColor {
    static func darkBlue() -> UIColor {
        return UIColor.init(colorLiteralRed: 13.0/255, green: 0.0/255, blue: 98.0/255, alpha: 1.0)
    }
}
//
//  ViewController.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 13/09/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import UIKit
import Foundation

class ViewControllerWithTableView: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBase: UILabel!
    @IBOutlet weak var textFieldChange: UITextField!
    private let picker = UIPickerView()
    
    private let tbDataSource = TableViewDataSourceAndDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = tbDataSource
        tableView.dataSource =  tbDataSource
        
        picker.dataSource = tbDataSource
        picker.delegate = tbDataSource
        textFieldChange.inputView = picker
        
        tbDataSource.connect("EUR", tableViewToUpdate: tableView)
        
        
        //tap to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//extension to round numbers
extension Float{
    func roundTo(places: Int) -> Float{
        let divisor = pow(10.0, Float(places))
        return round((self * divisor)) / divisor
    }
}

extension UIViewController{
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewControllerWithTableView{
    //create struct and push it to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        let destViewCont = segue.destinationViewController as! ViewControllerCalculator
        
        let exchangeStruct = tbDataSource.setExchangeStruct(indexPath!.row)
        
        destViewCont.calcStruct = exchangeStruct
    }
    
    @IBAction func buttonChangeTapped(sender: AnyObject) {
        textFieldChange!.text = tbDataSource.getBaseName()
        textBase!.text = "Base: " + tbDataSource.getBaseName()
        
        tbDataSource.connect(textFieldChange.text!, tableViewToUpdate: tableView)
        
        
    }
}



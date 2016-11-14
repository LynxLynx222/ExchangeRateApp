//
//  RateObject.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 15/09/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import Foundation

class RateObject{
    var base: String!
    var date: String!
    var rateDictionary = [String : JSON]()
    //var rateArray = [Float]()
    
    
    required init(json: JSON){
        base = json["base"].stringValue
        date = json["date"].stringValue
        rateDictionary = json["rates"].dictionaryValue
    }
}
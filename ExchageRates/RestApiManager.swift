//
//  RestApiManager.swift
//  ExchageRates
//
//  Created by Ondrej Andrysek on 14/09/2016.
//  Copyright © 2016 Ondrej Andrysek. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager : NSObject{
    static let sharedInstance = RestApiManager()
    
    var baseURL = "http://api.fixer.io/latest?base=EUR"
    
    func getLatestRates(onCompletion: (JSON) -> Void){
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse){
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data{
                let json:JSON = JSON(data: jsonData)
                onCompletion(json,error)
            }
            else {
                onCompletion(nil,error)
            }
        })
        task.resume()
    }
    
    func setBaseUrl(rate: String){
        baseURL = "http://api.fixer.io/latest?base=\(rate)"
    }
    
}
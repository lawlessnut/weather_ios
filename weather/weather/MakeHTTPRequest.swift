//
//  MakeHTTPRequest.swift
//  weather
//
//  Created by Vipul Suthar on 1/2/16.
//  Copyright © 2016 Vipul Suthar. All rights reserved.
//

import Foundation
import UIKit

class MakeHTTPRequest {
    
     func makeRequest (url:NSURL) -> NSDictionary {
        
        var weatherDataDictionary:NSDictionary = NSDictionary()
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data,response,error) -> Void in
            
            if let urlContent = data {
                
                 let webContent = NSString(data:urlContent, encoding: NSUTF8StringEncoding)
                
                 weatherDataDictionary = self.convertStringToDictionary(webContent!)!
                
            } else {
                print(error)
            }
            
        }
        
        task.resume()
        
        print("DATA ==>\(weatherDataDictionary)")
        return weatherDataDictionary
        
    }
    
    func convertStringToDictionary (text:NSString) -> [String:AnyObject]? {
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                
                return json
            } catch {
                print("Something went wrong")
            }
            
        }
        
        return nil
    }

}


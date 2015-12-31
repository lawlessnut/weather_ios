//
//  URLRequest.swift
//  weather
//
//  Created by Vipul Suthar on 12/29/15.
//  Copyright © 2015 Vipul Suthar. All rights reserved.
//

import Foundation


class URLRequest: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    typealias CallbackBlock = (result: String, error: String?) -> ()
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print(resultString)
        } else {
            print(error)
        }
    }
    
    func httpGet(request: NSMutableURLRequest!, callback: (String,
        String?) -> Void) {
            var configuration =
            NSURLSessionConfiguration.defaultSessionConfiguration()
            var session = NSURLSession(configuration: configuration,
                delegate: self,
                delegateQueue:NSOperationQueue.mainQueue())
            var task = session.dataTaskWithRequest(request){
                (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if error != nil {
                    callback(“”, error.localizedDescription)
                } else {
                    var result = NSString(data: data, encoding:
                        NSASCIIStringEncoding)!
                    callback(result, nil)
                }
            }
            task.resume()
    }
    
    
}
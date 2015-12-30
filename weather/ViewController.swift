//
//  ViewController.swift
//  weather
//
//  Created by Vipul Suthar on 12/28/15.
//  Copyright © 2015 Vipul Suthar. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation


class ViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    var userLocation:CLLocation = CLLocation()
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var firstUIView: UIView!
    
    @IBOutlet var currentLocationName: UILabel!
    
     var unitLabel : UILabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        unitLabel.text = "F"
        
        unitLabel.font = UIFont(name:unitLabel.font.fontName, size:CGFloat(20))
        
        unitLabel.textColor = UIColor.whiteColor()
        

    
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      //  print(locations)
        
        userLocation = locations[0]
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var temperature : NSInteger!
        var cityName : String!
        
        
        let url = NSURL(string:"http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=2de143494c0b295cca9337e1e96b00e0&units=imperial")!
       
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                // Stop locationing 
                
//                self.locationManager.stopUpdatingLocation()
                
                let webContent = NSString(data:urlContent, encoding: NSUTF8StringEncoding)
                
                var weatherDataDictionary:NSDictionary = self.convertStringToDictionary(webContent!)!
                
                print(weatherDataDictionary)
                
                for (key,value) in weatherDataDictionary {
                    let mainDict:NSDictionary = weatherDataDictionary["main"] as! NSDictionary
                    
                    cityName = weatherDataDictionary["name"]! as! String
                    temperature = mainDict["temp"] as! NSInteger
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    self.tempLabel.text! = String(temperature)
                    
                    self.tempLabel.text = self.tempLabel.text! + "\u{00B0}" + self.unitLabel.text!
                    
                    self.currentLocationName.text = cityName;
                    })
                

            } else {
                print(error)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    func convertStringToDictionary(text:NSString) -> [String:AnyObject]? {
        
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
    
    
    func httpGet (request:NSURLRequest!, callback:(String, String?) -> Void){
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil{
                callback("",error?.localizedDescription)
            } else {
                var result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                callback(result as String,nil)
            }
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


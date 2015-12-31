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
    
    let date = NSDate()
    let calender = NSCalendar.currentCalendar()
    var hrs = NSInteger()
    var min = NSInteger()
    var day = NSString()
    
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var firstUIView: UIView!
    
    @IBOutlet var currentLocationName: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    var unitLabel : UILabel = UILabel()
    var firstViewColor1 : UIColor = UIColor()
    var firstViewColor2 : UIColor = UIColor()
    let gradientLayer = CAGradientLayer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstViewColor1 = UIColor(red: 28/255, green: 116/255, blue: 136/255, alpha: 1)
        firstViewColor2 = UIColor(red: 124/255, green: 219/255, blue: 234/255, alpha: 1)
        
        
        let cfColor1 = firstViewColor1.CGColor
        let cfColor2 = firstViewColor2.CGColor
        
        
        gradientLayer.colors = [cfColor1, cfColor2]
        
        
        gradientLayer.locations = [0.0,1.0]
        
        
        configureGradientBackground(cfColor1,cfColor2)
        
        hrs = calender.component(NSCalendarUnit.Hour, fromDate: date)
        min = calender.component(NSCalendarUnit.Minute, fromDate: date)
        
        print("TODAY HRS \(hrs) => \(min) => \(day)")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EE | MMM d H:mm"
        dateLabel.text = dateFormatter.stringFromDate(date)
        
        print("NEW DATE \(dateLabel)")
        
        
    
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
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
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
    
    func configureGradientBackground(colors:CGColorRef...){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        let maxWidth = max(self.view.bounds.size.height,self.view.bounds.size.width)
        let squareFrame = CGRect(origin: self.firstUIView.bounds.origin, size: CGSizeMake(maxWidth, maxWidth))
        gradient.frame = squareFrame
        
        gradient.colors = colors
        self.view.layer.insertSublayer(gradient, atIndex: 0)
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


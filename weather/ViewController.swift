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
    
    var sysDict = NSDictionary()
    var weatherDict = NSArray()
    var hrs = NSInteger()
    var min = NSInteger()
    var day = NSString()
    var sunSet = Double()
    var sunRise = Double()
    
    var cloud = NSInteger()
    
    var currentUnixTimeStamp = NSDate().timeIntervalSince1970
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var firstUIView: UIView!
    
    @IBOutlet var currentLocationName: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet var counteryLabel: UILabel!
    
    @IBOutlet var day1Label: UILabel!
    
    @IBOutlet var day1Image: UIImageView!
    
    @IBOutlet var day1Temp: UILabel!
    
    @IBOutlet var day2Label: UILabel!
    
    @IBOutlet var day2Image: UIImageView!
    
    @IBOutlet var day2Temp: UILabel!
    
    @IBOutlet var day3Label: UILabel!
    
    @IBOutlet var day3Image: UIImageView!
    
    @IBOutlet var day3Temp: UILabel!
    
    
    var threeDayForcastDictionary = NSDictionary()
    
    var unitLabel : UILabel = UILabel()
    var firstViewColor1 : UIColor = UIColor()
    
    var firstViewColor2 : UIColor = UIColor()
    let gradientLayer = CAGradientLayer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        threeDayForcastDictionary = [
            "day1" : ["label":day1Label,"image":day1Image,"temp":day1Temp],
            "day2" : ["label":day2Label,"image":day2Image,"temp":day2Temp],
            "day3" : ["label":day3Label,"image":day3Image,"temp":day3Temp]
            
        ]
        
        
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
        dateFormatter.dateFormat = "EEEE | MMM d H:mm"
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
        
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                // Stop locationing
                
                self.locationManager.stopUpdatingLocation()
                
                let webContent = NSString(data:urlContent, encoding: NSUTF8StringEncoding)
                
                let weatherDataDictionary:NSDictionary = self.convertStringToDictionary(webContent!)!
                
                print(weatherDataDictionary)
                
                for (key,value) in weatherDataDictionary {
                    
                    let cloudDict:NSDictionary = weatherDataDictionary["clouds"] as! NSDictionary
                    self.cloud = cloudDict["all"] as! NSInteger
                    
                    let mainDict:NSDictionary = weatherDataDictionary["main"] as! NSDictionary
                    cityName = weatherDataDictionary["name"]! as! String
                    temperature = mainDict["temp"] as! NSInteger
                    
                    self.sysDict = weatherDataDictionary["sys"] as! NSDictionary
                    self.sunSet = self.sysDict["sunset"] as! Double
                    self.sunRise = self.sysDict["sunrise"] as! Double
                    
                    
                    self.weatherDict = weatherDataDictionary["weather"] as! NSArray
                    
                    print("SUN RISE \(self.sunRise) SUN SET \(self.sunSet) CURRENT TIME \(self.currentUnixTimeStamp)")
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    
                    self.tempLabel.text! = String(temperature)
                    
                    self.tempLabel.text = self.tempLabel.text! + "\u{00B0}" + self.unitLabel.text!
                    
                    self.currentLocationName.text = cityName;
                    
                    self.counteryLabel.text = self.sysDict["country"] as? String
                    
                    if self.cloud >= 80  {
                        self.weatherIcon.image = UIImage(named: "26")
                    }
                    
                    if self.currentUnixTimeStamp <= self.sunRise || self.currentUnixTimeStamp >= self.sunSet{
                        print("GOOD NIGHT")
                        
                        // setting default icon when sunset happen at local time
                        
                        self.weatherIcon.image = UIImage(named: "31")
                        
                        // get proper icon as per cloud condtion at night time
                        
                        if self.weatherDict[0]["main"] as! String == "Clear" {
                            
                            self.weatherIcon.image = self.getNightIconInfornation(self.cloud)
                            
                        } else if self.weatherDict[0]["main"] as! String == "Rain"{
                            
                            self.weatherIcon.image = self.getNightRainIconInformation(self.cloud)
                            
                        } else if self.weatherDict[0]["main"] as! String == "Clouds" {
                            
                            self.weatherIcon.image = self.getNightIconInfornation(self.cloud)
                            
                        }
                        
                    } else {
                        print("GOOD MORNING")
                        
                        // setting default icon when sunrise happen at localtime
                        self.weatherIcon.image = UIImage(named: "32")
                        
                        // get proper icon as per cloud condtion at day time
                        self.weatherIcon.image = self.getMorningIconInformation(self.cloud)
                    }
                    
                })
                
                if cityName != nil {
                    
                    let encodeCityName = cityName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    
                    let threeDayDaily = NSURL(string:"http://api.openweathermap.org/data/2.5/forecast/daily?q=\(encodeCityName)&mode=json&units=imperial&cnt=4&appid=2de143494c0b295cca9337e1e96b00e0")!
                    
                    print(threeDayDaily)
                    
                    self.makeDailyForcastRequest(threeDayDaily)
                    
                }
                
                
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
    
    /*
    
    Passing @cloud as integer value and decide which icon should pickup for day time weather
    
    */
    
    
    func getMorningIconInformation(cloud:NSInteger)-> UIImage {
        
        var weatherIcon = UIImage();
        if cloud >= 80 {
            
            weatherIcon = UIImage(named: "26")!
            
        }else if cloud >= 60 {
            
            weatherIcon = UIImage(named: "28")!
            
        }else if cloud >= 40 {
            
            weatherIcon = UIImage(named: "30")!
            
        } else if cloud >= 20 {
            
            weatherIcon = UIImage(named: "34")!
            
        } else {
            
            weatherIcon = UIImage(named: "32")!
        }
        
        return weatherIcon
    }
    
    
    /*
    
    Passing @cloud as integer value and decide which icon should pickup for night time weather
    
    */
    func getNightIconInfornation(cloud:NSInteger) -> UIImage {
        var weatherIcon = UIImage ()
        
        if cloud >= 80 {
            
            weatherIcon = UIImage(named: "26")!
            
        }else if cloud >= 60 {
            
            weatherIcon = UIImage(named: "27")!
            
        }else if cloud >= 40 {
            
            weatherIcon = UIImage(named: "29")!
            
        } else if cloud >= 20 {
            
            weatherIcon = UIImage(named: "33")!
            
        } else {
            
            weatherIcon = UIImage(named: "31")!
        }
        
        
        return weatherIcon
    }
    
    func getNightRainIconInformation(cloud:NSInteger) -> UIImage {
        var weatherIcon = UIImage ()
        
        
        if cloud >= 80 {
            
            weatherIcon = UIImage(named: "26")!
            
        }else if cloud >= 60 {
            
            weatherIcon = UIImage(named: "27")!
            
        }else if cloud >= 40 {
            
            weatherIcon = UIImage(named: "29")!
            
        } else if cloud >= 20 {
            
            weatherIcon = UIImage(named: "33")!
            
        } else {
            
            weatherIcon = UIImage(named: "31")!
        }
        
        
        return weatherIcon
    }
    
    func getMorningRain(cloud : NSInteger) -> UIImage {
        
        var weatherIcon = UIImage ()
        
        
        if cloud >= 80 {
            
            weatherIcon = UIImage(named: "12")!
            
        }else if cloud >= 60 {
            
            weatherIcon = UIImage(named: "11")!
            
        }else if cloud >= 40 {
            
            weatherIcon = UIImage(named: "9")!
            
        } else if cloud >= 20 {
            
            weatherIcon = UIImage(named: "39")!
            
        } else {
            
            weatherIcon = UIImage(named: "41")!
        }
        
        
        return weatherIcon
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
    
    func makeDailyForcastRequest(url:NSURL) -> Void {
        
        var weatherDataDictionary:NSDictionary = NSDictionary()
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data,response,error) -> Void in
            
            if let urlContent = data {
                
                let webContent = NSString(data:urlContent, encoding: NSUTF8StringEncoding)
                
                weatherDataDictionary = self.convertStringToDictionary(webContent!)!
                
                self.doDailyForcast(weatherDataDictionary)
                
            } else {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func doDailyForcast(dailyForcast:NSDictionary) {
        
        
        let dailyDataList:NSArray = dailyForcast["list"]! as! NSArray
        
        print(dailyForcast["list"])
        
        for var index=0; index < dailyDataList.count; index++ {
            if index == 0 {
                continue
            } else {
                
                let clouds:NSInteger = dailyDataList[index]["clouds"] as! NSInteger
                let temp:NSDictionary = dailyDataList[index]["temp"] as! NSDictionary
                let weather:NSArray = dailyDataList[index]["weather"] as! NSArray
                
                let dayDict : NSDictionary = threeDayForcastDictionary["day\(index)"] as! NSDictionary
                
                let tempLabel = dayDict["temp"] as! UILabel
                let dayLabel = dayDict["label"] as! UILabel
                let dayImage = dayDict["image"] as! UIImageView
                
                let temprature:NSInteger = temp["day"] as! NSInteger
                
                var date:Double = dailyDataList[index]["dt"] as! Double
                
                print(temprature)
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    tempLabel.text! = String(temprature)
                    dayLabel.text! =  self.dayStringFromTime(date)
                    dayImage.image = self.getProperImage(weather,cloud: clouds)
                    
                })
                
            }
        }
        
    }
    
    func dayStringFromTime(time:Double) -> String{
        
        let dateFormatter = NSDateFormatter()

        let date = NSDate(timeIntervalSince1970: time)
        
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        
        dateFormatter.dateFormat = "EE"
        
        print(dateFormatter.stringFromDate(date))
        
        return dateFormatter.stringFromDate(date)
    }
    
    func getProperImage(weather:NSArray,cloud:NSInteger) -> UIImage {
        var uiImage = UIImage()
        
        var main:String = weather[0]["main"] as! String
        
        print("TYPE WEATHER ==> \(main)")
        
        if main == "Rain" {
            
            uiImage = self.getMorningRain(cloud)
            
        } else if main == "Clear" {
            
            uiImage = self.getMorningIconInformation(cloud)
            
        }
        
        return uiImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


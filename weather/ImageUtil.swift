//
//  ImageUtil.swift
//  weather
//
//  Created by Vipul Suthar on 1/3/16.
//  Copyright © 2016 Vipul Suthar. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    
    func getWeatherImageBasedOnCondition(weatherCode : NSInteger) -> UIImage {
        var weatherIcon:UIImage = UIImage()
        
        switch weatherCode {
            
//            Group 2xx: Thunderstorm
            
        case 200:
            
            weatherIcon = UIImage(named: "40")!
            
        case 201:
            
            weatherIcon = UIImage(named: "0")!
            
        case 202:
            
            weatherIcon = UIImage(named: "1")!
            
        case 210:
            
            weatherIcon = UIImage(named:"2")!
            
        case 211:
            
            weatherIcon = UIImage(named:"3")!
            
        case 212,221:
            
            weatherIcon = UIImage(named:"4")!
            
        case 230,231,232:
            
            weatherIcon = UIImage(named:"17")!
            
//            Group 3xx: Drizzle
            
        case 300,301,310,311,313,321:
            
            weatherIcon = UIImage(named:"14")!
            
        case 302:
            
            weatherIcon = UIImage(named:"6")!
            
        case 312:
            
            weatherIcon = UIImage(named: "5")!
            
        case 314:
            
            weatherIcon = UIImage(named:"11")!
            
//            Group 5xx: Rain
            
        case 500,501:
            
            weatherIcon = UIImage(named:"39")!
            
        case 502,203,504,522,531:
            
            weatherIcon = UIImage(named:"12")!
            
        case 511:
            
            weatherIcon = UIImage(named:"10")!
            
        case 520,521:
            
            weatherIcon = UIImage(named: "9")!
            
//            Group 6xx: Snow
            
        case 600:
            
            weatherIcon = UIImage(named:"13")!
            
        case 601:
            
            weatherIcon = UIImage(named:"14")!
            
        case 602:
            
            weatherIcon = UIImage(named:"16")!
            
        case 611,612:
            
            weatherIcon = UIImage(named:"8")!
            
        case 615,616:
            
            weatherIcon = UIImage(named:"5")!
            
        case 620,621:
            
            weatherIcon = UIImage(named:"6")!
            
        case 622:
            
            weatherIcon = UIImage(named:"7")!
            
//            Group 7xx: Atmosphere
            
        case 701,741:
            
            weatherIcon = UIImage(named:"20")!
            
        case 721,731:
            
            weatherIcon = UIImage(named:"19")!
            
        case 751,761,762,771:
            
            weatherIcon = UIImage(named:"21")!
            
        case 711:
            
            weatherIcon = UIImage(named:"22")!
            
        case 781:
            
            weatherIcon = UIImage(named: "17")!
            
//            Group 800: Clear
            
        case 800:
            
            weatherIcon = UIImage(named: "32")!
            
//            Group 80x: Clouds

        case 801:
            
            weatherIcon = UIImage(named: "34")!
            
        case 802:
            
            weatherIcon = UIImage(named:"")!
            
        default:
            weatherIcon = UIImage(named: "36")!
        }
        
        
        
        return weatherIcon
    }
    
}

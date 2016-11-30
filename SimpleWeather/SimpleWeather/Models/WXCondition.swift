//
//  WXCondition.swift
//  SimpleWeatherSwift
//
//  Created by Mammie, Eugene on 11/17/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit
import Mantle

let MPS_TO_MPH = 2.23694

class WXCondition: MTLModel, MTLJSONSerializing {

    var date : Date = Date()
    var humidity : NSNumber = 0.0
    var temperature :NSNumber = 0.0
    var tempHigh : NSNumber = 0.0
    var tempLow : NSNumber = 0.0
    var locationName : String = ""
    var sunrise : Date = Date()
    var sunset : Date = Date()
    var conditionDescription :String = ""
    var condition : String = ""
    var windBearing : NSNumber = 0.0
    var windSpeed : NSNumber = 0.0
    var icon : String = ""
    
  
    static var imageMap = [    "01d" :  "weather-clear",
         "02d" :  "weather-few",
         "03d" :  "weather-few",
         "04d" :  "weather-broken",
         "09d" :  "weather-shower",
         "10d" :  "weather-rain",
         "11d" :  "weather-tstorm",
         "13d" :  "weather-snow",
         "50d" :  "weather-mist",
         "01n" :  "weather-moon",
         "02n" :  "weather-few-night",
         "03n" :  "weather-few-night",
         "04n" :  "weather-broken",
         "09n" :  "weather-shower",
         "10n" :  "weather-rain-night",
         "11n" :  "weather-tstorm",
         "13n" :  "weather-snow",
         "50n" :  "weather-mist",
        ]
    
    
    func imageName() -> String {
        return WXCondition.imageMap[self.icon]!
    }
    
    public static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]!{
        
        //TODO: implement dictionary for protocol
        return ["date":"dt",
                "humidity":"main.humidity",
                "temperature":"main.temp",
                "tempHigh":"main.temp_max",
                "tempLow":"main.temp_min",
                "locationName":"sys.country",
                "sunrise":"sys.sunrise",
                "sunset":"sys.sunset",
                "condition":"weather[0].main",
                "conditionDescription":"weather[0].description",
        ]
    }
    
    static func dateJSONTransformer() -> ValueTransformer {
    // 1
      return MTLValueTransformer.init(usingForwardBlock: {(a: Any,b,c) -> Any? in return
            
            Date.init(timeIntervalSinceNow:a as! TimeInterval)
            
        }, reverse:{(a: Any,b,c) -> Any?
            in
           let dateformatter = DateFormatter()
             return
            
            
            dateformatter.string(from: (a as? Date)!)
            
        })
    }
    
    static func sunriseJSONTransformer() -> ValueTransformer {
        return self.dateJSONTransformer()
    }
    
    static func sunsetJSONTransformer() -> ValueTransformer {
        return self.dateJSONTransformer()
    }
    
    static func conditionDescriptionJSONTransformer() ->ValueTransformer {
        
        return MTLValueTransformer.init(usingForwardBlock: { (s1:Any?, s2, s4) -> Any? in
            let a = s1 as? Array<Any>
           return a?.first
        }, reverse: { (s1, s2, s3) -> Any? in
            return [s1]
        })
    }
    
     static func conditionJSONTransformer() -> ValueTransformer {
        return self.conditionDescriptionJSONTransformer()
    }
    
     static func iconJSONTransformer() -> ValueTransformer {
        return self.conditionDescriptionJSONTransformer()
    }
    
    static func windSpeedJSONTransformer() -> ValueTransformer {
        return MTLValueTransformer.init(usingForwardBlock: { (a,b,c) -> Any?
           in let windSpeed = a as? NSNumber
            return windSpeed // * MPS_TO_MPH
        }, reverse: { (a,b,c) -> Any? in
            return a // /MPS_TO_MPH
        })
    }
}

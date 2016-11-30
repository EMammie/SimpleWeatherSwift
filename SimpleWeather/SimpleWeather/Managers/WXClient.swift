//
//  WXClient.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/20/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveSwift
import Result
import Mantle

class WXClient: NSObject {
    
     let APPID = "f9976cb284fb9b6ffa68977af727e5fb"
    
   lazy var session = { () -> URLSession in 

            let sessionConfig =    URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            return session
        }
    
    
    func fetchJSONFromURL(url:URL) -> SignalProducer<Any,NoError> {
        
        return SignalProducer<Any,NoError> { observer, _ in
            
            let task = self.session().dataTask(with: url) { (data, URLResponse, Error) in
                //:TODO Handle retrieved data
                
                    if let Error = Error {
                        print(Error.localizedDescription)
                    } else if let httpResponse = URLResponse as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                observer.send(value: json)
                        }
                    }
                }
            task.resume()
        }
    }
    
    func fetchCurrentConditionsForLocation(coordinate:CLLocationCoordinate2D) -> SignalProducer<Any,NoError> {
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&id=524901&APPID=\(APPID)")
            return fetchJSONFromURL(url: url!).map({ data in
                var jSONDict = data as? [AnyHashable:Any]
                
                do{
                    let val = try MTLJSONAdapter.model(of: WXCondition.self, fromJSONDictionary: jSONDict)
                    return val
                }
                catch
                {
                    print("Error ------ \(error)")
                    return data
                }
            })
    }
    
    func fetchHourlyForecastForLocation(coordinate:CLLocationCoordinate2D) -> SignalProducer<Any,NoError> {
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=12&APPID=\(APPID)")
        return fetchJSONFromURL(url: url!).map({ data in
            var jSONDict = data as? [AnyHashable:Any]
            let hourlyDict = jSONDict?["list"] as! [Any]
            
          return  hourlyDict.map{ item -> Any? in
                        dump(item)
                        let oneHour = item as! [AnyHashable:Any]
                        do{
                            let val = try MTLJSONAdapter.model(of: WXCondition.self, fromJSONDictionary: oneHour)
                            return val
                        }
                        catch
                        {
                            print("Error ------ \(error)")
                            return data
                        }
            }
            
        })
    }
    func fetchDailyForecastForLocation(coordinate:CLLocationCoordinate2D) -> SignalProducer<Any,NoError> {

        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=7&appid=\(APPID)")
        return fetchJSONFromURL(url: url!).map({ data in
                    var jSONDict = data as? [AnyHashable:Any]
                    let dailyForcasts = jSONDict?["list"] as! [Any]
            
                    return dailyForcasts.map({
                            item -> Any in
                        let oneDay = item as! [AnyHashable:Any]
                                do{
                                    let val = try MTLJSONAdapter.model(of: WXDailyForcast.self, fromJSONDictionary: oneDay)
                                    return val
                                }
                                catch
                                {
                                    print("Error ------ \(error)")
                                    return data
                                }
                    })
            
                })

    }

}

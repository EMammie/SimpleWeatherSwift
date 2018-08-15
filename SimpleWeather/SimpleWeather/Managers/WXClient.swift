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

enum WXClientError : Error {
    case commonError
    case webFailure(description:String)
    case parseFailure
}

typealias jsonData = [String : Any]

class WXClient: NSObject {

   let APPID = "f9976cb284fb9b6ffa68977af727e5fb"
    
    var urlComponent = URLComponents(string: "https://api.openweathermap.org")
    
   lazy var session = { () -> URLSession in
            let sessionConfig =    URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            return session
    }
    
    func fetchDataFromURL(url:URL) -> SignalProducer<Data,WXClientError> {
        return SignalProducer<Data,WXClientError> { observer, _ in
            let task = self.session().dataTask(with: url) { (data, URLResponse, Error) in
                    if let Error = Error {
                        observer.send(error: WXClientError.webFailure(description: Error.localizedDescription))
                    } else if let httpResponse = URLResponse as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            observer.send(value:data!)
                        }
                }
            }
            task.resume()
        }
    }
    
    func fetchCurrentConditionsForLocation(coordinate:CLLocationCoordinate2D) -> Signal<WXCondition,WXClientError> {
        return Signal<WXCondition,WXClientError> { observer , some in
            let currentConditionURL = URL(string: "weather", relativeTo: urlComponent?.url)
            urlComponent?.path = "/data/2.5/weather"
            let latitudeQueryItem = URLQueryItem(name: "lat", value: String(coordinate.latitude))
            let longitudeQueryItem = URLQueryItem(name: "lon", value: String(coordinate.longitude))
            let unitQueryItem = URLQueryItem(name: "units", value: "imperial")
            let appIDTokenQueryItem = URLQueryItem(name: "APPID", value: APPID)
            
            urlComponent?.queryItems = [latitudeQueryItem,longitudeQueryItem,unitQueryItem,appIDTokenQueryItem]
            
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&APPID=\(APPID)")
            
            let weatherURL = urlComponent?.url
            let signalObserver = Signal<Data, WXClientError>.Observer (
                value: { value in
                    do{
                        let decoder = JSONDecoder()
                        let currentCondition = try decoder.decode(WXConditionService.self, from: value)
                        observer.send(value:WXCondition(service:currentCondition))
                    }
                    catch
                    {
                        print("Error ------ \(error)")
                    }
            }, completed: {
                print("WXClient: completed")
                observer.sendCompleted()
            }, interrupted: {
                print("WXClient.fetchCurrentConditions: interrupted")
            })
            fetchDataFromURL(url: weatherURL!).start(signalObserver)
        }
    }
    
    func fetchHourlyForecastForLocation(coordinate:CLLocationCoordinate2D) -> Signal<[WXHourlyCondition],WXClientError> {
        return Signal<[WXHourlyCondition],WXClientError> { observer ,some in
            let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=40&APPID=\(APPID)")
            fetchDataFromURL(url: url!).start(){ event in
                if let value = event.value {
                    do{
                        let decoder = JSONDecoder()
                        let val = try decoder.decode(WXHourlyConditionService.self, from: value)
                        let conditions = val.list//val.list.map(){ return WXHourlyCondition(service:$0)}
                        observer.send(value:conditions)
                    }
                    catch
                    {
                        print("Error ------ \(error)")
                        observer.send(error:  WXClientError.parseFailure)
                    }
                }
            }
        }
    }
    
    func fetchDailyForecastForLocation(coordinate:CLLocationCoordinate2D) -> Signal<[WXDailyCondition],WXClientError> {
        return Signal<[WXDailyCondition],WXClientError> { observer , some in
            let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=imperial&cnt=7&appid=\(APPID)")
            fetchDataFromURL(url: url!).start(){ event in
                if let value = event.value {
                    do{
                        let decoder = JSONDecoder()
                        let val = try decoder.decode(WXDailyConditionService.self, from: value)
                        let conditions = val.list//val.list.map(){ return WXHourlyCondition(service:$0)}
                        observer.send(value:conditions)
                    }
                    catch
                    {
                        print("Error ------ \(error)")
                        observer.send(error:  WXClientError.parseFailure)
                    }
                }
            }
        }
    }

    
    func clientURL(coordinate : CLLocationCoordinate2D) -> URL{
        
        let currentConditionURL = URL(string: "weather", relativeTo: urlComponent?.url)
        urlComponent?.path = "/data/2.5/weather"
        let latitudeQueryItem = URLQueryItem(name: "lat", value: String(coordinate.latitude))
        let longitudeQueryItem = URLQueryItem(name: "lon", value: String(coordinate.longitude))
        let unitQueryItem = URLQueryItem(name: "units", value: "imperial")
        let appIDTokenQueryItem = URLQueryItem(name: "APPID", value: APPID)
        urlComponent?.queryItems = [latitudeQueryItem,longitudeQueryItem,unitQueryItem,appIDTokenQueryItem]
        guard let completeURL = urlComponent?.url else {
            return URL(string:"http://api.openweathermap.org/data/2.5/weather?lat=39.9&lon=75.16&units=imperial&APPID=f9976cb284fb9b6ffa68977af727e5fb")!
        }
        return completeURL
    }
    
    func clientURL(withCity Name: String) -> URL {
        let currentConditionURL = URL(string: "weather", relativeTo: urlComponent?.url)
        urlComponent?.path = "/data/2.5/weather"
        let nameQueryItem = URLQueryItem(name: "q" , value: Name)
        let unitQueryItem = URLQueryItem(name: "units", value: "imperial")
        let appIDTokenQueryItem = URLQueryItem(name: "APPID", value: APPID)
        urlComponent?.queryItems = [nameQueryItem,unitQueryItem,appIDTokenQueryItem]
        guard let completeURL = urlComponent?.url else {
            return URL(string:"http://api.openweathermap.org/data/2.5/weather?q=London&units=imperial&APPID=f9976cb284fb9b6ffa68977af727e5fb")!
        }
        return completeURL
        
    }
}

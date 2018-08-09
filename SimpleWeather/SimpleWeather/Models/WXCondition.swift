//
//  WXCondition.swift
//  SimpleWeatherSwift
//
//  Created by Mammie, Eugene on 11/17/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit

let MPS_TO_MPH = 2.23694

struct WXCondition : Codable , WXIcon {
    let date : Date
    let humidity : Float
    let temperature : Float
    let tempHigh : Float
    let tempLow : Float
    let locationName : String
    let sunrise : Date
    let sunset : Date
    let conditionDescription :String
    let condition : String
    let windBearing : Float
    let windSpeed : Float
    let icon : String?
    
    struct systemInfo : Codable {
        let message : Float
        //let country : String
        let sunrise : Float
        let sunset : Float
    }
    /*
    enum CodingKeys: String, CodingKey{
        case date = "dt"
        case humidity
        case temperature
        case tempHigh
        case tempLow
        case locationName
        case sunrise
        case sunset
        case conditionDescription
        case condition
        case windBearing
        case windSpeed
        case icon
    }*/
}

struct WXDailyCondition : Codable, WXIcon {
    var icon: String? { return weather[0].icon }
    let time :Float?
    let temp : dailyTemp
    let pressure : Float
    let humidity : Float
    let weather : [WXWeatherInfo]
    let speed : Float
    let deg : Float
    let clouds : Float
    
    struct dailyTemp : Codable{
        let day : Float
        let min : Float
        let max : Float
        let night : Float
        let eve : Float
        let morn : Float
    }
    enum CodingKeys : String, CodingKey {
        case time = "dt"
        case temp
        case pressure
        case humidity
        case weather
        case speed
        case deg
        case clouds
    }
}

struct WXHourlyCondition : Codable, WXIcon {
    
    var icon: String? { return weather[0].icon }
    let dt : Double
    let main : WXMainWeatherStats
    let weather : [WXWeatherInfo]
    let wind : [String : Float]
    let time : String
    
    enum CodingKeys : String, CodingKey {
        case time = "dt_txt"
        case dt
        case main
        case weather
        case wind
    }
}
// Commonly used OpenWeather API Key Values
struct WXMainWeatherStats : Codable {
    let temp : Float
    let pressure : Float
    let humidity : Float
    let minTemp : Float
    let maxTemp : Float
    var seaLvl : Float?
    let groundLvl : Float?
    
    enum CodingKeys : String, CodingKey {
        case temp
        case pressure
        case humidity
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case seaLvl = "sea_level"
        case groundLvl = "grnd_level"
    }
    
}

struct WXWeatherInfo : Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}


protocol WXServices {
    var main : [String : Float] {get set}
    var wind : [String : Float] {get set}
    var dt : Double { get set}
    var sys : WXCondition.systemInfo {get set}
    var id : Int { get set }
    var name : String { get set}
}
struct WXConditionService : Codable {
    let coord : [String : Float]
    let weather : [WXWeatherInfo]
    let main : WXMainWeatherStats
    let wind : [String : Float]
    let dt : Double
    let sys : WXCondition.systemInfo
    let id : Int
    let name : String
}

struct WXDailyConditionService : Codable {
    let city : cityInfo
    let cnt : Int
    let list : [WXDailyCondition]
    struct cityInfo  : Codable{
        let id : Float?
        let name : String
        let latitude : Float?
        let longitude : Float?
        let country : String
        let population : Int
        
        enum CodingKeys : String, CodingKey {
            case id 
            case name
            case latitude
            case longitude
            case country
            case population
        }
    }
}

struct WXHourlyConditionService : Codable {
    let cnt : Int
    let list : [WXHourlyCondition]
    let city : cityInfo
    
    
    struct cityInfo : Codable{
        let id : Float
        let name : String
        let country : String
    }
}




extension WXCondition {
    init(service : WXConditionService) {
        date = Date(timeIntervalSince1970:service.dt)
        humidity = service.main.humidity
        temperature = service.main.temp
        tempHigh = service.main.maxTemp
        tempLow = service.main.minTemp
        locationName = service.name
        sunrise = Date(timeIntervalSince1970: TimeInterval(service.sys.sunrise))
        sunset = Date(timeIntervalSince1970: TimeInterval(service.sys.sunset))
        conditionDescription = service.weather.description
        condition = service.weather[0].main
        windBearing = service.wind["deg"]!
        windSpeed = service.wind["speed"]!
        icon = service.weather[0].icon
        
    }
}


protocol WXIcon {
    static func imageMap() -> [String: String]
    func imageNamed() -> String
    var icon : String? {get}
}

extension WXIcon {
    static func imageMap() -> [String: String] {
        return ["01d" : "weather-clear",
        "02d" : "weather-few",
        "03d" : "weather-few",
        "04d" : "weather-broken",
        "09d" : "weather-shower",
        "10d" : "weather-rain",
        "11d" : "weather-tstorm",
        "13d" : "weather-snow",
        "50d" : "weather-mist",
        "01n" : "weather-moon",
        "02n" : "weather-few-night",
        "03n" : "weather-few-night",
        "04n" : "weather-broken",
        "09n" : "weather-shower",
        "10n" : "weather-rain-night",
        "11n" : "weather-tstorm",
        "13n" : "weather-snow",
        "50n" : "weather-mist"]
    }
    
    func imageNamed() -> String {
        guard let icon = icon else {
            return Self.imageMap()["01d"]!
        }
        return Self.imageMap()[icon]!
    }
}



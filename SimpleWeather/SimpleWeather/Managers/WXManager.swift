//
//  WXManager.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/28/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveSwift
import TSMessages


class WXManager: NSObject{

    var currentLocation : CLLocation = CLLocation()
    var currentCondition : WXCondition = WXCondition()

    var hourlyForcast = [WXCondition]()
    var dailyForcast = [WXCondition]()
    
    var locationManager : CLLocationManager = CLLocationManager()

    var client : WXClient = WXClient()
    var isFirstUpdate = true

    static let sharedInstance = { () -> WXManager in 
        let instance = WXManager()
        
        instance.currentLocation <~ 
        return instance
    }
    
    private override init() {
        print("//  ///  ////")
    }
    func findCurrentLocation(){
        
    }
    
}

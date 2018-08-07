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
import Result


class WXManager: NSObject , CLLocationManagerDelegate {

    let currentLocation = MutableProperty<CLLocation?>(nil)
    
    lazy var currentLocation2 : MutableProperty<CLLocation> = {
        if let aLocale = self.locationManager.location{
            return MutableProperty<CLLocation>(aLocale)
        } else{
            return MutableProperty<CLLocation>(CLLocation(latitude: 0, longitude: 0))
        }
    }()
    
    var currentCondition = MutableProperty<WXCondition?>(nil)

    var hourlyForcast = MutableProperty<[WXHourlyCondition]>([WXHourlyCondition]())
    var dailyForcast = MutableProperty<[WXDailyCondition]>([WXDailyCondition]())
    
    let locationManager = CLLocationManager()

    var client : WXClient = WXClient()
    var isFirstUpdate = true

    static let sharedInstance = { () -> WXManager in 
        let instance = WXManager()
        return instance
    }
    
    private override init() {
        print("//  ///  ////")
        super.init()
        //locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 10
        
        currentLocation.signal.observeValues { location in
            
            self.updateCurrentConditions().observe(){ event in 
                
            }
            self.updateHourlyConditions().observe() { event in
                
            }
           /* let aSignal =  Signal<[Signal],NoError>.merge(signal[self.updateCurrentConditions(),self.updateHourlyConditions()]).observe(on: UIScheduler())*/
        }
    }
    
    func findCurrentLocation(){
        isFirstUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    func updateCurrentConditions() ->Signal<WXCondition,WXClientError> {
       /* client.fetchCurrentConditionsForLocation(coordinate: currentLocation.value.coordinate).observe({ event in
            print("Event: \(event)")
            switch (event) {
            case .value :
                self.currentCondition.value = event.value
            default :
                print("Default: \(event)")
            }
        })
        
        
        )*/
        
        guard let locale = currentLocation.value else {
            let spot = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            return client.fetchCurrentConditionsForLocation(coordinate: spot)
        }
        return client.fetchCurrentConditionsForLocation(coordinate: locale.coordinate).on(event: { event in
            print("Event in updateCurrentConditions\(event)")
        },
            failed: { event in
                print("Failed in updateCurrentConditions \(event)")
        }, value : { condition in
            self.currentCondition.value = condition
        })
    }
    
    func updateHourlyConditions() ->Signal<[WXHourlyCondition],WXClientError> {
        guard let locale = currentLocation.value else {
            let spot = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            return client.fetchHourlyForecastForLocation(coordinate: spot)
        }
        return client.fetchHourlyForecastForLocation(coordinate: locale.coordinate).on(event: { event in
            print("Event in updateHourlyConditions\(event)")
        },
        failed: { event in
            print("Failed in updateHourlyConditions \(event)")
        }, value : { conditions in
            self.hourlyForcast.value = conditions
        })
        
    }
    
    
 // Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if (isFirstUpdate) {
            isFirstUpdate = false
            return
        }
    
       if let location = locations.last{
        if (location.horizontalAccuracy > 0 ){
                self.currentLocation.value = location
                print(location)
                //locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      
        print(error)
        
    }

}


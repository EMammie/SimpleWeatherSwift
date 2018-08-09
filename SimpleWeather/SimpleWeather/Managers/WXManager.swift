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
import RMessage
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
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
       // currentLocation.signal.observe(on: UIScheduler()).observe(){ event in
            
       // }
        currentLocation.signal.observeValues { location in
            
            self.updateCurrentConditions().observe(){ [weak self] event in
                if event.error != nil {
                    DispatchQueue.main.async {
                        self?.showError()
                    }
                }
            }
            self.updateHourlyConditions().observe() { event in
                
            }
            
            self.updateDailyConditions().observe() { event in
                
            }
        }
    }
    
    
    func showError() {
        RMessage.showNotification(withTitle: "Error", subtitle: "There was a problem fetching the latest weather", type: .error, customTypeName: "", callback: {})
    }
    func findCurrentLocation(){
        isFirstUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    func updateCurrentConditions() ->Signal<WXCondition,WXClientError> {
        
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
    
    func updateDailyConditions() ->Signal<[WXDailyCondition],WXClientError> {
        guard let locale = currentLocation.value else {
            let spot = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            return client.fetchDailyForecastForLocation(coordinate: spot)
        }
        return client.fetchDailyForecastForLocation(coordinate: locale.coordinate).on(event: { event in
            print("Event in updateDailyConditions\(event)")
        },
                                                                                       failed: { event in
                                                                                        print("Failed in updateDailyConditions \(event)")
        }, value : { conditions in
            self.dailyForcast.value = conditions
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
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        RMessage.showNotification(withTitle: "Error", subtitle: error.localizedDescription, type: .error, customTypeName: "", callback: {})
        
    }

}



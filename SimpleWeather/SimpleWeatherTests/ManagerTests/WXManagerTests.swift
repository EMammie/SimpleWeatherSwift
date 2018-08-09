//
//  WXManagerTests.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/28/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import XCTest
import CoreLocation
import ReactiveSwift
import Result

@testable import SimpleWeather

class WXManagerTests: XCTestCase {
    var sut : WXManager!
    
    override func setUp() {
        super.setUp()
        sut = WXManager.sharedInstance()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_SingletonCreated() {
        
        XCTAssertNotNil(WXManager.sharedInstance)
        
    }
  
    func test_SingletonUnique() {
        
       // let instance1 = WXManager() default initializer is inaccessible because of Private
        
        let instance1 = WXManager.sharedInstance()
        let instance2 = WXManager.sharedInstance()
        
        XCTAssertFalse(instance1 === instance2)
        
    }
    /*
    func testSharedInstance_ThreadSafety() {
        var instance1 : WXManager!
        var instance2 : WXManager!

        //TODO: Thread Safety
        let expectation1 = expectation(description: "Instance 1")
        dispatch_async(DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            instance1 = WXManager.sharedInstance
            expectation1.fulfill()
        }
        
        
        let expectation2 = expectation(description:"Instance 2")
        dispatch_async(DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            instance2 = WXManager.sharedInstance
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertTrue(instance1 === instance2)
        }
    }*/
    
    func test_currentLocationSignal(){
        var currentLocationHasChanged = false
        let observer = Signal<CLLocation?,NoError>.Observer( value:
        {   value in
            currentLocationHasChanged = true
            print(value)
        })
        let originalLocale = sut.currentLocation.value
        sut.currentLocation.producer.start(observer)
        sut.currentLocation.value = CLLocation(latitude:34.05, longitude:-118.25)
        
        print(" - \(originalLocale)")
        print(" - \(sut.currentLocation.value))")
        XCTAssert(currentLocationHasChanged, "Current Location Hasn't Changed")
    }
}

extension WXManagerTests {
    class MockLocationManagerDelegate : NSObject , CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            
        
        }
        
        func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            
            print(error)
            
        }
        
    }
    class MockLocationManager : CLLocationManager {
       
        var updatedLocation = false
        
        override func startUpdatingLocation() {
            updatedLocation = true
            super.startUpdatingLocation()
        }
    }
}

/*
 CLLocation *Shanghai = [[CLLocation alloc] initWithLatitude:31.2 longitude:121.5];
 CLLocation *Moscow = [[CLLocation alloc] initWithLatitude:55.75 longitude:37.616667];
 CLLocation *Tokyo = [[CLLocation alloc] initWithLatitude:35.683333 longitude:139.683333];
 CLLocation *MexicoCity = [[CLLocation alloc] initWithLatitude:19.433333 longitude:-99.133333];
 CLLocation *NewYorkCity = [[CLLocation alloc] initWithLatitude:40.7127 longitude:-74.0059];
 CLLocation *London = [[CLLocation alloc] initWithLatitude:51.507222 longitude:-0.1275];
 CLLocation *RioDeJeneiro = [[CLLocation alloc] initWithLatitude:-22.908333 longitude:-43.196389];
 CLLocation *LosAngeles = [[CLLocation alloc] initWithLatitude:34.05 longitude:-118.25];
 
 mockLocations = [NSArray arrayWithObjects:Shanghai, Moscow, Tokyo, MexicoCity, NewYorkCity, London, RioDeJeneiro, LosAngeles, nil];
 
 
 */

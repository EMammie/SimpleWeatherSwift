//
//  WXClientTests.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/25/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import XCTest
import Result
import ReactiveSwift
import MapKit

@testable import SimpleWeather

class WXClientTests: XCTestCase {
    var sut : WXClient!
    
    let staticUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=39.9&lon=75.16&units=imperial&APPID=f9976cb284fb9b6ffa68977af727e5fb")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = WXClient()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Session() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNotNil(sut)
    }
    
    func test_fetchDataSignal() {

        let signalExpectation = self.expectation(description: "Signal Expectation")
        
        let testObserver = Signal<Data,WXClientError>.Observer{ (event) in
                switch event {
                case let .value(v):
                    print("Test Observation value = \(v)")
                    XCTAssertNotNil(v)
                    signalExpectation.fulfill()
                case let .failed(error):
                    print("Test Observation error = \(error)")
                case .completed:
                    print("Test Observation completed")
                case .interrupted:
                    print("Test Observation interrupted")
                }
            }
        let weatherURL = sut.clientURL(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(18), longitude: CLLocationDegrees(75)))
        
        sut.fetchDataFromURL(url: weatherURL).start(testObserver)
        self.waitForExpectations(timeout: 2.0, handler:nil)

    }
    
    func test_fetchCurrentConditionsForLocation(){
        let signalExpectation = self.expectation(description: "Signal Expectation")
        
        let long = CLLocationDegrees(39.9)
        let lat = CLLocationDegrees(75.16)
        let coord = CLLocationCoordinate2DMake(long, lat)
        
        let testObserver = Signal<WXCondition,WXClientError>.Observer{ (event) in
            switch event {
            case let .value(v):
                print("Test Observation value = \(v)")
                XCTAssertNotNil(v)
                signalExpectation.fulfill()
            case let .failed(error):
                print("Test Observation error = \(error)")
            case .completed:
                print("Test Observation completed")
            case .interrupted:
                print("Test Observation interrupted")
            }
        }
        
        sut.fetchCurrentConditionsForLocation(coordinate: coord).observe(testObserver)
        self.waitForExpectations(timeout: 3.0, handler:nil)
    }
    
    func test_fetchHourlyForcastForLocation(){
        
        let signalExpectation = self.expectation(description: "Signal Expectation")
        
        let long = CLLocationDegrees(39)
        let lat = CLLocationDegrees(75)
        let coord = CLLocationCoordinate2DMake(long, lat)
        
        let testObserver = Signal<[WXHourlyCondition],WXClientError>.Observer{ (event) in
            switch event {
            case let .value(v):
                print("Test Observation value = \(v)")
                XCTAssertNotNil(v)
                signalExpectation.fulfill()
            case let .failed(error):
                print("Test Observation error = \(error)")
            case .completed:
                print("Test Observation completed")
            case .interrupted:
                print("Test Observation interrupted")
            }
        }
        
        let newSignal = sut.fetchHourlyForecastForLocation(coordinate: coord).observe(){ event in
            XCTAssertNotNil(event)
            print("Data ---- \(event)")
            signalExpectation.fulfill()
        }
        
        XCTAssertNotNil(newSignal)
        sut.fetchHourlyForecastForLocation(coordinate: coord).observe(testObserver)
        self.waitForExpectations(timeout: 3.0, handler:nil)
    }
   /*
    func test_fetchDailyForecastForLocation(){
        let signalExpectation = self.expectation(description: "Signal Expectation")
        
        let long = CLLocationDegrees(39)
        let lat = CLLocationDegrees(75)
        let coord = CLLocationCoordinate2DMake(long, lat)
        let newSignal = sut.fetchDailyForecastForLocation(coordinate: coord).map({ data in
            signalExpectation.fulfill()
            XCTAssertNotNil(data)
            print("Data ---- \(data)")
    
        })
        
        
        XCTAssertNotNil(newSignal)
        
        newSignal.start()
        
        self.waitForExpectations(timeout: 3.0, handler:nil)

        
    }

    */
}

//
//  WXConditionTests.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/19/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import XCTest
@testable import SimpleWeather

class WXConditionTests: XCTestCase {
    
    var sut : WXCondition!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_imageMapProperty() {
        XCTAssertNotNil(WXCondition.imageMap)
        let test = WXCondition.imageMap["50d"]
        XCTAssertEqual(test,"weather-mist")
    }
    
    func test_Transformer() {
        XCTAssertNotNil(WXCondition.sunriseJSONTransformer)
        print("-->\(WXCondition.sunriseJSONTransformer))")
    }
}

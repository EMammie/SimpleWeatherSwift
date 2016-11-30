//
//  WXControllerTests.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/19/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import XCTest
@testable import SimpleWeather

class WXControllerTests: XCTestCase {
    
    var sut : WXController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = WXController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

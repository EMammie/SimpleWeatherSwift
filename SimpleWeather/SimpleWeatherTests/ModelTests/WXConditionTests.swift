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
    var mockWXConditionService : WXConditionService?
    

    override func setUp() {
        super.setUp()
        let json = """
{"coord":{"lon":-73.99,"lat":40.73},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"base":"stations","main":{"temp":298.6,"pressure":1020,"humidity":78,"temp_min":297.15,"temp_max":300.15},"visibility":16093,"wind":{"speed":3.6,"deg":150},"clouds":{"all":90},"dt":1532482500,"sys":{"type":1,"id":1969,"message":0.0051,"country":"US","sunrise":1532511969,"sunset":1532564297},"id":5128581,"name":"New York","cod":200}
""".data(using: .utf8)
        
        let decoder = JSONDecoder()
        mockWXConditionService = try! decoder.decode(WXConditionService.self, from:json!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_WXCondition_InitWith_Service() {
        sut = WXCondition(service: mockWXConditionService!)
        XCTAssertNotNil(sut)
        XCTAssert(sut.locationName == "New York")
    }
    
}

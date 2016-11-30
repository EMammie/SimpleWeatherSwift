//
//  WXManagerTests.swift
//  SimpleWeather
//
//  Created by Mammie, Eugene on 11/28/16.
//  Copyright © 2016 com.Development. All rights reserved.
//

import XCTest
@testable import SimpleWeather

class WXManagerTests: XCTestCase {
    var sut : WXManager!
    
    override func setUp() {
        super.setUp()
        sut = WXManager.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_SingletonCreated() {
        
        XCTAssertNotNil(WXManager.sharedInstance)
        
    }
    
    func test_SingletonUnique() {
        
       // let instance1 = WXManager() default initializer is inaccessible because of Private
        
        let instance1 = WXManager.sharedInstance
        let instance2 = WXManager.sharedInstance
        
        XCTAssertFalse(instance1 === instance2)
        
    }

    func testSharedInstance_ThreadSafety() {
        var instance1 : WXManager!
        var instance2 : WXManager!

        //TODO: Thread Safety
    /*    let expectation1 = expectation(description: "Instance 1")
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
        }*/
    }
    
    
}

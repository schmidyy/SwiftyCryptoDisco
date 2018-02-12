//
//  SwiftyCryptoDiscoUnitTests.swift
//  SwiftyCryptoDiscoUnitTests
//
//  Created by Mat Schmid on 2018-02-12.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import XCTest

class SwiftyCryptoDiscoUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testISO8601StringConverter() {
        
        let iso8601Date = "2017-11-05T00:00:00.0000000Z"
        let formattedString: String = iso8601Date.getStringRepresentableFromISO8601String()
        
        XCTAssertEqual(formattedString, "Nov 5 12:00")
    }
    
}

//
//  NewsFeedKitTests.swift
//  NewsFeedKitTests
//
//  Created by Vince on 1/27/17.
//  Copyright © 2017 Vince Davis. All rights reserved.
//

import XCTest
@testable import NewsFeedKit

class NewsFeedKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArticles() {
        let newsfeed = NewsFeedKit()
        newsfeed.getArticles()
    }
}

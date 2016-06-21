//
//  HappiessIsMacTests.swift
//  HappiessIsMacTests
//
//  Created by Brian Ball on 6/20/16.
//  Copyright © 2016 Space-for-Rent. All rights reserved.
//

import XCTest
@testable import HappiessIsMac

class HappiessIsMacTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let game = Game()
        
        game.chicken.destination = CGPoint(x: game.chicken.destination.x + 5, y: game.chicken.destination.y + 5)
        game.update(currentTime: 5)
        XCTAssertEqual(game.eggs.count, 0)
        game.update(currentTime: 6)
        XCTAssertEqual(game.eggs.count, 1)
        XCTAssertEqual(game.eggs[0].hatchAt, 9)
        XCTAssertEqual(game.eggsToHatch(atTime: 9).count, 1)
        
        game.update(currentTime: 9)
        XCTAssertEqual(game.eggs.count, 0)
        XCTAssertEqual(game.chicks.count, 1)
    }
    
}

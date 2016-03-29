//
//  CardinalityTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/26/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit

class CardinalityTestCase: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
	}
	
	override func tearDown() {
		
		super.tearDown()
	}
	
	func testDirectionGenerator() {
		for startingDirection in PrincipalCardinalDirection.cases {
			let max = 25
			var i = 0
			for _ in startingDirection {
				i += 1
				if i >= max {
					break
				}
			}
		}
	}
	
	func testNextDirection() {
		let start = PrincipalCardinalDirection.East
		let cases = start.cases
		XCTAssertEqual(cases.first!, start)
		XCTAssertEqual(cases.last!, PrincipalCardinalDirection.NorthEast)
	}
}

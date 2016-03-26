//
//  SchellingSegregationTests.swift
//  SchellingSegregationTests
//
//  Created by Noah Emmet on 3/26/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit
import SchellingSegregation

class SchellingSegregationTests: XCTestCase {
	var initialWorld: World!
	var worldSequence: WorldSequence!
	
	override func setUp() {
		super.setUp()
		let density = 80
		initialWorld = World(rows: 20, columns: 20, cellType: House.self)
		worldSequence = WorldSequence(initial: initialWorld, maxTicks: 200)
		
		for cell in worldSequence.current.cells {
			let house = cell as! House
			if random() % 100 < density {
				let family = Family()
				family.position = house.position
				house.occupant = family
				worldSequence.current.addAgent(family)
			}
		}
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testIterator() {
		self.measureBlock {
			for _ in self.worldSequence { }
			let happyFamilies = (self.worldSequence.current.agents as! Set<Family>).filter { $0.isHappy }
			print("happy: ", happyFamilies.count)
		}
	}
	
	func testScene() {
		let expectation = self.expectationWithDescription("scene")
		self.waitForExpectationsWithTimeout(1, handler: nil)
		worldSequence.didEnd = { world in
			print("did end")
			expectation.fulfill()
		}
		worldSequence.updater = { world in 
			print("update")
		}
		let view = WorldView(worldSequence: self.worldSequence)
		print("view: ", view.worldScene.size)
		view.scene?.paused = false
		print(view.worldScene.worldSequence)
		XCTAssertTrue(worldSequence === view.worldScene.worldSequence)
		XCTAssertNotNil(view.worldScene.worldSequence.updater)
		//		self.measureBlock {
		
		
		//		}
	}
	
	func testFindNewSpot() {
		self.measureBlock {
			for agent in (self.worldSequence.current.agents as! Set<Family>) {
				agent.findNewSpot(world: self.worldSequence.current)
			}
		}
		
	}
}

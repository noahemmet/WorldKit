//
//  TimelineTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/29/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
@testable import WorldKit

class WorldSequenceTestCase: XCTestCase {
	var worldSequence: WorldSequence!
    override func setUp() {
        super.setUp()
		let firstWorld = World(rows: 10, columns: 10) { gridPoint in
			return Cell()
		}
		worldSequence = WorldSequence(initial: firstWorld, maxTicks: 100)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWorldSequenceUpdater() {
		let delegate = DelegateTester()
		worldSequence.current.delegate = delegate
		self.measureBlock {
			for _ in self.worldSequence {
				self.worldSequence.current.addAgents(10)
			}
		}
    }
	
	func testMove() {
		worldSequence.current.addAgents(1)
		
		let firstPostionX = worldSequence.current.agents.first!.position.x
		for world in worldSequence {
			let agent = world.agents.first!
			agent.move(.Right)
			let _ = world.cellsNearAgent(agent, within: 1)
		}
		let lastPostionX = worldSequence.current.agents.first!.position.x
		XCTAssertNotEqual(firstPostionX, lastPostionX)
		XCTAssertEqual(lastPostionX, 100)
	}
}

private class DelegateTester: WorldDelegate {
	private func world(world: World, didAddAgent agent: Agent) {
//		print(1)
	}
	
	private func world(world: World, didRemoveAgent agent: Agent) {
//		print(1)
	}
}

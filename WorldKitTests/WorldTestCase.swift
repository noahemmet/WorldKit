//
//  WorldTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
@testable import WorldKit

class WorldTestCase: XCTestCase {
	
	var world: World!
	
	override func setUp() {
		super.setUp()
		let grid = Grid(rows: 10, columns: 10)
		world = World(grid: grid)
		
		world.addAgents(8, agentInit: Agent())
		world.addAgents(2, type: Agent.self, configure: nil)
		world.addAgents(5, agentInit: SubAgent())
	}
	
	class SubAgent: Agent { }
	
    func testAddAgents() {
		XCTAssertEqual(world.agents.count, 15)
		XCTAssertEqual(world.agentsOfType(SubAgent).count, 5)
		
		world.addAgents(3, type: Agent.self)
		XCTAssertEqual(world.agents.count, 18)
    }
	
	func testRemoveAgents() {
		let anAgent = world.agentsOfType(Agent.self, limit: 1).first!
		XCTAssertEqual(world.agents.count, 15)
		world.removeAgent(anAgent)
		XCTAssertEqual(world.agents.count, 14)
	}
	
	func testFindAgents() {
		let filteredSubAgents = world.agentsOfType(SubAgent)
		XCTAssertEqual(filteredSubAgents.count, 5)
	}
	
	func testCells() {
		let center = CGPoint(x: 5, y: 5)
		let nearbyCells = world.cellsNearPoint(center, radius: 1)
		XCTAssertEqual(nearbyCells.count, 1) // center and four sides
	}
	
	func testPositionConversion() {
		let position = CGPoint(x: 2.9, y: 2.2)
		let point = world.gridPointForPosition(position)
		XCTAssertEqual(point, GridPoint(row: 2, column: 2))
	}
}
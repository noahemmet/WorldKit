//
//  WorldSceneTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import SpriteKit
@testable import WorldKit

class WorldSceneTestCase: XCTestCase {
	var scene: WorldScene!
	override func setUp() {
		super.setUp()
		let firstWorld = World(rows: 10, columns: 10) { gridPoint in
			return Cell()
		}
		let worldSequence = WorldSequence(initial: firstWorld)
		scene = WorldScene(size: CGSize(width: 40, height: 40), worldSequence: worldSequence) 
	}
	
	func testInit() {
		WorldScene.minimumTimePerUpdate = 0
		XCTAssertEqual(scene.worldSequence.current.agents.count, 0)
		XCTAssertEqual(scene.agentSprites.count, 0)
		scene.worldSequence.current.addAgents(1)
		XCTAssertEqual(scene.worldSequence.current.agents.count, 1)
		XCTAssertEqual(scene.agentSprites.count, 1)
		scene.update(0)
		XCTAssertEqual(scene.worldSequence.current.agents.count, 1)
		XCTAssertEqual(scene.agentSprites.count, 1)
		scene.update(1)
		let agent = scene.worldSequence.current.agents.first!
		scene.worldSequence.current.removeAgent(agent)
		XCTAssertEqual(scene.worldSequence.current.agents.count, 0)
		XCTAssertEqual(scene.agentSprites.count, 0)
		scene.update(2)
		XCTAssertEqual(scene.worldSequence.current.agents.count, 0)
		XCTAssertEqual(scene.agentSprites.count, 0)
	}
}

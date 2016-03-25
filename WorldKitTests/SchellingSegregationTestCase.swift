//
//  SchellingSegregationTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/25/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit

let tolerance: Float = 0.3
let density = 70

var percentSimilar = 100.0
var percentHappy = 100.0

let initialWorld = World(rows: 20, columns: 20, cellType: House.self)
let worldSequence = WorldSequence(initial: initialWorld)

enum FamilyType {
	case One
	case Two
}

class House: Cell {
	weak var occupant: Family?
}

class Family: Agent {
	var type: FamilyType = (rand() % 2 == 0) ? .One : .Two
	var isHappy: Bool = false
	var similarNearbyCount = 0
	var otherNearbyCount = 0
	var totalNearby: Int {
		return similarNearbyCount + otherNearbyCount 
	}
	
	required init() {
		super.init()
		color = (type == .One) ? .blueColor() : .yellowColor()
	}
	
	func findNewSpot(inout world world: World) {
		
		let originalHouse = world.cells[Int(position.x), Int(position.y)] as! House
		var newHouse = originalHouse
		let tries = 100
		for _ in 0..<tries {
			let randomIndex = world.cells.randomIndex
			let newPosition = world.positionForMatrixIndex(randomIndex)
			newHouse = world.cells[Int(newPosition.x), Int(newPosition.y)] as! House
			if newHouse.occupant == nil {
				originalHouse.occupant = nil
				newHouse.occupant = self
				position = newHouse.position
				break
			}
		}
	}
}




class SchellingSegregationTestCase: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
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
	
	func testSegregationIteration() {
		self.measureBlock {
			var allAreHappy: Bool = true
			for world in worldSequence {
				allAreHappy = true
				var totalDisimilarity: Float = 0
				
				for agent in world.agents {
					let family = agent as! Family
					let point = (row: Int(family.position.x), column: Int(family.position.y))
					let nearbyHouses = world.cells[nearPoint: (point.row, point.column), within: 1]
					
					let otherCount = nearbyHouses.filter { cell in
						let house = cell as! House
						let isOther = (house.occupant != nil && house.occupant!.type != family.type)
						return isOther
						}.count
					
					let disimilarityPercent: Float = Float(otherCount) / Float(nearbyHouses.elements.count)
					family.isHappy = disimilarityPercent <= tolerance
					
					if !family.isHappy {
						family.findNewSpot(world: &worldSequence.current)
						allAreHappy = false
					}
					totalDisimilarity += disimilarityPercent
				}
				let totalDisimilarityPercent = totalDisimilarity / Float(world.agents.count)
				
				let totalHappy = world.agents.filter { ($0 as! Family).isHappy }.count
				let percentHappy = Float(totalHappy) / Float(world.agents.count)
				
				if allAreHappy {
					print("ticks: \(worldSequence.tick)")
					print("tolerance: \(tolerance)")
					print("final similarity: \(1 - totalDisimilarityPercent)")
					worldSequence.stop = true
				}
			}
			XCTAssertTrue(allAreHappy)
		}
		
	}
}


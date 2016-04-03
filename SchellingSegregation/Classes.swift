//
//  Classes.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/26/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import WorldKit

public var tolerance: Float = 0.4

public func setup(world world: World, density: Int) {
	for cell in world.cells {
		let house = cell as! House
		if random() % 100 < density {
			let family = Family()
			family.position = house.position
			house.occupant = family
			world.addAgent(family)
		}
	}
	
}

public enum FamilyType {
	case One
	case Two
}

public class House: Cell {
	public weak var occupant: Family?
}

public class Family: Agent {
	public var type: FamilyType = (rand() % 2 == 0) ? .One : .Two
	public var isHappy: Bool = false
	public var similarNearbyCount = 0
	public var otherNearbyCount = 0
	public var disimilarityPercent: Float = 0
	public var totalNearby: Int {
		return similarNearbyCount + otherNearbyCount 
	}
	
	public required init() {
		super.init()
		color = (type == .One) ? .magentaColor() : .yellowColor()
	}
	
	public func findNewSpot(world world: World) {
		let originalHouse = world.cells[Int(position.x), Int(position.y)] as! House
		var tries = 0
		for cell in world.cells.spiral(from: MatrixPoint(row: Int(position.x), column: Int(position.y))) {
			let house = cell as! House
			if house.occupant == nil {
				originalHouse.occupant = nil
				house.occupant = self
				position = house.position
				break
			}
			tries += 1
		}
	}
	
	public override func update(world world: World) {
		let point = (row: Int(position.x), column: Int(position.y))
		let nearbyHouses = world.cells[nearPoint: MatrixPoint(row: point.row, column: point.column), within: 1]
		
		let otherCount = nearbyHouses.filter { cell in
			let house = cell as! House
			let isOther = (house.occupant != nil && house.occupant!.type != self.type)
			return isOther
			}.count
		
		disimilarityPercent = Float(otherCount) / Float(nearbyHouses.elements.count)
		//		print("dis %: ", disimilarityPercent)
		self.isHappy = disimilarityPercent <= tolerance
		
		if !self.isHappy {
			findNewSpot(world: world)
		}
	}
	
	
	//	let totalDisimilarityPercent = totalDisimilarity / Float(world.agents.count)
	//	XCPlaygroundPage.currentPage.captureValue(totalDisimilarityPercent * 1, withIdentifier: "disimilarityPercent")
	//	let totalHappy = world.agents.filter { ($0 as! Family).isHappy }.count
	//	let percentHappy = Float(totalHappy) / Float(world.agents.count)
	//	XCPlaygroundPage.currentPage.captureValue(percentHappy * 1, withIdentifier: "percentHappy")
	//	
	//	if allAreHappy {
	//	print("tolerance: \(tolerance)")
	//	print("final similarity: \(1 - totalDisimilarityPercent)")
	//	worldSequence.stop = true
	//	}
	
	
}

extension World {
	public func percentHappy() -> Float {
		var totalDisimilarity: Float = 0
		var allAreHappy = true
		var numHappy = 0
		for family in agents as! Set<Family> {
			if !family.isHappy {
				allAreHappy = false
			} else {
				numHappy += 1
			}
			totalDisimilarity += family.disimilarityPercent
		}
		let totalDisimilarityPercent = totalDisimilarity / Float(agents.count)
		//			XCPlaygroundPage.currentPage.captureValue(totalDisimilarityPercent * 1, withIdentifier: "disimilarityPercent")
		let percentHappy = Float(numHappy) / Float(agents.count)
		//			XCPlaygroundPage.currentPage.captureValue(percentHappy * 1, withIdentifier: "percentHappy")
		return percentHappy
	}
}
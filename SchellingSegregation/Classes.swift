//
//  Classes.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/26/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import WorldKit

public enum FamilyType {
	case One
	case Two
}

public class House: Cell {
	public weak var occupant: Family?
}

public class Family: Agent {
	public var tolerance: Float = 0.3
	public var type: FamilyType = (rand() % 2 == 0) ? .One : .Two
	public var isHappy: Bool = false
	public var similarNearbyCount = 0
	public var otherNearbyCount = 0
	public var totalNearby: Int {
		return similarNearbyCount + otherNearbyCount 
	}
	
	public required init() {
		super.init()
		color = (type == .One) ? .magentaColor() : .yellowColor()
	}
	
	public func findNewSpot(world world: World) {
		
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
	
	public override func update(world world: World) {
		let point = (row: Int(position.x), column: Int(position.y))
		let nearbyHouses = world.cells[nearPoint: (point.row, point.column), within: 1]
		
		let otherCount = nearbyHouses.filter { cell in
			let house = cell as! House
			let isOther = (house.occupant != nil && house.occupant!.type != self.type)
			return isOther
			}.count
		
		let disimilarityPercent: Float = Float(otherCount) / Float(nearbyHouses.elements.count)
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


//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let tolerance = 0.1

let initialWorld = World(rows: 10, columns: 10, cellType: Cell.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView

enum FamilyType {
	case One
	case Two
}

class Family: Agent {
	var type: FamilyType = (rand() % 2 == 0) ? .One : .Two
	
	func similarity(neighbors neighbors: Set<Family>) -> Double {
		let numTypes: (ones: Int, twos: Int) = neighbors.reduce((0, 0)) { total, family in
			switch family.type {
			case .One: return (total.0 + 1, total.1)
			case .Two: return (total.0,     total.1 + 1)
			}
		}
		
		switch type {
		case .One: return Double(numTypes.ones) / Double(neighbors.count)
		case .Two: return Double(numTypes.twos) / Double(neighbors.count)
		}
	}
	
	func isHappy(neighbors neighbors: Set<Family>) -> Bool {
//		print(self.similarity(neighbors: neighbors))
		return (self.similarity(neighbors: neighbors) >= tolerance)
	}
}

worldSequence.current.addAgents(100, type: Family.self) { family in
	let randomIndex = worldSequence.current.cells.randomIndex
	family.position = worldSequence.current.positionForMatrixIndex(randomIndex)
//	print(worldSequence.current.cells.randomIndex)
}

worldSequence.updater = { world in
	for family in world.agentsOfType(Family) {
		let neighbors = world.agentsNearPosition(family.position, within: 1) as! Set<Family>
		print(neighbors.count)
		if family.isHappy(neighbors: neighbors) {
			family.color = .yellowColor()
		} else {
			family.color = .redColor()
			let randomIndex = world.cells.randomIndex
			family.position = world.positionForMatrixIndex(randomIndex)
		}
	}
}

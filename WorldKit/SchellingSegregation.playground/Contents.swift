//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let tolerance: Float = 0.6
let density = 90

var percentSimilar = 100.0
var percentHappy = 100.0

let initialWorld = World(rows: 30, columns: 30, cellType: House.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView

enum FamilyType {
	case One
	case Two
}

class House: Cell {
	
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
	
//	override func update(world world: World) {
//		
//		
//	}
	
	func findNewSpot(world world: World) {
//		print(position)
//		heading += Degree(random() % 360)
//		move(.Forward)
//		print(position)
		let randomIndex = world.cells.randomIndex
		position = world.positionForMatrixIndex(randomIndex)
//		let house = world.cells[Int(position.x), Int(position.y)] as! House
//		if let _ = house.occupant {
//			findNewSpot(world: world)
//		}
	}
}


for cell in worldSequence.current.cells {
	let house = cell as! House
	if random() % 100 < density {
		let family = Family()
		family.position = house.position
//		house.occupant = family
		worldSequence.current.addAgent(family)
	}
}

worldSequence.updater = { world in
	print("1")
	for family in world.agentsOfType(Family.self) {
		family.similarNearbyCount = world.agentsNearPosition(family.position, within: 1).filter { ($0 as! Family).type == family.type }.count
		family.otherNearbyCount = world.agentsNearPosition(family.position, within: 1).filter { ($0 as! Family).type != family.type }.count
		let similarityPercent: Float = (Float(family.similarNearbyCount) * Float(family.totalNearby) / 100)
		family.isHappy = similarityPercent <= tolerance
		//		print(similarityPercent)
		if !family.isHappy {
			family.findNewSpot(world: world)
		}
	}
}

//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let tolerance: Float = 0.01
let density = 100

var percentSimilar = 100.0
var percentHappy = 100.0

let initialWorld = World(rows: 10, columns: 10, cellType: House.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView

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
		let house = world.cells[Int(position.x), Int(position.y)] as! House
		if let _ = house.occupant {
			findNewSpot(world: world)
			let newHouse = world.cells[Int(position.x), Int(position.y)] as! House
			house.occupant = nil
			newHouse.occupant = self
		}
	}
}


for cell in worldSequence.current.cells {
	let house = cell as! House
	if random() % 100 < density {
		let family = Family()
		family.position = house.position
		house.occupant = family
		worldSequence.current.addAgent(family)
	}
}

worldSequence.updater = { world in
	var allAreHappy = true
	for agent in world.agents {
		let family = agent as! Family
		let point = (row: Int(family.position.x), column: Int(family.position.y))
		let nearbyHouses = world.cells[nearPoint: (point.row, point.column), within: 1]
		for cell in nearbyHouses {
			let house = cell as! House
		}
		
		family.similarNearbyCount = nearbyHouses.filter { ($0 as! House).occupant?.type == family.type }.count
		family.otherNearbyCount   = nearbyHouses.filter { ($0 as! House).occupant?.type != family.type }.count
		let similarityPercent: Float = (Float(family.similarNearbyCount) * Float(family.totalNearby) / 100)
//		print(similarityPercent)
		family.isHappy = similarityPercent <= tolerance
		if !family.isHappy {
			family.findNewSpot(world: world)
			allAreHappy = false
		} else {
//			print("happy")
		}
	}
	if allAreHappy {
		worldSequence.stop = true
	}
}

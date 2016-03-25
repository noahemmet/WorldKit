//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let tolerance: Float = 0.2
let density = 70

var percentSimilar = 100.0
var percentHappy = 100.0

let initialWorld = World(rows: 15, columns: 15, cellType: House.self)
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
	
	func findNewSpot(inout world world: World) {
		//		print(position)
		//		heading += Degree(random() % 360)
		//		move(.Forward)
		let originalHouse = world.cells[Int(position.x), Int(position.y)] as! House
		var newHouse = originalHouse
//		for cell in world.cells {
//			let house = cell as! House
//			if house.occupant == nil {
//				originalHouse.occupant = nil
//				house.occupant = self
//				position = house.position
//				print("moved")
//				break
//			}
//		}
		for _ in 0..<200 {
			let randomIndex = world.cells.randomIndex
			let newPosition = world.positionForMatrixIndex(randomIndex)
			//			print(newPosition)
			newHouse = world.cells[Int(newPosition.x), Int(newPosition.y)] as! House
			if newHouse.occupant == nil {
				originalHouse.occupant = nil
				newHouse.occupant = self
				position = newHouse.position
//				print("moved")
				break
			}
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

//worldSequence.current.addAgents(100, type: Family.self)

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
			family.findNewSpot(world: &world)
			allAreHappy = false
		} else {
//			print("happy")
		}
	}
	if allAreHappy {
		print("all happy")
		worldSequence.stop = true
	}
	
}

print("99")

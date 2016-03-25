//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let tolerance: Float = 0.3
let density = 70

var percentSimilar = 100.0
var percentHappy = 100.0

let initialWorld = World(rows: 20, columns: 20, cellType: House.self)
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
	var totalSimilarity: Float = 0
	var allAreHappy = true
	for agent in world.agents {
		let family = agent as! Family
		let point = (row: Int(family.position.x), column: Int(family.position.y))
		let nearbyHouses = world.cells[nearPoint: (point.row, point.column), within: 1]
		
		let otherCount = nearbyHouses.filter { cell in
			let house = cell as! House
			let isOther = (house.occupant != nil && house.occupant!.type != family.type)
			return isOther
			}.count
		
		let similarityPercent: Float = Float(otherCount) / Float(nearbyHouses.elements.count)
		family.isHappy = similarityPercent <= tolerance
		
		if !family.isHappy {
			family.findNewSpot(world: &world)
			allAreHappy = false
		}
		totalSimilarity += similarityPercent
	}
	let totalSimilarityPercent = totalSimilarity / Float(world.agents.count)
//	print(totalSimilarityPercent)
	XCPlaygroundPage.currentPage.captureValue(totalSimilarityPercent * 1, withIdentifier: "similarityPercent")

	if allAreHappy {
		print("all happy")
		worldSequence.stop = true
	}
}

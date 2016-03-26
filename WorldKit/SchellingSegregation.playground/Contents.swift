//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit
import SchellingSegregation

//let tolerance: Float = 0.3
let density = 70

//var percentSimilar = 100.0
//var percentHappy = 100.0

let initialWorld = World(rows: 20, columns: 20, cellType: House.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView


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
	print("tick")
//	var totalDisimilarity: Float = 0
//	var allAreHappy = true
//	for agent in world.agents {
//		let family = agent as! Family
//		let point = (row: Int(family.position.x), column: Int(family.position.y))
//		let nearbyHouses = world.cells[nearPoint: (point.row, point.column), within: 1]
//		
//		let otherCount = nearbyHouses.filter { cell in
//			let house = cell as! House
//			let isOther = (house.occupant != nil && house.occupant!.type != family.type)
//			return isOther
//			}.count
//		
//		let disimilarityPercent: Float = Float(otherCount) / Float(nearbyHouses.elements.count)
//		family.isHappy = disimilarityPercent <= tolerance
//		
//		if !family.isHappy {
//			family.findNewSpot(world: &world)
//			allAreHappy = false
//		}
//		totalDisimilarity += disimilarityPercent
//	}
//	let totalDisimilarityPercent = totalDisimilarity / Float(world.agents.count)
//	XCPlaygroundPage.currentPage.captureValue(totalDisimilarityPercent * 1, withIdentifier: "disimilarityPercent")
//	let totalHappy = world.agents.filter { ($0 as! Family).isHappy }.count
//	let percentHappy = Float(totalHappy) / Float(world.agents.count)
//	XCPlaygroundPage.currentPage.captureValue(percentHappy * 1, withIdentifier: "percentHappy")
//	
//	if allAreHappy {
//		print("tolerance: \(tolerance)")
//		print("final similarity: \(1 - totalDisimilarityPercent)")
//		worldSequence.stop = true
//	}
}

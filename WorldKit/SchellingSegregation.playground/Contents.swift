//: Playground - noun: a place where people can play

import WorldKit
import XCPlayground
import SchellingSegregation

tolerance = 0.5
let density = 85

//var percentSimilar = 100.0
//var percentHappy = 100.0
WorldScene.minimumTimePerUpdate = 0.1

let initialWorld = World(rows: 50, columns: 50, cellType: House.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView

setup(world: worldSequence.current, density: density)

worldSequence.updater = { world in
	let happy = world.percentHappy()
	print(happy)
	if happy >= 1.0 {
		print("happy")
		worldSequence.stop = true
	}
}
//	var totalDisimilarity: Float = 0
//	var allAreHappy = true
//	var numHappy = 0
//	for family in world.agents as! Set<Family> {
//		if !family.isHappy {
//			allAreHappy = false
//		} else {
//			numHappy += 1
//		}
//		totalDisimilarity += family.disimilarityPercent
//	}
//	let totalDisimilarityPercent = totalDisimilarity / Float(world.agents.count)
//	XCPlaygroundPage.currentPage.captureValue(totalDisimilarityPercent * 1, withIdentifier: "disimilarityPercent")
//	let percentHappy = Float(numHappy) / Float(world.agents.count)
//	XCPlaygroundPage.currentPage.captureValue(percentHappy * 1, withIdentifier: "percentHappy")
//	
//	if allAreHappy {
////		print("tolerance: \(family.tolerance)")
//		print("final similarity: \(1 - totalDisimilarityPercent)")
//		worldSequence.stop = true
//	}
//}

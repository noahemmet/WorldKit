//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

let grassGrowthTime = 10
let sheepReproduceProbability = 0.5
let initialNumSheep = 50

let initialWorld = World(rows: 10, columns: 10, cellType: Grass.self)
let worldSequence = WorldSequence(initial: initialWorld)
let worldView = WorldView(worldSequence: worldSequence)

XCPlaygroundPage.currentPage.liveView = worldView

class Sheep: Agent {
	//	var color = Color.whiteColor()
	var energy: Float = 100
	func eatGrass(grass: Grass) -> Bool {
		if grass.beEaten() {
			energy = 100
			return true
		}
		return false
	}
	
	func live() {
		energy -= 35
	}
	
	override func update() {
		live()
	}
}

class Grass: Cell {
	var growthInterval = Int(arc4random_uniform(70))
	var regrowthTime = 50
	
	override func update() {
		grow()
	}
	
	func grow() {
		if growthInterval < regrowthTime {
			growthInterval += 1
			color = .brownColor()
//			color = color.colorWithAlphaComponent(color.alphaComponent - 0.05)
		} else {
			color = .greenColor()
//			color = color.colorWithAlphaComponent(1)
		}
	}
	
	func beEaten() -> Bool {
		if growthInterval >= regrowthTime {
			growthInterval = 0
			return true
		} else {
			return false
		}
	}
}

worldSequence.current.addAgents(10, type: Sheep.self)

//sheep.position = CGPoint(x: 1, y: 1)
//sheep.color = .whiteColor()
worldSequence.updater = { world in
	var sheep = worldSequence.current.agentsOfType(Sheep).first
	if let sheep = sheep {
		sheep.position.y += 0.1
		sheep.position.x += 0.1
		for nearbyGrass in world.cellsNearAgent(sheep) as! Set<Grass> {
			if sheep.energy < 50 {
				if sheep.eatGrass(nearbyGrass) {
					break
				}
			}
		}
		if sheep.energy <= 0 {
			print("Die")
			sheep.color = .redColor()
			worldSequence.current.removeAgent(sheep)
		}
		XCPlaygroundPage.currentPage.captureValue(sheep.energy, withIdentifier: "energy")
	}
	//	print(world.agentsOfType(Sheep).count)
	//		print(sheep.position)
}

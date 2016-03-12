//: Playground - noun: a place where people can play

import XCPlayground
import WorldKit

setup(rows: 10, columns: 10, maxTicks: 10)
let canvasView = CanvasView()

XCPlaygroundPage.currentPage.liveView = canvasView

class Turtle: Agent {
	
}

//timeline.current.addAgents(1, agentInit: Agent())
worldSequence.current.addAgents(20, type: Turtle.self) { agent in 
	agent.position = CGPoint(x: 3, y: 1)
	agent.color = .yellowColor()
}

worldSequence.current.addAgents(0) { agent in
	agent.position = CGPoint(x: 1, y: 1)
	agent.color = .orangeColor()
}
let first = worldSequence.current.agentsOfType(Turtle).first!
let cell = worldSequence.current.cellsNearPoint(CGPoint(x: 0, y: 0), radius: 1).first
cell?.color = .blackColor()
var sameCellInARow = 1
worldSequence.updater = { world in
	
//	world.agentsOfType(Turtle).randomElement().position.x += 0.1
	let turtles = world.agentsOfType(Turtle.self, limit: 15)
	turtles.forEach { $0.heading += 0.2 }
	turtles.forEach { $0.move(.Left, distance: 0.2) }
	first.color = .whiteColor()
	let cells = world.cellsNearAgent(first, radius: 1)
	for cell in cells {
		if sameCellInARow > 0 && sameCellInARow < 50 {
			sameCellInARow += 1
			cell.color = .greenColor()
		} else if sameCellInARow < 0 && sameCellInARow > -50 {
			sameCellInARow -= 1
			cell.color = .blueColor()
		} else if sameCellInARow > 0 {
			sameCellInARow = -1
		} else if sameCellInARow < 0 {
			sameCellInARow = 1
		}
	}
//	first.moveTowardsAgent(cells.first!)
}

settings.addSetting(Toggle())

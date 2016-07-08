//
//  World.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import SpriteKit
import Grid

protocol WorldDelegate: class {
	func world(_ world: World, didAddAgent agent: Agent)
	func world(_ world: World, didRemoveAgent agent: Agent)
}

public class World {
	weak var delegate: WorldDelegate?
//	typealias CellType = Cell
	
	public var agents: Set<Agent>
	public var cells: Grid<Cell>
	
	public init<C: Cell>(rows: Int, columns: Int, cellForPoint: (gridPoint: GridPoint) -> C) {
		self.agents = []
		self.cells = Grid(rows: rows, columns: columns) { (row, column) in
			let cell = cellForPoint(gridPoint: GridPoint(row: row, column: column))
			cell.position = CGPoint(x: row, y: column)
			return cell
		}
	}
	
	public convenience init<C: Cell>(rows: Int, columns: Int, cellType: C.Type) {
		self.dynamicType.init(rows: rows, columns: columns) { _ in
			return C.init()
		}
	}
	
	public convenience init(rows: Int, columns: Int) {
		self.init(rows: rows, columns: columns, cellType: Cell.self)
	}
	
	// MARK: - Positions
	
	public func gridPointForPosition(_ position: CGPoint) -> GridPoint {
		let x = Int(position.x)
		let y = Int(position.y)
		return GridPoint(row: x, column: y)
	}
	
	public func positionForGridPoint(_ index: GridPoint) -> CGPoint {
		return CGPoint(x: index.row, y: index.column)
	}
	
	// MARK: - Adding Agents
	
	public func addAgent(_ agent: Agent) {
		agents.insert(agent)
		delegate?.world(self, didAddAgent: agent)
	}
	
	public func addAgents<A: Agent>(_ number: Int, @autoclosure agentInit: () -> A) {
		for _ in 0 ..< number {
			let agent = agentInit()
			addAgent(agent)
			delegate?.world(self, didAddAgent: agent)
		}
	}
	
	public func addAgents<A: Agent>(_ number: Int, type: A.Type = A.self, configure: ((A) -> Void)? = nil) {
		let agents = (0..<number).map { _ in A.init() }
		for agent in agents {
			configure?(agent)
			addAgent(agent)
		}
	}
	
	// MARK: - Removing Agents
	
	public func removeAgent(_ agent: Agent) {
//		print(agents.count)
		agents.remove(agent)
//		print(agents.count)
		delegate?.world(self, didRemoveAgent: agent)
	}
	
	// MARK: - Finding Agents
	
	public func agentsOfType<A: Agent>(_ agentType: A.Type, limit: Int? = nil) -> Set<A> {
		if agentType == Agent.self {
			return agents as! Set<A>
		}
		let filtered = agents.filter { agent in 
			let same = (agent is A)
			return same
			} as! [A]
		
		if let limit = limit where filtered.count > 0 {
			let newLimit = min(filtered.count, limit)
			let limited = filtered.randomized[0..<newLimit]
			return Set(limited)
		}
		return Set(filtered.randomized[0..<filtered.count])
	}
	
	public func agentsNearPosition(_ position: CGPoint, within: Int = 1) -> Set<Agent> {
		let gridPoint = GridPoint(row: Int(position.x), column: Int(position.y))
		let filtered = cells[nearPoint: gridPoint, within: within]
		var agents: [Agent] = []
		for cell in filtered {
			let matchingAgents = self.agents.filter { agent in
				let within = CGFloat(within)
				let rangeX = (cell.position.x - within) ..< (cell.position.x + within)
				let rangeY = (cell.position.y - within) ..< (cell.position.y + within)
				
				let withinX = rangeX ~= agent.position.x
				let withinY = rangeY ~= agent.position.y
//				print(rangeX)
//				print(agent.position.x)
//				print(withinX)
				return withinX && withinY
			}
				
			agents.appendContentsOf(matchingAgents)
		}
		return Set(agents)
	}
	
	// MARK: - Finding Cells
	
	public func cellsNearPoint(_ point: CGPoint, radius: CGFloat, limit: Int? = nil) -> Set<Cell> {
		let filtered = cells.filter { return $0.position.distanceToPoint(point) < radius }
		let flattened = filtered.flatMap { $0 }
		return Set(flattened)
	}
	
	public func cellsNearAgent(_ agent: Agent, radius: CGFloat) -> Set<Cell> {
		return cellsNearPoint(agent.position, radius: radius)
	}
	
	public func cellsNearPoint(_ point: GridPoint, within: Int = 1) -> Set<Cell> {
		let filtered = cells[nearPoint: point, within: within]
		return Set(filtered.elements)
	}
	
	public func cellsNearAgent(_ agent: Agent, within: Int = 1) -> Set<Cell> {
		let point = gridPointForPosition(agent.position)
		return cellsNearPoint(point, within: within)
	}
}

//extension World: CustomPlaygroundQuickLookable {
//	public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
//		let sequence = WorldSequence(initial: self)
//		let worldView = WorldView(worldSequence: sequence)
//		return PlaygroundQuickLook.View(worldView)
//	}
//}

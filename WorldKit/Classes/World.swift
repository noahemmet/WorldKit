//
//  World.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

protocol WorldDelegate: class {
	func world(world: World, didAddAgent agent: Agent)
	func world(world: World, didRemoveAgent agent: Agent)
}

public struct World {
	weak var delegate: WorldDelegate?
	
	var agents: Set<Agent>
	public var cells: Matrix<Cell>
	
	public init<C: Cell>(rows: Int, columns: Int, cellForPoint: (gridPoint: MatrixIndex) -> C) {
		self.agents = []
		self.cells = Matrix(rows: rows, columns: columns) { (row, column) in
			let cell = cellForPoint(gridPoint: (row, column))
			cell.position = CGPoint(x: row, y: column)
			return cell
		}
	}
	
	public init<C: Cell>(rows: Int, columns: Int, cellType: C.Type) {
		self.init(rows: rows, columns: columns) { _ in
			return C.init()
		}
	}
	
	public init(rows: Int, columns: Int) {
		self.init(rows: rows, columns: columns, cellType: Cell.self)
	}
	
	// MARK: - Positions
	
	public func gridPointForPosition(position: CGPoint) -> MatrixIndex {
		let x = Int(position.x)
		let y = Int(position.y)
		return (row: x, column: y)
	}
	
	public func positionForMatrixIndex(index: MatrixIndex) -> CGPoint {
		return CGPoint(x: index.row, y: index.column)
	}
	
	// MARK: - Adding Agents
	
	public mutating func addAgent(agent: Agent) {
		agents.insert(agent)
		delegate?.world(self, didAddAgent: agent)
	}
	
	public mutating func addAgents<A: Agent>(number: Int, @autoclosure agentInit: () -> A) {
		for _ in 0 ..< number {
			let agent = agentInit()
			addAgent(agent)
			delegate?.world(self, didAddAgent: agent)
		}
	}
	
	public mutating func addAgents<A: Agent>(number: Int, type: A.Type = A.self, configure: (A -> Void)? = nil) {
		let agents = (0..<number).map { _ in A.init() }
		for agent in agents {
			configure?(agent)
			addAgent(agent)
		}
	}
	
	// MARK: - Removing Agents
	
	public mutating func removeAgent(agent: Agent) {
//		print(agents.count)
		agents.remove(agent)
//		print(agents.count)
		delegate?.world(self, didRemoveAgent: agent)
	}
	
	// MARK: - Finding Agents
	
	public func agentsOfType<A: Agent>(agentType: A.Type, limit: Int? = nil) -> Set<A> {
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
	
	public func agentsNearPosition(position: CGPoint, within: Int = 1) -> Set<Agent> {
		let matrixIndex = (Int(position.x), Int(position.y))
		let filtered = cells[nearPoint: matrixIndex, within: within]
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
	
	public func cellsNearPoint(point: CGPoint, radius: CGFloat, limit: Int? = nil) -> Set<Cell> {
		let filtered = cells.filter { return $0.position.distanceToPoint(point) < radius }
		let flattened = filtered.flatMap { $0 }
		return Set(flattened)
	}
	
	public func cellsNearAgent(agent: Agent, radius: CGFloat) -> Set<Cell> {
		return cellsNearPoint(agent.position, radius: radius)
	}
	
	public func cellsNearPoint(point: MatrixIndex, within: Int = 1) -> Set<Cell> {
		let filtered = cells[nearPoint: point, within: within]
		return Set(filtered.elements)
	}
	
	public func cellsNearAgent(agent: Agent, within: Int = 1) -> Set<Cell> {
		let point = gridPointForPosition(agent.position)
		return cellsNearPoint(point, within: within)
	}
}

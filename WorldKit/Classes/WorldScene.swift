//
//  WorldScene.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import SpriteKit

public class WorldScene: SKScene {
	
	public static var minimumTimePerUpdate: NSTimeInterval = 0.3
	var previousUpdate: NSTimeInterval = 0
	
	public var cellSprites: Matrix<CellSprite>!
	public var agentSprites: Set<AgentSprite>
	
	public var cellSize: CGSize = CGSize.zero
	public var agentSize: CGSize = CGSize.zero
	public let worldSequence: WorldSequence
	private lazy var generator: AnyGenerator<World> = self.worldSequence.generate()
	
	public init(size: CGSize, worldSequence: WorldSequence) {
		self.worldSequence = worldSequence
		self.agentSprites = []
		super.init(size: size)
		let initialWorld = worldSequence.current
		cellSize = CGSize(width: frame.size.width / CGFloat(initialWorld.cells.columns), height: frame.size.height / CGFloat(initialWorld.cells.rows))
		agentSize = CGSize(width: cellSize.width / 2, height: cellSize.height / 2)
		
		var red:  CGFloat = 0.2
		var blue: CGFloat = 0.8
		let colorIncrement: CGFloat = 0.6 / CGFloat(initialWorld.cells.rows * initialWorld.cells.columns)
		cellSprites = Matrix<CellSprite>(rows: initialWorld.cells.rows, columns: initialWorld.cells.columns) { (row, column) in
			let cell = initialWorld.cells[row, column]
			let flipColor = (row % 2 + column % 2) % 2 == 0 
			cell.color = NSColor(white: flipColor ? 0.2 : 0.3, alpha: 1)
			let cellSprite = CellSprite(agent: cell, size: self.cellSize)
			self.configureAgentSprite(cellSprite, forAgent: cell, duration: 0)
			self.addChild(cellSprite)
			red += colorIncrement
			blue -= colorIncrement
			return cellSprite
		}
		worldSequence.current.delegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func cellSpriteForGridPoint(point: MatrixPoint) -> CellSprite {
		return cellSprites[point.column, point.row]
	}
	
	func positionForGridPosition(position: CGPoint) -> CGPoint {
		let x = position.x * cellSize.width + (cellSize.width / 2)
		let y = position.y * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	func positionForGridPoint(point: MatrixPoint) -> CGPoint {
		let x = CGFloat(point.column) * cellSize.width + (cellSize.width / 2)
		let y = CGFloat(point.row) * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	public func spritePositionForAgentPosition(agentPosition: CGPoint) -> CGPoint {
		let x = CGFloat(agentPosition.x) * cellSize.width + (cellSize.width / 2)
		let y = CGFloat(agentPosition.y) * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	public override func update(currentTime: NSTimeInterval) {
		super.update(currentTime)
		
		let diffSeconds = currentTime - previousUpdate
		
		if diffSeconds > WorldScene.minimumTimePerUpdate {
			previousUpdate = currentTime
			if let next = generator.next() {
				configureWorld(next)
			}
		}
	}
	
	internal func configureWorld(world: World, duration: NSTimeInterval = WorldScene.minimumTimePerUpdate) {
		for point in world.cells.enumerate() {
			let gridPoint = world.cells.gridPointOfIndex(point.index)
			let cell = world.cells[gridPoint.column, gridPoint.row]
			let cellSprite = cellSprites[gridPoint.row, gridPoint.column]
			configureAgentSprite(cellSprite, forAgent: cell, duration: duration)
		}
		
		for agent in world.agents {
			if let sprite = (agentSprites.filter { $0.uuid == agent.uuid }).first {
				configureAgentSprite(sprite, forAgent: agent, duration: duration)
			}
		}
	}
	
	internal func configureAgentSprite(agentSprite: AgentSprite, forAgent agent: Agent, duration: NSTimeInterval) {
		agentSprite.color = agent.color
		let newPosition = positionForGridPosition(agent.position)
		
		if duration > 0 && worldSequence.tick > 1 {
			agentSprite.removeActionForKey("move")
			let moveTo = SKAction.moveTo(newPosition, duration: duration)
			moveTo.duration = duration
			agentSprite.runAction(moveTo, withKey: "move")
		} else {
			agentSprite.position = newPosition
		}
		
	}
}

extension WorldScene: WorldDelegate {
	
	func world(world: World, didAddAgent agent: Agent) {
		let agentSprite = AgentSprite(agent: agent, size: agentSize)
		addChild(agentSprite)
		agentSprites.insert(agentSprite)
		configureAgentSprite(agentSprite, forAgent: agent, duration: 0)
	}
	
	func world(world: World, didRemoveAgent agent: Agent) {
		let sprite = agentSprites.filter { $0.uuid == agent.uuid }.first!
		agentSprites.remove(sprite)
		removeChildrenInArray([sprite])
	}

}
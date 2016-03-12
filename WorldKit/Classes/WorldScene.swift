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
	
	public var cellSprites: [[CellSprite]] = [[]]
	public var agentSprites: Set<AgentSprite> {
		let sprites = children.filter { $0 is AgentSprite && !($0 is CellSprite) } as! [AgentSprite]
		return Set(sprites)
	}
	public var cellSize: CGSize = CGSize.zero
	public var agentSize: CGSize = CGSize.zero
	public let worldSequence: WorldSequence
	public var generator: AnyGenerator<World>
	
	public init(size: CGSize, worldSequence: WorldSequence) {
		self.worldSequence = worldSequence
		self.generator = worldSequence.generate()
		super.init(size: size)
		let initialWorld = worldSequence.current
		cellSize = CGSize(width: frame.size.width / CGFloat(initialWorld.cells.columns), height: frame.size.height / CGFloat(initialWorld.cells.rows))
		agentSize = CGSize(width: cellSize.width / 2, height: cellSize.height / 2)
		var red:  CGFloat = 0.2
		var blue: CGFloat = 0.8
		let colorIncrement: CGFloat = 0.6 / CGFloat(initialWorld.cells.rows * initialWorld.cells.columns)
		
		for point in initialWorld.cells.enumerate() {
			let gridPoint = initialWorld.cells.gridPointOfIndex(point.index)
			if gridPoint.row == 0 {
				cellSprites.append([])
			}
			let cell = initialWorld.cells[gridPoint.column, gridPoint.row]
			cell.color = NSColor(red: red, green: 0.2, blue: blue, alpha: 1)
			let cellSprite = CellSprite(agent: cell, size: cellSize)
			cellSprites[gridPoint.column].append(cellSprite)
//			cellSprite.position = positionForGridPoint(point)
			configureAgentSprite(cellSprite, forAgent: cell, duration: 0)
			addChild(cellSprite)
			red += colorIncrement
			blue -= colorIncrement
		}
		worldSequence.current.delegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func cellSpriteForGridPoint(point: GridPoint) -> CellSprite {
		return cellSprites[point.column][point.row]
	}
	
	func positionForGridPosition(position: CGPoint) -> CGPoint {
		let x = position.x * cellSize.width + (cellSize.width / 2)
		let y = position.y * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	func positionForGridPoint(point: GridPoint) -> CGPoint {
		let x = CGFloat(point.column) * cellSize.width + (cellSize.width / 2)
		let y = CGFloat(point.row) * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	public func spritePositionForAgentPosition(agentPosition: CGPoint) -> CGPoint {
		let x = CGFloat(agentPosition.x) * cellSize.width + (cellSize.width / 2)
		let y = CGFloat(agentPosition.y) * cellSize.height + (cellSize.height / 2)
		return CGPoint(x: x, y: y)
	}
	
	static var minimumTimePerUpdate: NSTimeInterval = 0.05
	var previousUpdate: NSTimeInterval = 0
	public override func update(currentTime: NSTimeInterval) {
		super.update(currentTime)
		let diffSeconds = currentTime - previousUpdate
		if diffSeconds > WorldScene.minimumTimePerUpdate {
			previousUpdate = currentTime
			if let next = generator.next() {
				configureWorld(next)
			}
//			if let next = worldSequence.next {
////				worldSequence.current.delegate = self
//				next(world: worldSequence.current)
////				worldSequence.current.delegate = self
//				configureWorld(worldSequence.current)
//			}
		}
	}
	
	internal func configureWorld(world: World, duration: NSTimeInterval = WorldScene.minimumTimePerUpdate) {
		for point in world.cells.enumerate() {
			let gridPoint = world.cells.gridPointOfIndex(point.index)
			let cell = world.cells[gridPoint.column, gridPoint.row]
			let cellSprite = cellSprites[gridPoint.row][gridPoint.column]
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
		if duration > 0 {
			agentSprite.runAction(SKAction.moveTo(newPosition, duration: duration))
		} else {
			agentSprite.position = newPosition
		}
		
	}
}

extension WorldScene: WorldDelegate {
	func world(world: World, didAddAgent agent: Agent) {
//		print(agent)
//		print("did add")
		let agentSprite = AgentSprite(agent: agent, size: agentSize)
		addChild(agentSprite)
		configureAgentSprite(agentSprite, forAgent: agent, duration: 0)
	}
	
	func world(world: World, didRemoveAgent agent: Agent) {
		let sprite = agentSprites.filter { $0.uuid == agent.uuid }.first!
		removeChildrenInArray([sprite])
	}

}
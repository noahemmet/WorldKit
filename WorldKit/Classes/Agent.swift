//
//  Agent.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

//public typealias Position = (x: Int, y: Int)

private var uuidCounter: UInt64 = 0

public class Agent: PositionTrait {
	internal let uuid: UInt64
	public var name: String = ""
	public var position: CGPoint = CGPoint(x: 0, y: 0)
	public var heading: Degree = 0
	public var color: Color = Color.whiteColor()
	public required  init() {
		uuid = uuidCounter
		uuidCounter += 1
	}
	
	public func update(world world: World) {
		
	}
}

extension Agent {
	public func move(direction: RelativeDirection, distance: CGFloat = 1) {
		let x = position.x + distance * sin(heading + direction.degrees.radians)
		let y = position.y + distance * cos(heading + direction.degrees.radians)
		position = CGPoint(x: x, y: y)
	}
	
	public func moveTowardsAgent(agent: Agent, distance: CGFloat = 1, adjustHeading: Bool = true) {
		moveTowardsPoint(agent.position, distance: distance, adjustHeading: adjustHeading)
	}
	
	public func moveTowardsPoint(point: CGPoint, distance: CGFloat = 1, adjustHeading: Bool = true) {
		let vector = CGPoint(x: point.x - self.position.x, y: point.y - self.position.y)
		let unitVector = CGPoint(x: vector.x / distance, y: vector.y / distance)
		self.position = CGPoint(x: self.position.x + unitVector.x * distance, y: self.position.y + unitVector.y * distance)
////		var vector = new Point(b.X - a.X, b.Y - a.Y);
////		var length = Math.Sqrt(vector.X * vector.X + vector.Y * vector.Y);
//		var unitVector = new Point(vector.X / length, vector.Y / length);
//		return new Point(a.X + unitVector.X * distance, a.Y + unitVector.Y * distance);
	}
}

extension Agent: Hashable {
	public var hashValue: Int {
		return uuid.hashValue
	}
}

public func ==(lhs: Agent, rhs: Agent) -> Bool {
	return lhs.uuid == rhs.uuid
}

// MARK: Traits

public protocol PositionTrait {
	var position: CGPoint { get set }
}

public protocol NameTrait {
	var name: String { get set }
}


//extension Agent: CustomPlaygroundQuickLookable {
//	public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
//		let view = NSView(frame: Rect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
//		view.wantsLayer = true
//		view.layer?.backgroundColor = color.CGColor
//		return PlaygroundQuickLook.View(view)
////		let sprite = AgentSprite(agent: self, size: CGSize(width: 20, height: 20))
////		sprite.color = color
////		print(sprite)
////		print(sprite.frame)
////		return PlaygroundQuickLook.Sprite(sprite)
//	}
//}

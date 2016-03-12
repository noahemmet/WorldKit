//
//  WorldSequence.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/5/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class WorldSequence: SequenceType {
	public var previous: World?
	public var current: World
	public var updater: ((world: inout World) -> Void)?
	public let maxTicks: Int64?
	public var tick: Int64 = 0
	
	public init(initial: World, maxTicks: Int64? = 1000) {
		self.current = initial
		self.maxTicks = maxTicks
	}
	
	public func generate() -> AnyGenerator<World> {
		return AnyGenerator<World> {
			guard self.tick < self.maxTicks else {
				return nil
			}
			self.current.cells.forEach { $0.update() }
			self.current.agents.forEach { $0.update() }
			self.updater?(world: &self.current)
			self.tick += 1
			return self.current
		}
	}
}
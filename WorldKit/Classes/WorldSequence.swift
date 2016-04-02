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
	public var didEnd: ((world: World) -> Void)?
	public var updater: ((world: World) -> Void)?
	public let maxTicks: Int64?
	public private(set) var tick: Int64 = 0
	public var stop = false
	public var seed: UInt32 = 0 {
		didSet {
			srand(seed)
		}
	}
	
	public init(initial: World, maxTicks: Int64? = 1000) {
		self.current = initial
		self.maxTicks = maxTicks
	}
	
	public func generate() -> AnyGenerator<World> {
		return AnyGenerator<World> {
			guard self.tick < self.maxTicks && !self.stop else {
				self.didEnd?(world: self.current)
				return nil
			}
//			print("num cells: ", self.current.cells.elements.count)
			self.current.cells.forEach { $0.update(world: self.current) }
			self.current.agents.forEach { $0.update(world: self.current) }
			self.updater?(world: self.current)
//			print("updater: ", self.updater)
			self.tick += 1
			return self.current
		}
	}
}
//
//  ArrayExtensions.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/27/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift
public extension Array {
	var randomized: [Element] {
		var elements = self
		for index in indices {
			let anotherIndex = Int(arc4random_uniform(UInt32(elements.count - index))) + index
			anotherIndex != index ? swap(&elements[index], &elements[anotherIndex]) : ()
		}
		return elements
	}
	mutating func randomize() {
		self = randomized
	}
	var chooseOne: Element {
		return self[Int(arc4random_uniform(UInt32(count)))]
	}
	func random(limit limit: Int) -> [Element] {
		return Array(randomized.prefix(limit))
	}
}

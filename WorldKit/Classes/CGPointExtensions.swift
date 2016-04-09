//
//  CGPointExtensions.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/27/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPoint {
	func distanceToPoint(point: CGPoint) -> CGFloat {
		let dx = point.x - x
		let dy = point.y - y
		let distance = sqrt(dx*dx + dy*dy)
		return distance
	}
}
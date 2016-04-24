//
//  SetExtensions.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/27/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public extension Set { 
	func randomElement() -> Element? { 
		let n = Int(arc4random_uniform(UInt32(count)))
		let i = startIndex.advanced(by: n)
		return n < self.count ? self[i] : nil
	}
}
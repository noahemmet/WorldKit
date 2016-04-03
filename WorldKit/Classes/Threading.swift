//
//  Threading.swift
//  WorldKit
//
//  Created by Noah Emmet on 4/3/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public typealias Closure = () -> Void

public func async(background: Closure, _ main: Closure?) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
		background()
		dispatch_async(dispatch_get_main_queue()) {
			main?()
		}
	}
}
//
//  Threading.swift
//  WorldKit
//
//  Created by Noah Emmet on 4/3/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public typealias Closure = () -> Void

public func async(_ background: Closure, _ main: Closure?) {
	DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async {
		background()
		DispatchQueue.main.async {
			main?()
		}
	}
}

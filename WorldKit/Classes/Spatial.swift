//
//  Units.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/29/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public typealias Degree = CGFloat
public typealias Radian = CGFloat

extension Degree {
	var radians: Radian {
		return self * CGFloat(M_PI) / 180
	}
}

public enum RelativeDirection {
	case Forward
	case Backward
	case Left
	case Right
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .Forward:  degrees =   0
		case .Backward: degrees = 180
		case .Right:		degrees =  90
		case .Left:		degrees = 270
		}
		return degrees
	}
}

public enum AbsoluteDirection {
	case North
	case East
	case South
	case West
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .North: degrees =   0
		case .East:  degrees =  90
		case .South: degrees = 180
		case .West:  degrees = 270
		}
		return degrees
	}
}
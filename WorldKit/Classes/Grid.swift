//
//  Grid.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public struct GridPoint {
	public var row: Int
	public var column: Int
	init(row: Int, column: Int) {
		self.row = row
		self.column = column
	}
}

extension GridPoint: Hashable {
	public var hashValue: Int {
		return row.hashValue * column.hashValue
	}
}

public func ==(lhs: GridPoint, rhs: GridPoint) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}


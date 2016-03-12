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

public struct Grid {
	public let rows: Int
	public let columns: Int
	public init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
	}
}


// MARK: - SequenceType / SequenceType

extension Grid: SequenceType {
	public func generate() -> AnyGenerator<GridPoint> {
		var isFirstElement = true
		var nextPoint: GridPoint = GridPoint(row: 0, column: 0)
		return AnyGenerator<GridPoint> {
			if isFirstElement {
				isFirstElement = false
				return nextPoint
			}
			
			if nextPoint.row == self.rows - 1 && nextPoint.column == self.columns - 1 {
				// last row in last column
				return nil
			} else if nextPoint.row == self.rows - 1 {
				// last row in a column
				nextPoint.row = 0
				nextPoint.column += 1
			} else {
				// a row in a column
				nextPoint.row += 1
			}
			
			return nextPoint
		}
	}
}

//
//  CellGrid.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/6/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public struct CellGrid {
	public var cells: [[Cell]] = [[]]
	
	public init(cells: [[Cell]]) {
		self.cells = cells
	}
	
	public subscript(row: Int, column: Int) -> Cell {
		return cells[row][column]
	}
}

extension CellGrid: SequenceType {
	public func generate() -> AnyGenerator<Cell> {
		var isFirstElement = true
		var nextPoint: GridPoint = GridPoint(row: 0, column: 0)
		return AnyGenerator<Cell> {
			if isFirstElement {
				isFirstElement = false
				return self[nextPoint.row, nextPoint.column]
			}
			
			if nextPoint.row == self.cells.count - 1 && nextPoint.column == self.cells.first!.count - 1 {
				// last row in last column
				return nil
			} else if nextPoint.row == self.cells.count - 1 {
				// last row in a column
				nextPoint.row = 0
				nextPoint.column += 1
			} else {
				// a row in a column
				nextPoint.row += 1
			}
			
			return self[nextPoint.row, nextPoint.column]
		}
	}
}

//
//  Matrix.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/11/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public typealias MatrixIndex = (row: Int, column: Int)

public func ==(lhs: (row: Int, column: Int), rhs: (row: Int, column: Int)) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}

public struct Matrix<T: Hashable> {
	public typealias Element = T
	public let rows: Int
	public let columns: Int
	var elements: [Element]
	
	public init() {
		self.rows = 0
		self.columns = 0
		self.elements = []
	}
	
	public init(rows: Int, columns: Int, repeatedValue: Element) {
		self.rows = rows
		self.columns = columns
		self.elements = Array<Element>(count: rows * columns, repeatedValue: repeatedValue)
	}
	
	public init(rows: Int, columns: Int, elementInit: (row: Int, column: Int) -> Element) {
		self.rows = rows
		self.columns = columns
		elements = []
		for row in 0 ..< rows {
			for column in 0 ..< columns {
				elements.append(elementInit(row: row, column: column))
			}
		}
	}
	
	public subscript(row: Int, column: Int) -> Element {
		get {
			assert(indexIsValidForRow(row, column: column))
			return elements[(row * columns) + column]
		}
		
		set {
			assert(indexIsValidForRow(row, column: column))
			elements[(row * columns) + column] = newValue
		}
	}
	
	/**
	Filter by ranges of columns and rows. 
	
	- parameter rowsInRange:		Range of rows to filter by. Range will automatically trim to stay within bounds.
	- parameter columnsInRange:	Range of columns to filter by. Range will automatically trim to stay within bounds.
	
	- returns: A trimmed `Matrix`.
	*/
	public subscript(rows rowsInRange: Range<Int>, columns columnsInRange: Range<Int>) -> Matrix<Element> {
		let trimmedRowRange = max(0, rowsInRange.startIndex) ..< min(rows, rowsInRange.endIndex)
		let trimmedColumnRange = max(0, columnsInRange.startIndex) ..< min(columns, columnsInRange.endIndex)
		
		return Matrix(rows: trimmedRowRange.count, columns: trimmedColumnRange.count) { (row, column) in
			let offsetRow = row + trimmedRowRange.startIndex
			let offsetColumn = column + trimmedColumnRange.startIndex
			return self[offsetRow, offsetColumn]
		}
	}
	
	/**
	Filter by indexes within a point.
	
	- parameter point:	The center point around which to filter.
	- parameter within:	The number of vertical and horizontal elements around the point.
	
	- returns: A trimmed `Matrix`.
	*/
	public subscript(point point: MatrixIndex, within within: Int) -> Matrix<Element> {
		let rowRange = (point.row - within) ... (point.row + within)
		let columnRange = (point.column - within) ... (point.column + within)
		guard rowRange.startIndex <= rows && columnRange.startIndex <= columns else {
			// out of bounds; return empty Matrix
			return Matrix<Element>()
		}
		return self[rows: rowRange, columns: columnRange]
	}
	
	public subscript(row row: Int) -> [Element] {
		get {
			assert(row < rows)
			let startIndex = row * columns
			let endIndex = row * columns + columns
			return Array(elements[startIndex..<endIndex])
		}
		
		set {
			assert(row < rows)
			assert(newValue.count == columns)
			let startIndex = row * columns
			let endIndex = row * columns + columns
			elements.replaceRange(startIndex..<endIndex, with: newValue)
		}
	}
	
	public subscript(element: Element) -> Int? {
		return elements.indexOf(element)
	}
	
	public func gridPointOfIndex(index: Int) -> MatrixIndex {
		let row = index / rows
		let column = index % columns
		return (row: row, column: column)
	}
	
	private func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
}

// MARK: - SequenceType / SequenceType

extension Matrix: SequenceType {
	public func generate() -> AnyGenerator<Element> {
		var isFirstElement = true
		var nextPoint: MatrixIndex = (row: 0, column: 0)
		return AnyGenerator<Element> {
			if isFirstElement {
				isFirstElement = false
				return self[nextPoint.column, nextPoint.row]
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
			return self[nextPoint.row, nextPoint.column] // this seems backwards
		}
	}
}


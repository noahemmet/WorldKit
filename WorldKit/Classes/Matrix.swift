//
//  Matrix.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/11/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public struct MatrixPoint {
	public init(row: Int, column: Int) {
		self.row = row
		self.column = column
	}
	public var row: Int
	public var column: Int
}

extension MatrixPoint: CustomDebugStringConvertible {
	public var debugDescription: String {
		return String(row, column)
	}
}

public func ==(lhs: (row: Int, column: Int), rhs: (row: Int, column: Int)) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}

public struct Matrix<T: Hashable> {
	public typealias Element = T
	public let rows: Int
	public let columns: Int
	public var elements: [Element]
	
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
			assert(pointIsValidForRow(row, column: column))
			return elements[(row * columns) + column]
		}
		
		set {
			assert(pointIsValidForRow(row, column: column))
			elements[(row * columns) + column] = newValue
		}
	}
	
	public func elementAt(row row: Int, column: Int) -> Element? {
		guard pointIsValidForRow(row, column: column) else {
			return nil
		}
		return self[row, column]
	}
	
	public subscript(index: MatrixPoint) -> Element {
		return self[index.row, index.column]
	}
	
	
	/// Returns a sliced column
	public func elementsAt(row row: Int, range: Range<Int>) -> [Element] {
		var columns: [Element] = []
		for columnIndex in range {
			if let element = self.elementAt(row: row, column: columnIndex) {
				columns.append(element)
			}
		}
		return columns
	}
	
	/// Returns a sliced row
	public func elementsAt(column column: Int, range: Range<Int>) -> [Element] {
		var rows: [Element] = []
		for rowIndex in range {
			if let element = self.elementAt(row: rowIndex, column: column) {
				rows.append(element)
			}
		}
		return rows
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
	public subscript(nearPoint point: MatrixPoint, within within: Int) -> Matrix<Element> {
		let rowRange = (point.row - within) ... (point.row + within)
		let columnRange = (point.column - within) ... (point.column + within)
		guard rowRange.startIndex <= rows && columnRange.startIndex <= columns else {
			// out of bounds; return empty Matrix
			return Matrix<Element>()
		}
		return self[rows: rowRange, columns: columnRange]
	}
	
	public func columnForRow(row: Int) -> [Element] {
//		get {
			assert(row < rows)
			let startIndex = row * columns
			let endIndex = row * columns + columns
			return Array(elements[startIndex..<endIndex])
//		}
//		
//		set {
//			assert(row < rows)
//			assert(newValue.count == columns)
//			let startIndex = row * columns
//			let endIndex = row * columns + columns
//			elements.replaceRange(startIndex..<endIndex, with: newValue)
//		}
	}
	
	public subscript(point point: MatrixPoint, cardinality cardinality: PrincipalCardinalDirection, distance distance: Int) -> MatrixPoint? {
		var newPoint = point
		switch cardinality {
		case .North:
			newPoint.row -= distance
		case .NorthEast:
			newPoint.row -= distance
			newPoint.column += distance
		case .East:
			newPoint.column += distance
		case .SouthEast:
			newPoint.row += distance
			newPoint.column += distance
		case .South:
			newPoint.row += distance
		case .SouthWest:
			newPoint.row += distance
			newPoint.column -= distance
		case .West:
			newPoint.column -= distance
		case .NorthWest:
			newPoint.row -= distance
			newPoint.column += distance
		}
		guard pointIsValidForRow(newPoint.row, column: newPoint.column) else {
			return nil
		}
		return newPoint
	}
	
	public subscript(element: Element) -> Int? {
		return elements.indexOf(element)
	}
	
//	public subscript(type type: Element) -> Int? {
//		return elements.indexOf(element)
//	}
	
	public func gridPointOfIndex(point: Int) -> MatrixPoint {
		let row = point / rows
		let column = point % columns
		return MatrixPoint(row: row, column: column)
	}
	
	private func pointIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
	public var randomIndex: MatrixPoint {
		let x = Int(rand()) % rows
		let y = rand() % Int32(columns)
		let index = MatrixPoint(row: x, column: Int(y))
		return index
	}
	
	public func ringsAround(point centerPoint: MatrixPoint, range: Range<Int> = 1..<2, clockwise: Bool = true) -> [[Element]] {
		var rings: [[Element]] = []
		for ringIndex in range {
			
			// Corners
			let topLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column + ringIndex)
			let topRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column + ringIndex)
			let bottomRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column - ringIndex)
			let bottomLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column - ringIndex)
			
			// Edges
			let offset = 1 // ? I think this allows space between the edges.
			let topRow: [Element] = elementsAt(column: topLeft.column, range: topLeft.row+offset..<bottomRight.row+offset)
			let rightColumn: [Element] = elementsAt(row: bottomRight.row, range: bottomRight.column..<topRight.column)
			let bottomRow: [Element] = elementsAt(column: bottomLeft.column, range: bottomLeft.row..<bottomRight.row)
			let leftColumn: [Element] = elementsAt(row: bottomLeft.row, range: bottomLeft.column+offset..<topLeft.column+offset)
			
			let ring: [Element]
			if clockwise {
				ring = topRow + rightColumn.reverse() + bottomRow.reverse() + leftColumn
			} else {
				ring = topRow.reverse() + leftColumn + bottomRow + rightColumn.reverse()
			}
			rings.append(ring)
		}
		return rings
	}
	
	public func spiral(from centerPoint: MatrixPoint, start cardinality: PrincipalCardinalDirection = .NorthWest, clockwise: Bool = true) -> AnyGenerator<Element> {
		
		var ringIndex = 1
		var elementIndex = 0
		var nextRing = ringsAround(point: centerPoint, clockwise: clockwise).first!
		let cardinalityOffset = PrincipalCardinalDirection.cases.count % cardinality.rawValue
		return AnyGenerator<Element> { 
			if elementIndex < nextRing.count {
				// Traverse each ring
				let element = nextRing[elementIndex]
				elementIndex += 1
				return element
			} else {
				// end of ring
				ringIndex += 1
				elementIndex = 0
				let nextRange = ringIndex..<ringIndex+1
				if let possibleNextRing = self.ringsAround(point: centerPoint, range: nextRange, clockwise: clockwise).first where !possibleNextRing.isEmpty {
					nextRing = possibleNextRing
					let element = nextRing[0]
					return element
				} else {
					// All elements are out of bounds.
					return nil
				}
			}
		}
	}
}

// MARK: - SequenceType / SequenceType

extension Matrix: SequenceType {
	public func generate() -> AnyGenerator<Element> {
		var isFirstElement = true
		var nextPoint: MatrixPoint = MatrixPoint(row: 0, column: 0)
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


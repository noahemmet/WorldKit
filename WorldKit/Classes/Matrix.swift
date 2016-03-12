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


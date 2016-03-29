//
//  MatrixSpiralGenerator.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/26/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

/*
	o o o o o
	o o o o o
	o o x o o
	o o o o o
	o o o o o
*/

extension Matrix {
	
	/// Returns a sliced column
	func elementsAt(row row: Int, range: Range<Int>) -> [Element] {
		var columns: [Element] = []
		for columnIndex in range {
			if let element = self.elementAt(row: row, column: columnIndex) {
				columns.append(element)
			}
		}
		return columns
	}
	
	/// Returns a sliced row
	func elementsAt(column column: Int, range: Range<Int>) -> [Element] {
		var rows: [Element] = []
		for rowIndex in range {
			if let element = self.elementAt(row: column, column: rowIndex) {
				rows.append(element)
			}
		}
		return rows
	}
	
	func extendedSelection(around centerPoint: MatrixPoint, range: Range<Int> = 0..<1) -> [[Element]] {
		var rings: [[Element]] = []
		for ringIndex in range {
			var ring: [Element] = []
			/// Distance to travel per edge, sans overlap. 
			let ringLength = ringIndex * 2
			let topLeftPointX = centerPoint.row - ringIndex
			let topLeftPointY = ringIndex
			let topLeftPoint = MatrixPoint(row: topLeftPointX, column: topLeftPointY)
			let topRightPointX = topLeftPointX + ringLength
			let topRow: [Element] = elementsAt(row: topLeftPointY, range: topLeftPointX ..< topRightPointX)
			
			let topRightPoint = MatrixPoint(row: topRightPointX, column: topLeftPointY)
//			let rightColumns: [Element] = elementsAt(column: topRightPoint.column, range: top)
			
		}
		return rings
	}
	
//	public func circle(from centerPoint: MatrixPoint, range: Range<Int>) -> Set<
	
	 func spiral(from centerPoint: MatrixPoint, start cardinality: PrincipalCardinalDirection = .NorthWest, clockwise: Bool = true) -> AnyGenerator<Element> {
		var isFirstElement = true
		var nextPoint = centerPoint
		var ring = 1
		let directions = cardinality.cases
		var nextDirection = cardinality
//		var traversalDirection = 
		return AnyGenerator<Element> {
			/// Distance to travel per edge, sans overlap. 
			let ringLength = ring * 2
			let range = 
			print(nextDirection)
			nextDirection = nextDirection.generate().next()!
			if let point = self[point: nextPoint, cardinality: nextDirection, distance: 1] {
				print(point)
				return self[point.row, point.column] // this seems backwards
			}
			return nil
		}
	}
}

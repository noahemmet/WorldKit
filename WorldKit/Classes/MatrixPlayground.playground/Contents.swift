//: Playground - noun: a place where people can play

import Cocoa
import WorldKit
import XCPlayground

/*
o o o o o
o o o o o
o o x o o
o o o o o
o o o o o
*/

let world = World(rows: 9, columns: 9)
let worldSequence = WorldSequence(initial: world)
let worldView = WorldView(worldSequence: worldSequence)
XCPlaygroundPage.currentPage.liveView = worldView
// elementsAt

// elements at
//let elements = world.cells.elementsAt(row: 5, range:  4 ..< 16)
//print(elements.count)
//elements.forEach { $0.color = .redColor() } 

// extended selection

let rings = world.cells.extendedSelection(around: MatrixPoint(row: 5, column: 5))

var hue:  CGFloat = 0.5
var saturation: CGFloat = 0.8
let colorIncrement: CGFloat = 0.05
for (r, ring) in rings.enumerate() {
	for (i, cell) in ring.enumerate() {
		cell.color = NSColor(hue: hue, saturation: saturation, brightness: 0.8, alpha: 1.0)
	}
	hue += colorIncrement
	saturation -= colorIncrement
}

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
			if let element = self.elementAt(row: rowIndex, column: column) {
				rows.append(element)
			}
		}
		return rows
	}
	
	func extendedSelection(around centerPoint: MatrixPoint, range: Range<Int> = 1..<2) -> [[Element]] {
		var rings: [[Element]] = []
		for ringIndex in range {
			var ring: [Element] = []
			
			// Corners
			let topLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column + ringIndex)
			let topRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column + ringIndex)
			let bottomRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column - ringIndex)
			let bottomLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column - ringIndex)
			
			// Edges
			let topRow: [Element] = elementsAt(column: topLeft.column, range: topLeft.row+1..<bottomRight.row+1)
			let rightColumn: [Element] = elementsAt(row: bottomRight.row, range: bottomRight.column..<topRight.column)
			let bottomRow: [Element] = elementsAt(column: bottomLeft.column, range: bottomLeft.row..<bottomRight.row)
			let leftColumn: [Element] = elementsAt(row: bottomLeft.row, range: bottomLeft.column+1..<topLeft.column+1)
			
			rings.append(topRow)
			rings.append(rightColumn)
			rings.append(bottomRow)
			rings.append(leftColumn)
		}
		return rings
	}
	
	//	public func circle(from centerPoint: MatrixPoint, range: Range<Int>) -> Set<
	
//	func spiral(from centerPoint: MatrixPoint, start cardinality: PrincipalCardinalDirection = .NorthWest, clockwise: Bool = true) -> AnyGenerator<Element> {
//		var isFirstElement = true
//		var nextPoint = centerPoint
//		var ring = 1
//		let directions = cardinality.cases
//		var nextDirection = cardinality
//		//		var traversalDirection = 
//		return AnyGenerator<Element> {
//			/// Distance to travel per edge, sans overlap. 
//			let ringLength = ring * 2
//			let range = 
//				print(nextDirection)
//			nextDirection = nextDirection.generate().next()!
//			if let point = self[point: nextPoint, cardinality: nextDirection, distance: 1] {
//				print(point)
//				return self[point.row, point.column] // this seems backwards
//			}
//			return nil
//		}
//	}
}

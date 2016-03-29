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

//let rings = world.cells.extendedSelection(around: MatrixPoint(row: 4, column: 4), range: 1..<4)
//
//var hue:  CGFloat = 0.5
//var saturation: CGFloat = 0.8
//let colorIncrement: CGFloat = 0.05
//for (r, ring) in rings.enumerate() {
//	for (i, cell) in ring.enumerate() {
//		cell.color = NSColor(hue: hue, saturation: saturation, brightness: 0.8, alpha: 1.0)
//	}
//	hue += colorIncrement
//	saturation -= colorIncrement
//}
var hue:  CGFloat = 0.5
var saturation: CGFloat = 0.8
let colorIncrement: CGFloat = 0.01
for cell in world.cells.spiral(from: MatrixPoint(row: 4, column: 4)) {
	cell.color = NSColor(hue: hue, saturation: saturation, brightness: 0.8, alpha: 1.0)
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
			
			// Corners
			let topLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column + ringIndex)
			let topRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column + ringIndex)
			let bottomRight = MatrixPoint(row: centerPoint.row + ringIndex, column: centerPoint.column - ringIndex)
			let bottomLeft = MatrixPoint(row: centerPoint.row - ringIndex, column: centerPoint.column - ringIndex)
			
			// Edges
			let offset = 1
			let topRow: [Element] = elementsAt(column: topLeft.column, range: topLeft.row+offset..<bottomRight.row+offset)
			let rightColumn: [Element] = elementsAt(row: bottomRight.row, range: bottomRight.column..<topRight.column).reverse()
			let bottomRow: [Element] = elementsAt(column: bottomLeft.column, range: bottomLeft.row..<bottomRight.row).reverse()
			let leftColumn: [Element] = elementsAt(row: bottomLeft.row, range: bottomLeft.column+offset..<topLeft.column+offset)
			
			let ring: [Element] = topRow + rightColumn + bottomRow + leftColumn
			rings.append(ring)
		}
		return rings
	}
	
	public func spiral(from centerPoint: MatrixPoint, start cardinality: PrincipalCardinalDirection = .NorthWest, clockwise: Bool = true) -> AnyGenerator<Element> {

		var ringIndex = 1
		var elementIndex = 0
		var nextRing = extendedSelection(around: centerPoint).first!
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
				if let possibleNextRing = self.extendedSelection(around: centerPoint, range: nextRange).first where !possibleNextRing.isEmpty {
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

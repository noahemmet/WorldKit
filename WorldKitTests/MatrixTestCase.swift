//
//  MatrixTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 3/12/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit

private struct Position: Hashable {
	let row: Int
	let column: Int
	var hashValue: Int {
		return row.hashValue * column.hashValue
	}
}

private func ==(lhs: Position, rhs: Position) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}

class MatrixTestCase: XCTestCase {
	
	private var matrix: Matrix<Position>!
	
	override func setUp() {
		super.setUp()
		
		matrix = Matrix(rows: 100, columns: 100) { (row, column) in
			return Position(row: row, column: column)
		}
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testRangeSubscript() {
		let rangedMatrix = matrix[rows: 0 ... 1, columns: 0 ..< 2]
		XCTAssertEqual(rangedMatrix.rows, 2)
		XCTAssertEqual(rangedMatrix.columns, 2)
	}
	
	func testRangeSubscriptOffset() {
		let rangedMatrix = matrix[rows: 1 ... 2, columns: 0 ..< 2]
		XCTAssertEqual(rangedMatrix.rows, 2)
		XCTAssertEqual(rangedMatrix.columns, 2)
		
		var element = rangedMatrix[0, 1]
		XCTAssertEqual(element.row, 1)
		XCTAssertEqual(element.column, 1)
		
		element = rangedMatrix[1, 1]
		XCTAssertEqual(element.row, 2)
		XCTAssertEqual(element.column, 1)
	}
	
	func testRangeSubscriptTrimming() {
		let rangedMatrix = matrix[rows: 1 ... 200, columns: 0 ..< 2]
		XCTAssertEqual(rangedMatrix.rows, 99)
		XCTAssertEqual(rangedMatrix.columns, 2)
	}
	
	func testRangeSubscriptWithin() {
		self.measureBlock {
			var rangedMatrix = self.matrix[nearPoint: (5, 5), within: 1]
			XCTAssertEqual(rangedMatrix.rows, 3)
			XCTAssertEqual(rangedMatrix.columns, 3)
		
			rangedMatrix = self.matrix[nearPoint: (5, 5), within: 2]
			XCTAssertEqual(rangedMatrix.rows, 5)
			XCTAssertEqual(rangedMatrix.columns, 5)
		
		
		// with trimming
			rangedMatrix = self.matrix[nearPoint: (0, 0), within: 1]
			XCTAssertEqual(rangedMatrix.rows, 2)
			XCTAssertEqual(rangedMatrix.columns, 2)
		
		
			rangedMatrix = self.matrix[nearPoint: (0, 0), within: 2]
			XCTAssertEqual(rangedMatrix.rows, 3)
			XCTAssertEqual(rangedMatrix.columns, 3)
			
			rangedMatrix = self.matrix[nearPoint: (100, 100), within: 1]
			XCTAssertEqual(rangedMatrix.rows, 1)
			XCTAssertEqual(rangedMatrix.columns, 1)
		}
	}
	
	func testRangeSubscriptOutOfBounds() {
		let rangedMatrix = matrix[nearPoint: (500, 500), within: 1]
		XCTAssertEqual(rangedMatrix.rows, 0)
		XCTAssertEqual(rangedMatrix.columns, 0)
	}
	
	func testMatrixSpiral() {
		let center = MatrixPoint(row: 50, column: 50)
		let spiralGenerator = matrix.spiral(from: center)
		let nextPoint = spiralGenerator.next()!
		XCTAssertEqual(nextPoint, matrix[51, 50])
	}
}

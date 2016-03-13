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
		
		matrix = Matrix(rows: 10, columns: 10) { (row, column) in
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
		let rangedMatrix = matrix[rows: 1 ... 20, columns: 0 ..< 2]
		XCTAssertEqual(rangedMatrix.rows, 9)
		XCTAssertEqual(rangedMatrix.columns, 2)
	}
	
	func testRangeSubscriptWithin() {
		var rangedMatrix = matrix[nearPoint: (5, 5), within: 1]
		XCTAssertEqual(rangedMatrix.rows, 3)
		XCTAssertEqual(rangedMatrix.columns, 3)
		
		rangedMatrix = matrix[nearPoint: (5, 5), within: 2]
		XCTAssertEqual(rangedMatrix.rows, 5)
		XCTAssertEqual(rangedMatrix.columns, 5)
		
		// with trimming
		rangedMatrix = matrix[nearPoint: (0, 0), within: 1]
		XCTAssertEqual(rangedMatrix.rows, 2)
		XCTAssertEqual(rangedMatrix.columns, 2)
		
		rangedMatrix = matrix[nearPoint: (0, 0), within: 2]
		XCTAssertEqual(rangedMatrix.rows, 3)
		XCTAssertEqual(rangedMatrix.columns, 3)
		
		rangedMatrix = matrix[nearPoint: (10, 10), within: 1]
		XCTAssertEqual(rangedMatrix.rows, 1)
		XCTAssertEqual(rangedMatrix.columns, 1)
	}
	
	func testRangeSubscriptOutOfBounds() {
		let rangedMatrix = matrix[nearPoint: (50, 50), within: 1]
		XCTAssertEqual(rangedMatrix.rows, 0)
		XCTAssertEqual(rangedMatrix.columns, 0)
	}
}

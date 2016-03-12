//
//  GridTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit

class GridTestCase: XCTestCase {

    func testGenerator() {
		let grid = Grid(rows: 10, columns: 10)
		var count: Int = 0
		for _ in grid {
			count += 1
		}
		XCTAssertEqual(count, grid.rows * grid.columns)
    }

}

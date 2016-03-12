//
//  WorldViewTestCase.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import WorldKit

class WorldViewTestCase: XCTestCase {

    func testInit() {
		let firstWorld = World(grid: Grid(rows: 10, columns: 10)) { gridPoint in
			return Cell()
		}
		let worldSequence = WorldSequence(initial: firstWorld)
		let _ = WorldView(worldSequence: worldSequence)
    }

}

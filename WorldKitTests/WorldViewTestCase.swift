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
		let firstWorld = World(rows: 10, columns: 20) { gridPoint in
			return Cell()
		}
		let worldSequence = WorldSequence(initial: firstWorld)
		let _ = WorldView(worldSequence: worldSequence)
    }
	
	func testInit2() {
		let _ = World(rows: 10, columns: 20, cellType: Cell.self)
	}

}

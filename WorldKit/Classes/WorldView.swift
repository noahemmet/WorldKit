//
//  WorldView.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import SpriteKit

public class WorldView: SKView {
	public static let defaultSize = CGSize(width: 480, height: 480)
	public let worldScene: WorldScene
	
	public init(worldSequence: WorldSequence) {
		worldScene = WorldScene(size: WorldView.defaultSize, worldSequence: worldSequence)
		super.init(frame: NSRect(origin: CGPoint.zero, size: worldScene.size))
		
		self.widthAnchor.constraintEqualToConstant(frame.size.width).active = true
		self.heightAnchor.constraintEqualToConstant(frame.size.height).active = true
		
		self.presentScene(worldScene)
	}
	
	
	
	required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
	
}

extension WorldView: CustomPlaygroundQuickLookable {
	public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
		let worldView = SKView(frame: NSRect(origin: CGPoint.zero, size: worldScene.size))
		worldView.presentScene(worldScene)
		return PlaygroundQuickLook.View(worldView)
	}
}
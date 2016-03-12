//
//  AgentSprite.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/18/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation
import SpriteKit

public class AgentSprite: SKSpriteNode {
	internal let uuid: UInt64
	public init(agent: Agent, size: CGSize) {
		self.uuid = agent.uuid
		super.init(texture: nil, color: agent.color, size: size)
	}
	
	required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
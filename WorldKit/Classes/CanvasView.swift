//
//  CanvasView.swift
//  WorldKit
//
//  Created by Noah Emmet on 2/19/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class CanvasView: NSView {
	internal let stackView: NSStackView
	internal let worldView: WorldView
	internal let settingsView: SettingsView
	
	public init(worldView: WorldView) {
		self.worldView = worldView
		self.settingsView = SettingsView(frame: NSRect(x: 0, y: 0, width: worldView.frame.size.width, height: 100))
		
		stackView = NSStackView(views: [worldView, self.settingsView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
//		stackView.alignment = .Leading
//		stackView.distribution = .Fill
		stackView.orientation = .Vertical
		super.init(frame: NSRect(x: 0, y: 0, width: 480, height: 580))
		
		self.settingsView.delegate = self
		
		self.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)
		
//		self.settingsView.widthAnchor.constraintEqualToAnchor(settingsView.scrollView.widthAnchor, multiplier: 1)
//		self.settingsView.heightAnchor.constraintEqualToAnchor(settingsView.scrollView.heightAnchor, multiplier: 1)
		self.settingsView.widthAnchor.constraintEqualToAnchor(worldView.widthAnchor).active = true
		self.settingsView.heightAnchor.constraintEqualToConstant(100).active = true
		
//		stackView.topAnchor.constraintEqualToAnchor(worldView.bottomAnchor).active = true
//		stackView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
		
		self.heightAnchor.constraintEqualToAnchor(stackView.heightAnchor, multiplier: 1.0)
		self.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor, multiplier: 1.0)
//		stackView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1.0).active = true
//		stackView.heightAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: 1.0).active = true;
//				stackView.heightAnchor.constraintEqualToAnchor(stackView.intri, multiplier: 1.0).active = true;
	}
	
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension CanvasView: SettingsViewDelegate {
	func settingsView(settingsView: SettingsView, didSelectSetting setting: String) {
		worldView.paused = !worldView.paused
		Swift.print(worldView.paused ? "pause" : "resume")
	}
}
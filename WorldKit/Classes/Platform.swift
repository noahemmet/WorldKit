//
//  Platform.swift
//  WorldKit
//
//  Created by Noah Emmet on 4/9/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
	public typealias View = UIView
	public typealias Color = UIColor
	public typealias Rect = CGRect
	public typealias Image = UIImage
#else
	import Cocoa
	public typealias View = NSView
	public typealias Color = NSColor
	public typealias Rect = NSRect
	public typealias Image = NSImage
#endif

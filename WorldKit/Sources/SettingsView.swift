//
////  SettingsView.swift
////  WorldKit
////
////  Created by Noah Emmet on 2/19/16.
////  Copyright © 2016 Sticks. All rights reserved.
////
//
//import Foundation
//
//protocol SettingsViewDelegate: class {
//	func settingsView(settingsView: SettingsView, didSelectSetting setting: String)
//}
//
//public class SettingsView: View {
//	internal weak var delegate: SettingsViewDelegate?
//	
//	private let scrollView: NSScrollView
//	public let collectionView: NSCollectionView
//	internal var settingTitles: [String] = []
//	public override init(frame frameRect: Rect) {
//		scrollView = NSScrollView(frame: frameRect)
////		scrollView.translatesAutoresizingMaskIntoConstraints = false
//		collectionView = NSCollectionView(frame: frameRect)
//		collectionView.translatesAutoresizingMaskIntoConstraints = false
//		
//		super.init(frame: frameRect)
//		
//		let flowLayout = NSCollectionViewFlowLayout()
//		flowLayout.itemSize = NSSize(width: frameRect.size.width, height: 40)
//		flowLayout.scrollDirection = .Vertical
//		collectionView.collectionViewLayout = flowLayout
//		collectionView.registerClass(SettingCell.self, forItemWithIdentifier: String(Cell))
//		collectionView.delegate = self
//		collectionView.dataSource = self
//		collectionView.selectable = true
//		scrollView.documentView = collectionView
//		addSubview(scrollView)
//		scrollView.widthAnchor.constraintEqualToAnchor(collectionView.widthAnchor, multiplier: 1.0).active = true
//		scrollView.heightAnchor.constraintEqualToAnchor(collectionView.heightAnchor, multiplier: 1.0).active = true;
//		
//		// todo: Create Settings object
////		settings.delegate = self
//	}
//	
//	public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//}
//
//extension SettingsView: SettingsDelegate {
//	func settingsDidAddSettable(settings: Settings, settable: Settable) {
//		settingTitles.append(String(index))	
//		collectionView.reloadData()
//	}
//}
//
//extension SettingsView: NSCollectionViewDelegate, NSCollectionViewDataSource {
//	public func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
//		return 1
//	}
//	
//	public func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
//		return settingTitles.count
//	}
//	
//	public func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
//		let cell = collectionView.makeItemWithIdentifier(String(Cell), forIndexPath: indexPath)
//		cell.view.wantsLayer = true
//		cell.view.layer?.backgroundColor = Color.redColor().CGColor
//		return cell
//	}
//	
//	public func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
//		let item = indexPaths.first!.item
//		let settable = settingTitles[item]
//		delegate?.settingsView(self, didSelectSetting: settable)
//		collectionView.deselectItemsAtIndexPaths(indexPaths)
//	}
//}
//
//// MARK: - Settings Cell
//
//
//public class SettingCell: NSCollectionViewItem {
//	let button = NSButton()
//	public override func viewDidLoad() {
//		super.viewDidLoad()
//		view.addSubview(button)
//	}
//	
//	public override func loadView() {
//		self.view = View(frame: Rect(x: 0, y: 0, width: 10, height: 10))
//	}
//}
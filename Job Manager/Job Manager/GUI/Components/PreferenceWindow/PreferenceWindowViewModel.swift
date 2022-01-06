//
//  AMGPreferenceWindowViewModel.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import JobManager

class PreferenceWindowModel : NSWindow {
	var model            : PreferenceModel = PreferenceModel();
	var fieldLabelHeight : CGFloat = 20;
	var fieldLabelSpacing: CGFloat = 10;
	var inputFields      : [AnyObject] = [];
	var inputLabels      : [Label] = [];
	
	init() {
		super.init(contentRect: CGRect(x: 0, y: 0, width: 0, height: 0), styleMask: .borderless, backing: .buffered, defer: false);
		self.prepare();
	}
	
	override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
				  backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag);
		self.prepare();
	}
	
	private func prepare() {
		self.title = "Preferences";
        self.isReleasedWhenClosed = false;
		self.generateFields();
		self.placeFields();
	}
	
	private func generateFields() {
		var index : Int = 0;
        for setting in self.model.settings {
			var originY = (self.contentView!.frame.size.height - (self.fieldLabelHeight * CGFloat(index) + self.fieldLabelHeight));
			if(index > 0) {
				originY -= self.fieldLabelSpacing;
			}
			let newLabel = Label(frame:
				CGRect(
					x: 0,
					y: originY,
					width: self.contentView!.frame.size.width / 2,
					height: self.fieldLabelHeight));
			newLabel.stringValue = setting.label;
			newLabel.isBordered = true;
			newLabel.autoresizingMask = [.width, .maxXMargin, .minYMargin];
			self.inputLabels.append(newLabel);
			var newInput : NSView? = nil;
			switch(setting.type) {
				case .Switch:
					newInput = NSSegmentedControl(
						labels: setting.options,
						trackingMode: .selectOne,
						target: self,
						action: #selector(updateField(sender:)));
					newInput!.frame = CGRect(x: newLabel.frame.origin.x + newLabel.frame.size.width,
										   y: newLabel.frame.origin.y - 2,
                                           width: newLabel.frame.size.width, height: self.fieldLabelHeight);
					(newInput as! NSSegmentedControl).selectSegment(withTag: Int(Helper.store.getProperty(key: setting.name) as? String ?? "0") ?? 0);
					(newInput as! NSSegmentedControl).identifier = NSUserInterfaceItemIdentifier(rawValue: setting.name);
                    (newInput as! NSSegmentedControl).focusRingType = .none;
                    break;
				case .TextField:
					newInput = NSTextField(frame:
						CGRect(x: newLabel.frame.origin.x + newLabel.frame.size.width,
							   y: newLabel.frame.origin.y,
							   width: newLabel.frame.size.width, height: self.fieldLabelHeight));
					(newInput as! NSTextField).placeholderString = setting.placeholder;
					(newInput as! NSTextField).target = self;
					(newInput as! NSTextField).action = #selector(updateField(sender:));
					(newInput as! NSTextField).stringValue = Helper.store.getProperty(key: setting.name) as! String;
					break;
				default:
					break;
			}
			newInput!.identifier = NSUserInterfaceItemIdentifier(rawValue: setting.name);
			newInput!.autoresizingMask = [.width, .minXMargin, .minYMargin];
			self.inputFields.append(newInput!);
			index += 1;
		}
	}
	
	private func placeFields() {
		for cursor in 0 ..< self.inputLabels.count {
			self.contentView?.addSubview(self.inputLabels[cursor]);
			if(cursor < self.inputFields.count) {
                switch(self.model.settings[cursor].type) {
					case .Switch:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSSegmentedControl);
						break;
					case .TextField:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSTextField);
						break;
					case .TextView:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSTextView);
						break;
					default:
						break;
				}
			}
		}
	}
	
	public func show() {
        var i = 0;
		for cursor in self.inputFields{
            let setting = self.model.settings[i]
			switch(setting.type) {
				case .TextField:
					(cursor as! NSTextField).stringValue = Helper.store.getProperty(key: setting.name) as? String ?? "";
					break;
				case .Switch:
					break;
				default:
					break;
			}
            i+=1;
		}
		self.makeKeyAndOrderFront(self);
	}
	
	/**
	 * Handlers
	 */
	@objc func updateField(sender : AnyObject?) {
		var newValue : String = "";
        var setting : SettingItem = SettingItem();
        self.model.settings.forEach({ if ($0.name == (sender as! NSView).identifier!.rawValue) { setting = $0; }});
		switch(setting.type) {
			case .TextField:
				newValue = (sender! as! NSTextField).stringValue;
				break;
			case .Switch:
				newValue = String((sender! as! NSSegmentedControl).selectedSegment);
			default:
				break;
		}
		Helper.store.setProperty(key: sender!.identifier!, value: newValue);
	}
}

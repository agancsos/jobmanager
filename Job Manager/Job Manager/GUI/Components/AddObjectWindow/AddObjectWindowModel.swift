//
//  AddObjectWindowModel.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 9/26/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class AddObjectWindowModel : NSWindow {
    private var viewModel  : EditObjectViewModel = EditObjectViewModel();
    private var item       : Item = Company();
    
    public init() {
        super.init(contentRect: CGRect(x: 0, y: 0, width: 0, height: 0),
                   styleMask: .borderless, backing: .buffered, defer: false);
        self.prepare();
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag);
        prepare();
    }
    
    private func prepare() {
        self.title = "Add (\(self.item))".replacingOccurrences(of: "JobMonitor.", with: "")
        self.contentView?.addSubview(self.viewModel);
        self.isReleasedWhenClosed = false;
        for cursor : NSView in self.contentView!.subviews {
            cursor.removeFromSuperview();
        }
        self.viewModel.frame = self.frame;
        self.contentView?.addSubview(self.viewModel);
    }
    
    public func show() {
        self.makeKeyAndOrderFront(nil);
    }

    public func setObject(item : Item) {
        self.item = item;
        self.viewModel.setObject(item: self.item);
    }
    
    public func setCompany(company: Company) { self.viewModel.company = company; }
}

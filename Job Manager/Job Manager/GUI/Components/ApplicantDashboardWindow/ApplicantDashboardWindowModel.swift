//
//  AMGAboutVIewModel.swift
//
//  Created by Abel Gancsos on 11/7/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import JobManager
import Common
import WebKit

public class ApplicantDashboardWindow : NSWindow, NSTableViewDelegate, NSTableViewDataSource {
    private var viewModel   : ApplicantDashboardViewModel = ApplicantDashboardViewModel();
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag);
        prepare();
    }
    
    init() {
        super.init(contentRect: CGRect(x: 0, y: 0, width: 0, height: 0),
                   styleMask: .borderless, backing: .buffered, defer: false);
        prepare();
    }
    
    private func prepare() {
        self.title = "Applicant Dashboard";
        self.isReleasedWhenClosed = false;
        self.viewModel = ApplicantDashboardViewModel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.viewModel.autoresizingMask = [.width, .height];
        self.contentView?.addSubview(self.viewModel);
        self.refresh();
    }

    
    public func show() {
        self.makeKeyAndOrderFront(self);
        self.refresh();
    }
    
    public func refresh() {
        self.viewModel.refresh();
    }
}

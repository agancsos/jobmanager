//
//  MainController.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class MainController : NSView {
    
    private var copyLabel       : Label = Label.init();
    private var versionLabel    : Label = Label.init();
    private var footerContainer : NSView = NSView.init();
    private var applicationView : NSView = NSView.init();
    private var productModeLabel: Label = Label.init();
    
    override public init(frame: NSRect) {
        super.init(frame: frame);
        //Helper.initializeDirectories();
        self.footerContainer = NSView(frame: NSRect(x: 0, y: 0, width: self.frame.width, height: 30));
        self.footerContainer.needsLayout = true;
        self.layer?.backgroundColor = .clear;
        self.footerContainer.autoresizingMask = [.width];
        self.subviews.append(footerContainer);
        self.initializeCopy();
        self.initializeVersion();
        self.initializeApplicationView();
    }
    
    private func initializeCopy() {
        self.copyLabel = Label(frame: NSRect(x: 0, y: 0, width: self.footerContainer.frame.width / 2, height: 20));
        self.copyLabel.autoresizingMask = [.width];
        self.copyLabel.font = NSFont(name: "Consolas", size: 8);
        self.copyLabel.stringValue = "(c) \(SystemService.getYear()) \(SR.copyrightOwner)";
        self.copyLabel.textColor = .white;
        self.copyLabel.backgroundColor = .clear;
        self.copyLabel.isBordered = false;
        self.footerContainer.subviews.append(self.copyLabel);
        
        self.productModeLabel = Label(frame: NSRect(x: self.copyLabel.frame.width, y: 0, width: 100, height: 20));
        self.productModeLabel.autoresizingMask = [.width];
        self.productModeLabel.textColor = .white;
        self.productModeLabel.stringValue = "\(LicenseService.getApplicationMode())";
        self.productModeLabel.backgroundColor = .clear;
        self.productModeLabel.isBordered = false;
        self.footerContainer.subviews.append(self.productModeLabel);
    }
    
    private func initializeVersion() {
        self.versionLabel = Label(frame: NSRect(x: self.footerContainer.frame.size.width - 365, y: 0, width: self.footerContainer.frame.width / 2, height: 20));
        self.versionLabel.autoresizingMask = [.width, .minXMargin];
        self.versionLabel.alignment = .right;
        self.versionLabel.font = NSFont(name: "Consolas", size: 8);
        self.versionLabel.stringValue = "v. \(SystemService.getVersion().version())";
        self.versionLabel.textColor = .white;
        self.versionLabel.backgroundColor = .clear;
        self.versionLabel.isBordered = false;
        self.footerContainer.subviews.append(self.versionLabel);
    }
    
    private func initializeApplicationView() {
        self.applicationView = NSView(frame: CGRect(x: 0, y: 20, width: self.frame.size.width, height: self.frame.size.height));
        let jmViewModel = JobMonitorViewModel(frame: NSRect(x: 0, y: 0, width: self.applicationView.frame.width, height: self.applicationView.frame.size.height));
        self.applicationView.autoresizingMask = [.width, .height];
        self.applicationView.autoresizesSubviews = true;
        jmViewModel.autoresizingMask = [.width, .height];
        self.applicationView.addSubview(jmViewModel);
        self.applicationView.wantsLayer = true;
        self.subviews.append(self.applicationView);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setApplicationView(view : NSView) {
        for view : NSView in self.applicationView.subviews {
            view.removeFromSuperview();
        }
        view.autoresizingMask = [.width, .height];
        self.applicationView.subviews.append(view);
    }
    
    public func getApplicationView() -> NSView { return self.applicationView.subviews[0]; }
}

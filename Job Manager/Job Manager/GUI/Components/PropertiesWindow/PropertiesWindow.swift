//
//  PropertiesWindow.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 10/16/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import JobManager
import Common

public class PreferencesWindow : NSWindow, NSTableViewDelegate, NSTableViewDataSource {
    private var tableView      : NSTableView = NSTableView.init();
    private var logEntries     : [Message] = [];

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
        self.title = "Preferences";
        self.isReleasedWhenClosed = false;
        let scrollView = NSScrollView.init(frame: self.contentView!.frame);
        scrollView.autoresizingMask = [.width, .height];
        self.tableView = NSTableView(frame: self.frame);
        for cursor in Message().getProperties() {
            let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: cursor.uppercased()));
            newColumn.title = cursor.uppercased();
            self.tableView.addTableColumn(newColumn);
        }
        scrollView.documentView = self.tableView;
        self.contentView?.subviews.append(scrollView);
        self.tableView.usesAlternatingRowBackgroundColors = true;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.refresh();
    }

    public func show() {
        self.makeKeyAndOrderFront(self);
    }

    @objc public func refresh() {
        self.logEntries = DataService.getInstance().getMessages();
        self.tableView.reloadData();
    }

    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.logEntries.count;
    }

    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let value = self.logEntries[row].getValues()[self.tableView.tableColumns.firstIndex(of: tableColumn!) ?? 0] ;
        if ((value as? TraceLevel) != nil) {
            return "\(value as! TraceLevel)";
        }
        if ((value as? TraceCategory) != nil) {
            return "\(value as! TraceCategory)";
        }

        return value as Any;
    }

    public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        return true;
    }

    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false;
    }
}

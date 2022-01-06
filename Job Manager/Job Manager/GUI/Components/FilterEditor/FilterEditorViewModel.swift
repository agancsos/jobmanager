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

public class FilterEditorViewModel : NSTableView, NSTableViewDelegate, NSTableViewDataSource {
    private var filter      : Filter = Filter();
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        prepare();
    }
    
    init() {
        super.init(frame:NSRect.zero);
        prepare();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeTable() {
        let columns = [ "Key", "Value" ];
        for cursor in columns {
            let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: cursor.uppercased()));
            newColumn.title = cursor.uppercased();
            self.addTableColumn(newColumn);
        }
        self.usesAlternatingRowBackgroundColors = true;
        self.selectionHighlightStyle = .none;
    }
    
    private func prepare() {
        self.filter = Helper.currentProfile.filter;
        self.initializeTable();
        self.focusRingType = .none;
        self.dataSource = self;
        self.delegate = self;
    }
    
    @objc public func refresh() {
        self.reloadData();
    }
        
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.filter.getProperties().count;
    }
        
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if (tableView.tableColumns.firstIndex(of: tableColumn!) == 0) {
            return self.filter.getProperties()[row].uppercased();
        }
        let propertyName = self.filter.getProperties()[row];
        var value = self.filter.getValues()[row];

        if (value as? [JobType] != nil) {
            var rawValue = "";
            var i = 0;
            for type : JobType in filter.jobType {
                if (i > 0) {
                    rawValue += ";"
                }
                rawValue += "\(type)";
                i += 1;
            }
            value = rawValue.uppercased();
        }
        
        else if (value as? [String] != nil) {
            if (propertyName == "keywords") {
                value = self.filter.keywords.joined(separator: ";");
            }
            else if (propertyName == "tech") {
                value = self.filter.tech.joined(separator: ";");
            }
            
        }
       
        return value;
    }
        
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        if (tableView.tableColumns.firstIndex(of: tableColumn!) == 1) {
            return true;
        }
        return false;
    }
 
    public override func textDidEndEditing(_ notification: Notification) {
        let editingCell = self.selectedCell();
        if (editingCell != nil) {
            let propertyName = self.filter.getProperties()[self.selectedRow];
            switch (propertyName) {
                case "keywords":
                    filter.keywords = editingCell!.stringValue.components(separatedBy: ";");
                    break;
                case "location":
                    filter.location = editingCell!.stringValue;
                    break;
                case "distance":
                    filter.distance = Double(editingCell!.stringValue) ?? 0.0;
                    break;
                case "compensation":
                    filter.compensation = Double(editingCell!.stringValue) ?? 0.0;
                    break;
                case "level":
                    filter.level = editingCell!.stringValue;
                    break;
                case "tech":
                    filter.tech = editingCell!.stringValue.components(separatedBy: ";");
                    break;
                case "jobType":
                    self.filter.jobType.removeAll();
                    for rawValue : String in editingCell!.stringValue.components(separatedBy: ";") {
                        switch (rawValue) {
                            case "PARTTIME":
                                filter.jobType.append(.PARTTIME);
                                break;
                            case "CONTRACT":
                                filter.jobType.append(.CONTRACT);
                                break;
                            case "FULLTIME":
                                filter.jobType.append(.FULLTIME);
                                break;
                            default:
                                break;
                        }
                    }
                    break;
                default:
                    break;
            }
            Helper.currentProfile.filter = filter;
            ProfileService.updateProfile(a: Helper.currentProfile);
        }
    }
}

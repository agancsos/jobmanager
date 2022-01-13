//
//  PropertiesPaneViewModel.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/10/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class ResultsViewModel : NSTableView, NSTableViewDataSource, NSTableViewDelegate {
    private var items         : [Result] = [];
    
    public init() {
        super.init(frame: NSRect.zero);
        self.initializeLayout();
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.initializeLayout();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeLayout() {
        self.initializeTable();
        self.doubleAction = #selector(self.doubleClick);
        self.focusRingType = .none;
        self.dataSource = self;
        self.delegate = self;
        self.reloadData();
    }
    
    private func initializeTable() {
        for cursor in Result().getProperties() {
            let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: cursor.uppercased()));
            newColumn.title = cursor.uppercased();
            self.addTableColumn(newColumn);
        }
        self.usesAlternatingRowBackgroundColors = true;
        self.selectionHighlightStyle = .none;
    }
        
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.items.count;
    }
        
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as? Profile != nil) {
            return (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as! Profile).name;
        }
        else if (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as? Company != nil) {
            return (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as! Company).name;
        }
        else if (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as? Endpoint != nil) {
            return (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as! Endpoint).baseUrl;
        }
        else if (self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as? ResultState != nil) {
            return "\(self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0] as! ResultState)";
        }
        return "\(self.items[row].getValues()[self.tableColumns.firstIndex(of: tableColumn!) ?? 0])";
    }
        
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false;
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        if (self.selectedRow > -1 && self.selectedRow < self.items.count) {
            if (self.items[self.selectedRow].state == .NEW) {
                ResultService.markRead(a: self.items[self.selectedRow]);
            }
        }
    }
    
    public func tableView(_ tableView: NSTableView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
        return false;
    }
    
    @objc private func doubleClick(sender : Any?) {
        if (self.selectedRow > -1 && self.selectedRow < self.items.count) {
            if ((Helper.store.getProperty(key: SR.keyEnableEditWindow) as? String ?? "0") == "1") {
                let window : EditObjectWindowModel = EditObjectWindowModel.init(contentRect:CGRect(x: 200, y: 200, width: 800, height: 600), styleMask: [.titled, .closable], backing: .buffered, defer: false);
                window.setObject(item: self.items[self.selectedRow]);
                window.show();
            }
            else {
                let editView = EditObjectViewModel();
                editView.setObject(item: self.items[self.selectedRow]);
                GUIService.setViewModel(viewModel: editView);
            }
        }
    }
    
    public override func keyDown(with event: NSEvent) {
        
        if (self.selectedRow > -1 && self.selectedRow < self.items.count) {
            if (event.modifierFlags.contains(.command) && event.modifierFlags.contains(.option)) {
                // https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
                
                // Applied (a)
                if (event.keyCode == 0x00) {
                    ResultService.markApplied(a: self.items[self.selectedRow]);
                }
                    
                // Offered (o)
                else if (event.keyCode == 0x1F) {
                    ResultService.markOferred(a: self.items[self.selectedRow]);
                }
                    
                // Accepted (d)
                else if (event.keyCode == 0x02) {
                    ResultService.markAccepted(a: self.items[self.selectedRow]);
                }
                
                // Rejected (r)
                else if (event.keyCode == 0x0F) {
                    ResultService.markRejected(a: self.items[self.selectedRow]);
                }
                
                // Archived (i)
                else if (event.keyCode == 0x22) {
                    self.items[self.selectedRow].state = .ARCHIVED;
                    ResultService.updateResult(a: self.items[self.selectedRow]);
                }
            }
            else if (event.modifierFlags.contains(.command) && event.keyCode == 51) {
                if (self.selectedRow != self.editedRow) {
                    _ = DataService.getInstance().runServiceQuery(query: "DELETE FROM RESULT WHERE RESULT_ID = '\(self.items[self.selectedRow].resultId)'");
                    GUIService.refreshAll();
                }
            }
        }
    }
    
    public func refresh() {
        self.items = ResultService.getResults(a: Helper.currentCompany);
        self.reloadData();
    }
}

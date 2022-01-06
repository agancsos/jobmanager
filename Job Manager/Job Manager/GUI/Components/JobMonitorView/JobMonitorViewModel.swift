//
//  JobMonitorViewModel.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/10/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class JobMonitorViewModel : NSView, NSTableViewDataSource, NSTableViewDelegate {
    private var splitView1      : NSSplitView = NSSplitView.init();
    private var splitView2      : NSSplitView = NSSplitView.init();
    private var splitView3      : NSSplitView = NSSplitView.init();
    private var resultsView     : ResultsViewModel = ResultsViewModel.init();
    private var filterEditor    : FilterEditorViewModel = FilterEditorViewModel.init();
    private var companiesView   : NSTableView = NSTableView.init();
    private var nameColumn      : NSTableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "CompanyName"));
    private var companies       : [Company] = [];
    private var refreshCount    : Int = 0;


    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        nameColumn.title = "";
        self.initializeLayout();
        self.splitView1.setPosition(300, ofDividerAt: 0);
        self.companiesView.delegate = self;
        self.companiesView.dataSource = self;
        self.companiesView.target = self;
        self.autoresizesSubviews = true;
        //self.splitView3.autoresizesSubviews = true;
        self.refresh();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeLayout() {
        self.splitView1 = NSSplitView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 30));
        self.splitView1.frame.size.height -= 2;
        self.nameColumn.title = "";
        self.splitView1.isVertical = true;
        self.splitView2 = NSSplitView(frame: NSRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height));
        self.splitView2.isVertical = false;
        self.splitView1.subviews.append(self.splitView2);
        self.splitView3 = NSSplitView(frame: NSRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height));
        self.splitView3.isVertical = false;
        self.splitView3.subviews.append(NSScrollView(frame: self.splitView1.frame));
        self.splitView1.autoresizesSubviews = true;
        self.splitView3.autoresizesSubviews = true;
        self.splitView3.subviews.append(NSScrollView(frame: self.frame));
        self.splitView3.autoresizingMask = [.width];
        self.splitView1.autoresizingMask = [.width, .height];
        self.splitView1.subviews.append(self.splitView3);
        self.subviews.append(self.splitView1);
        self.initializeLeftPane();
        self.initializeRightPane();
        self.companiesView.selectionHighlightStyle = .regular;
        self.resultsView.selectionHighlightStyle = .regular;
        (self.splitView1.subviews[0] as? NSScrollView)?.documentView?.focusRingType = .none;
        (self.splitView1.subviews[1] as? NSScrollView)?.documentView?.focusRingType = .none;
        (self.splitView3.subviews[0] as? NSScrollView)?.documentView?.focusRingType = .none;
        (self.splitView3.subviews[1] as? NSScrollView)?.documentView?.focusRingType = .none;
    }
    
    private func initializeLeftPane() {
        self.companiesView = NSTableView(frame: self.frame);
        self.companiesView.setAccessibilityIdentifier("companies");
        self.companiesView.headerView = NSTableHeaderView();
        self.companiesView.addTableColumn(self.nameColumn);
        self.companiesView.usesAlternatingRowBackgroundColors = true;
        self.companiesView.doubleAction = #selector(doubleClick);
        self.splitView2.subviews.append(NSScrollView());
        self.splitView2.subviews.append(NSScrollView());
        (self.splitView2.subviews[0] as? NSScrollView)?.documentView = self.companiesView;
        (self.splitView2.subviews[0] as? NSScrollView)?.documentView?.focusRingType = .none;
        self.filterEditor = FilterEditorViewModel(frame: self.splitView1.frame);
        (self.splitView2.subviews[1] as? NSScrollView)?.documentView?.focusRingType = .none;
        (self.splitView2.subviews[1] as? NSScrollView)?.documentView = self.filterEditor;
    }
    
    private func initializeRightPane() {
        self.resultsView = ResultsViewModel(frame: self.splitView1.frame);
        self.resultsView.selectionHighlightStyle = .none;
        ((self.splitView1.subviews[1] as? NSSplitView)?.subviews[0] as? NSScrollView)?.documentView = self.resultsView;
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.companies.count;
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30;
    }
        
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if (tableView.accessibilityIdentifier() == "companies") {
            var view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CompanyName"), owner: self) as? NSTableCellView;
            if (view == nil) {
                view = NSTableCellView();
                view?.identifier = NSUserInterfaceItemIdentifier(rawValue: "CompanyName");
                let imageView = NSImageView(image: NSImage(contentsOfFile: Bundle.main.path(forResource: "default.png", ofType: "")!)!);
                imageView.frame = NSRect(x: 0, y: 0, width: 30, height: 30);
                view?.addSubview(imageView);
                view?.imageView = imageView;
                let textField = NSTextField(string: "\(self.companies[row].name)");
                textField.frame = NSRect(x: view?.imageView?.frame.size.width ?? 0, y: 0, width: tableView.frame.size.width, height: 30.0);
                textField.autoresizingMask = [.width];
                textField.isEditable = false;
                view?.addSubview(textField);
                view?.textField = textField;
            }
            var image = NSImage(contentsOfFile: Bundle.main.path(forResource: "default.png", ofType: "")!);
            if (Int(Helper.store.getProperty(key: SR.keyCheckWebIcon) as? String ?? "0") ?? 0 > 0 && !self.companies[row].description.lowercased().contains("#uselocalicon")) {
                image = NSImage(contentsOf: (URL(string: IconExtractor.extractUrl(url: "http://www.\(self.companies[row].name.lowercased()).com")))!);
            }
            view?.textField?.stringValue = "\(self.companies[row].name)";
            view?.imageView?.image = image;
            return view;
        }
        return nil;
    }

    public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        return true;
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        if (companiesView.selectedRow > -1 && companiesView.selectedRow < self.companies.count) {
            Helper.currentCompany = self.companies[self.companiesView.selectedRow];
        }
        self.resultsView.refresh();
    }
    
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false;
    }
    
    public override func keyDown(with event: NSEvent) {
        if (self.companiesView.selectedRow > -1 && self.companiesView.selectedRow < self.companies.count) {
            if (self.companiesView.editedRow == self.companiesView.selectedRow) {
                //return;
            }
            if (event.modifierFlags.contains(.command)) {
                if (event.charactersIgnoringModifiers ?? "" == "d") {
                    _ = DataService.getInstance().runServiceQuery(query: "DELETE FROM RESULT WHERE COMPANY_ID = '\(self.companies[self.companiesView.selectedRow].companyId)'");
                    _ = DataService.getInstance().runServiceQuery(query: "DELETE FROM COMPANY WHERE COMPANY_ID = '\(self.companies[self.companiesView.selectedRow].companyId)'");
                    self.refresh();
                }
            }
        }
    }
    
    @objc private func doubleClick(sender : Any?) {
        if ((sender as? NSTableView)?.accessibilityIdentifier() == "companies") {
            if ((Helper.store.getProperty(key: "EnableEditWindows") as? String ?? "0") == "1") {
                let window : EditObjectWindowModel = EditObjectWindowModel.init(contentRect:CGRect(x: 200, y: 200, width: 800, height: 600), styleMask: [.titled, .closable], backing: .buffered, defer: false);
                window.setObject(item: self.companies[self.companiesView.selectedRow]);
                window.show();
            }
            else {
                let editView = EditObjectViewModel(frame: CGRect(x: 0, y: 0, width: self.splitView1.frame.width, height: self.splitView1.frame.height));
                editView.autoresizingMask = [.height, .width];
                editView.setObject(item: self.companies[self.companiesView.selectedRow]);
                GUIService.setViewModel(viewModel: editView);
            }
        }
    }
    
    @objc public func refresh(fullList: Bool = false) {
        self.companies = CompanyService.getCompanies();
        if (fullList) {
            Helper.currentCompany = Company();
        }
        self.splitView1.frame = NSRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 20);
        self.splitView3.autoresizingMask = [.width, .height];
        self.splitView1.autoresizesSubviews = true;
        self.splitView3.autoresizesSubviews = true;
        self.companiesView.reloadData();
        self.resultsView.refresh();
        self.filterEditor.refresh();
        self.refreshCount += 1;
    }
    
    public func setAddViewModel(viewModel: AddObjectViewModel) {
        let orgFrame = NSRect(x: 0, y: 0, width: self.splitView3.frame.size.width, height: self.splitView3.frame.size.height);
        viewModel.frame = orgFrame;
        (self.splitView3.subviews[1] as? NSScrollView)?.documentView = viewModel;
        viewModel.autoresizingMask = [.width, .maxXMargin];
        viewModel.reloadFields();
        (self.splitView3.subviews[1] as? NSScrollView)?.documentView?.scroll(CGPoint(x: 0, y: self.splitView3.subviews[1].frame.maxY));
    }
    
    public func setEditViewModel(viewModel: EditObjectViewModel) {
        let orgFrame = NSRect(x: 0, y: 0, width: self.splitView3.frame.size.width, height: self.splitView3.frame.size.height);
        viewModel.frame = orgFrame;
        (self.splitView3.subviews[1] as? NSScrollView)?.documentView = viewModel;
        viewModel.autoresizingMask = [.width, .maxXMargin];
        viewModel.reloadFields();
        (self.splitView3.subviews[1] as? NSScrollView)?.documentView?.scroll(CGPoint(x: 0, y: self.splitView3.subviews[1].frame.maxY));
    }
    
    public func getResultsView() -> ResultsViewModel { return self.resultsView; }
}

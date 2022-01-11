//
//  CustomActionService.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/15/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common
import Cocoa
import JobManager

public class CustomActionService {
    public static var mainMenu        : NSMenu = NSMenu.init();
    public static var logViewerWindow : LogWindow = LogWindow.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless, .closable, .resizable], backing: .buffered, defer: false);
    public static var dashboardWIndow : ApplicantDashboardWindow = ApplicantDashboardWindow.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless, .closable, .resizable], backing: .buffered, defer: false);
    private static var feedbackWindow : FeedbackViewModel = FeedbackViewModel.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless], backing: .buffered, defer: false);
    
    
    
    public static func setCustomMenuOptions() {
        // About
        mainMenu.item(withTitle: "\(SR.applicationName)")?.submenu?.item(withTitle: "About \(SR.applicationName)")?.action = #selector(showAbout);
        mainMenu.item(withTitle: "\(SR.applicationName)")?.submenu?.item(withTitle: "About \(SR.applicationName)")?.target = self;
        
        // Feedback
        mainMenu.item(withTitle: "\(SR.applicationName)")?.submenu?.addItem(NSMenuItem(title: "Feedback", action: #selector(showFeedback), keyEquivalent: ""));
        mainMenu.item(withTitle: "\(SR.applicationName)")?.submenu?.item(withTitle: "Feedback")?.target = self;
        
        // Refresh
        mainMenu.item(withTitle: "Window")?.submenu?.addItem(NSMenuItem(title: "Refresh", action: #selector(refresh), keyEquivalent: "R"));
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Refresh")?.target = self;
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Refresh")?.keyEquivalentModifierMask = [.command, .shift];
        
        mainMenu.item(withTitle: "Window")?.submenu?.addItem(NSMenuItem(title: "Refresh with Full List", action: #selector(refresh), keyEquivalent: "R"));
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Refresh with Full List")?.target = self;
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Refresh with Full List")?.keyEquivalentModifierMask = [.option, .command];
        
        // Log Viewer
        mainMenu.item(withTitle: "Window")?.submenu?.addItem(NSMenuItem(title: "Log Viewer", action: #selector(showLogViewer), keyEquivalent: "L"));
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Log Viewer")?.target = self;
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Log Viewer")?.keyEquivalentModifierMask = [.command];
        
        // Dashboard
        mainMenu.item(withTitle: "Window")?.submenu?.addItem(NSMenuItem(title: "Dashboard", action: #selector(showDashboard), keyEquivalent: "D"));
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Dashboard")?.target = self;
        mainMenu.item(withTitle: "Window")?.submenu?.item(withTitle: "Dashboard")?.keyEquivalentModifierMask = [.command, .option];
        
        mainMenu.item(withTitle: "File")?.submenu?.addItem(NSMenuItem(title: "Open", action: #selector(showOpen), keyEquivalent: "o"));
        mainMenu.item(withTitle: "File")?.submenu?.item(withTitle: "Open")?.target = self;
        mainMenu.item(withTitle: "File")?.submenu?.item(withTitle: "Open")?.keyEquivalentModifierMask = [.command];
        
        // Adds
        mainMenu.item(withTitle: "Edit")?.submenu?.addItem(NSMenuItem(title: "Add Company", action: #selector(showAddCompany), keyEquivalent: "c"));
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Add Company")?.target = self;
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Add Company")?.keyEquivalentModifierMask = [.option, .control];
        
        mainMenu.item(withTitle: "Edit")?.submenu?.addItem(NSMenuItem(title: "Add Position", action: #selector(showAddPosition), keyEquivalent: "p"));
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Add Position")?.target = self;
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Add Position")?.keyEquivalentModifierMask = [.option, .control];
        
        mainMenu.item(withTitle: "Edit")?.submenu?.addItem(NSMenuItem(title: "Export", action: #selector(showExport), keyEquivalent: "e"));
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Export")?.target = self;
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Export")?.keyEquivalentModifierMask = [.command];
        
        mainMenu.item(withTitle: "Edit")?.submenu?.addItem(NSMenuItem(title: "Import", action: #selector(showImport), keyEquivalent: "i"));
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Import")?.target = self;
        mainMenu.item(withTitle: "Edit")?.submenu?.item(withTitle: "Import")?.keyEquivalentModifierMask = [.command];

        mainMenu.items.first?.submenu?.item(withTitle: "Preferences…")?.target = self;
        mainMenu.items.first?.submenu?.item(withTitle: "Preferences…")?.action = #selector(showPreferences);
    }
    
    @objc public static func showAbout(sender : Any?) {
    }
    
    @objc public static func showFeedback(sender : Any?) {
        feedbackWindow = FeedbackViewModel.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless], backing: .buffered, defer: true);
        feedbackWindow.show();
    }
    
    @objc public static func refresh(sender : Any?) {
        GUIService.changeApplicationView(view: JobMonitorViewModel(frame: CGRect(x: 0, y: 0, width: GUIService.mainView.frame.size.width, height: GUIService.mainView.frame.size.height)));
        if ((sender as? NSMenuItem != nil && (sender as! NSMenuItem).title == "Refresh with Full List")) {
            GUIService.refreshAll(fullList: true)
        }
        else {
            GUIService.refreshAll();
        }
    }
        
    @objc public static func showLogViewer(sender : Any?) {
        logViewerWindow = LogWindow.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless, .closable, .resizable], backing: .buffered, defer: true);
        logViewerWindow.show();
        logViewerWindow.refresh();
    }
    
    @objc public static func showDashboard(sender : Any?) {
        if ((Helper.store.getProperty(key: "EnableEditWindows") as? String ?? "0") == "1") {
            dashboardWIndow = ApplicantDashboardWindow.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .borderless, .closable, .resizable], backing: .buffered, defer: true);
            dashboardWIndow.show();
            dashboardWIndow.refresh();
        }
        else {
            let viewModel = ApplicantDashboardViewModel(frame: CGRect(x: 0, y: 0, width: GUIService.mainView.frame.size.width, height: GUIService.mainView.frame.size.height));
            GUIService.changeApplicationView(view: viewModel);
            viewModel.refresh();
        }
    }
    
    @objc public static func showAddCompany(sender : Any?) {
        if ((Helper.store.getProperty(key: SR.keyEnableEditWindow) as? String ?? "0") == "1") {
            let window : AddObjectWindowModel = AddObjectWindowModel.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .closable], backing: .buffered, defer: false);
            window.setObject(item: Company());
            window.show();
        }
        else {
            let viewModel = AddObjectViewModel();
            viewModel.setObject(item: Company());
            GUIService.setViewModel(viewModel: viewModel);
        }
    }
    
    @objc public static func showAddPosition(sender : Any?) {
        if ((Helper.store.getProperty(key: SR.keyEnableEditWindow) as? String ?? "0") == "1") {
            let window : AddObjectWindowModel = AddObjectWindowModel.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .closable], backing: .buffered, defer: false);
            window.setCompany(company: Helper.currentCompany);
            window.show();
        }
        else {
            let viewModel = AddObjectViewModel();
            viewModel.company = Helper.currentCompany;
            GUIService.setViewModel(viewModel: viewModel);
        }
    }
    
    @objc public static func showPreferences(sender : Any?) {
        let window : PreferenceWindowModel = PreferenceWindowModel.init(contentRect:CGRect(x: 200, y: 200, width: 600, height: 400), styleMask: [.titled, .closable], backing: .buffered, defer: false);
        window.show();
    }
    
    @objc public static func showExport(sender : Any?) {
        let pasteboard = NSPasteboard.general;
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(Helper.exportData(), forType: NSPasteboard.PasteboardType.string)
        GUIService.alert(message: "Exported data to clipboard", title: "Success", fontSize: 13.0);
    }
    
    @objc public static func showImport(sender : Any?) {
        var raw : String = GUIService.input(prompt: "Input data", defaultValue: "", frame: NSRect(x: 50, y: 50, width: 800, height: 500));
        Helper.importData(raw: raw);
    }
    
    @objc public static func showOpen(sender : Any?) {
        let dialog : NSOpenPanel = NSOpenPanel(contentRect: NSRect(x: 50, y: 50, width: 800, height: 200), styleMask: [.titled, .closable], backing: .retained, defer: false);
        dialog.title = "Open Jobs file";
        dialog.allowedFileTypes = ["jm"]
        if (dialog.runModal() == .OK) {
            if (dialog.url != nil && dialog.url?.absoluteString != "") {
                Helper.updateDataService(path: dialog.url!.absoluteString);
                GUIService.refreshAll();
            }
        }
    }
}


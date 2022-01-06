//
//  GUIService.swift
//  Job Monitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class GUIService {
    public static var mainView = NSApp.mainWindow?.contentView as? MainController ?? MainController();
    
    public static func changeApplicationView(view : NSView) {
        mainView.setApplicationView(view: view);
    }
    
    public static func refreshAll(fullList: Bool = false) {
        for window : NSWindow in NSApplication.shared.windows {
            if (window.title == SR.applicationName) {
                ((window.contentView! as! MainController).getApplicationView() as? JobMonitorViewModel)?.refresh(fullList: fullList);
            }
            else if (window.title == "Log Viewer") {
                (window as! LogWindow).refresh();
            }
            else if (window.title == "Applicant Dashboard") {
                (window as! ApplicantDashboardWindow).refresh();
            }
        }
    }
    
    public static func setViewModel(viewModel: AddObjectViewModel) {
        for window : NSWindow in NSApplication.shared.windows {
            if (window.title == SR.applicationName) {
                ((window.contentView! as! MainController).getApplicationView() as? JobMonitorViewModel)?.setAddViewModel(viewModel: viewModel);
            }
        }
    }
    
    public static func setViewModel(viewModel: EditObjectViewModel) {
        for window : NSWindow in NSApplication.shared.windows {
            if (window.title == SR.applicationName) {
                ((window.contentView! as! MainController).getApplicationView() as? JobMonitorViewModel)?.setEditViewModel(viewModel: viewModel);
            }
        }
    }
    
    /// Prompt user for input
    ///
    /// - Parameters:
    ///   - prompt: Message to display in prompt
    ///   - defaultValue: Default value to us in the prompt
    ///   - frame: Size and location of the message box
    /// - Returns: New string value from the user input
    public static func input(prompt : String, defaultValue : String, frame: NSRect) -> String{
        let alert : NSAlert = NSAlert();
        alert.messageText = prompt;
        alert.alertStyle = .informational;
        alert.addButton(withTitle: "OK");
        alert.addButton(withTitle: "Cancel");
        
        let input : NSTextField = NSTextField(frame: frame);
        input.stringValue = defaultValue;
        alert.accessoryView = input;
        input.needsUpdateConstraints = false;
        let button = alert.runModal();
        if(button == .OK){
            input.validateEditing();
            return input.stringValue;
        }
        return "";
    }
    
    /// Displays a popup message
    ///
    /// - Parameters:
    ///   - message: Message to display
    ///   - title: Title for message box
    ///   - fontSize: Size of the text
    public static func alert(message : String,title : String, fontSize : CGFloat){
        let alert : NSAlert = NSAlert();
        alert.window.title = title ;
        alert.messageText = "";
        alert.informativeText = message ;
        alert.alertStyle = NSAlert.Style.warning;
        alert.addButton(withTitle: "Close");
        let views : [NSView] = alert.window.contentView!.subviews;
        let titleFont : NSFont = NSFont(name: "Arial", size: fontSize + 1)!;
        let font : NSFont = NSFont(name: "Arial", size: fontSize)!;
        (views[4] as! NSTextField).font = titleFont;
        (views[5] as! NSTextField).font = font;
        alert.runModal();
    }
    
    public static func getFields(a : Item) -> [FormField] {
        if (a as? Company != nil) {
            return [
                FormField(t: .TEXTFIELD, l: "ID", v: ["\((a as! Company).companyId)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "NAME", v: [(a as! Company).name], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "RATING", v: ["\((a as! Company).rating)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "INDUSTRY", v: [(a as! Company).industry], o: [], e: true),
                FormField(t: .TEXTAREA, l: "DESCRIPTION", v: [(a as! Company).description], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "EMPLOYEES", v: ["\((a as! Company).employees)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "ENDPOINT", v: ["\((a as! Company).applicantEndpoint)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STREET", v: [(a as! Company).street], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "CITY", v: [(a as! Company).city], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STATE", v: [(a as! Company).state], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "COUNTRY", v: [(a as! Company).country], o: [], e: true),
                FormField(t: .SWITCH, l: "ISPUBLIC", v: [(a as! Company).isPublic], o: ["true", "false"], e: true),
                FormField(t: .TEXTFIELD, l: "LASTUPDATEDATE", v: [(a as! Company).lastUpdatedDate], o: [], e: false)
            ];
        }
        else if (a as? Result != nil) {
            return [
                FormField(t: .TEXTFIELD, l: "ID", v: ["\((a as! Result).resultId)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "CODE", v: [(a as! Result).code], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "TITLE", v: [(a as! Result).title], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "COMPANY", v: [(a as! Result).company.name], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "BASEENDPOINT", v: [(a as! Result).baseEndpoint.baseUrl], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "SOURCE", v: [(a as! Result).sourceEndpoint], o: [], e: true),
                FormField(t: .TEXTAREA, l: "DESCRIPTION", v: [(a as! Result).description], o: [], e: true),
                FormField(t: .TEXTAREA, l: "REQUIRED", v: [(a as! Result).required], o: [], e: true),
                FormField(t: .TEXTAREA, l: "OPTIONAL", v: [(a as! Result).optional], o: [], e: true),
                FormField(t: .TEXTAREA, l: "BENEFITS", v: [(a as! Result).benefits], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "POSTED", v: [(a as! Result).postedDate], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "MINYEARS", v: ["\((a as! Result).minYearsNeeded)"], o: [], e: true),
                FormField(t: .TEXTAREA, l: "OTHER", v: [(a as! Result).otherDetails], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STATE", v: ["\((a as! Result).state)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "LASTUPDATEDDATE", v: [(a as! Result).lastUpdatedDate], o: [], e: false)
            ];
        }
        else {
            return [];
        }
    }
    
    public static func setValues(item : Item, fields : [NSView]) {
        if (item as? Company != nil) {
            let companyItem = item as! Company;
            fields.forEach({
                switch ($0.identifier?.rawValue) {
                    case "NAME": companyItem.name = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "RATING": companyItem.rating = Float(($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''")) ?? 0.0; break;
                    case "INDUSTRY": companyItem.industry = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "DESCRIPTION": companyItem.description = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    case "ENDPOINT": companyItem.applicantEndpoint = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "EMPLOYEES": companyItem.employees = Int(($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''")) ?? 0; break;
                    case "STREET": companyItem.street = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "CITY": companyItem.city = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "STATE": companyItem.state = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "COUNTRY": companyItem.country = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "ISPUBLIC": companyItem.isPublic = (($0 as! NSSegmentedControl).selectedSegment == 0 ? true : false); break;
                    default: break;
                }
            });
            if (companyItem.companyId > 0) {
                CompanyService.updateCompany(a: companyItem);
            }
            else {
                CompanyService.addCompany(a: companyItem)
            }
        }
        else if (item as? Result != nil) {
            let resultItem = item as! Result;
            fields.forEach({
                switch ($0.identifier?.rawValue) {
                    case "TITLE": resultItem.title = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "CODE": resultItem.code = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "SOURCE": resultItem.sourceEndpoint = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "DESCRIPTION": resultItem.description = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    case "REQUIRED": resultItem.required = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    case "OPTIONAL": resultItem.optional = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    case "BENEFITS": resultItem.benefits = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    case "POSTED": resultItem.postedDate = ($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''"); break;
                    case "MINYEARS": resultItem.minYearsNeeded = Int(($0 as! NSTextField).stringValue.replacingOccurrences(of: "'", with: "''")) ?? 0; break;
                    case "OTHER": resultItem.otherDetails = ($0 as! NSTextView).string.replacingOccurrences(of: "'", with: "''"); break;
                    default: break;
                }
            });
            if (resultItem.resultId > 0) {
                ResultService.updateResult(a: resultItem);
            }
            else {
                ResultService.addResult(a: resultItem)
            }
        }
        refreshAll();
    }
}

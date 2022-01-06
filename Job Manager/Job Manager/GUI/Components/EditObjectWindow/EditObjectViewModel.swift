//
//  EditObjectViewModel.swift
//  Job Manager
//
//  Created by Abel Gancsos on 12/11/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import Common
import JobManager

public class EditObjectViewModel : NSView {
    private var item            : Item = Result();
    private var fields          : [FormField] = [];
    private var fields2         : [NSView] = [];
    public var company          : Company = Helper.currentCompany;
    private var isWindow = Helper.store.getProperty(key: SR.keyEnableEditWindow) as! String == "1";
    
    public init() {
        super.init(frame: NSRect.zero);
        self.prepare();
        self.autoresizesSubviews = true;
        self.autoresizingMask = [.width];
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.prepare();
        self.autoresizesSubviews = true;
        self.autoresizingMask = [.width];
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepare() {
        for cursor : NSView in self.subviews {
            cursor.removeFromSuperview();
        }
        self.fields = GUIService.getFields(a : self.item);
        var i = 0;
        for field : FormField in self.fields {
            let label : Label = Label(frame: CGRect(x: 0.0, y: self.frame.height - 70 - CGFloat((i * 30)) + 30.0, width: self.frame.size.width / 3.0, height: 30.0));
            label.stringValue = field.label.uppercased();
            label.isBordered = true;
            label.font = NSFont(name: "Times New Roman", size: 20.0);
            label.autoresizingMask = [.height, .maxXMargin];
            self.addSubview(label);
            
            switch (field.type) {
                case .TEXTFIELD:
                    let temp : NSTextField = NSTextField(frame: CGRect(x: self.frame.size.width / 3.0,
                            y: self.frame.height - 70 - CGFloat((i * 30)) + 30.0,
                            width: self.frame.size.width - self.frame.size.width / 3.0, height: 30));
                    temp.isEditable = field.editable;
                    temp.isSelectable = true;
                    temp.stringValue = field.value[0] as! String;
                    temp.focusRingType = .none;
                    temp.autoresizingMask = [.height, .maxXMargin, .width];
                    temp.backgroundColor = NSColor(calibratedRed: CGFloat(arc4random() % 255 + 1)/255.0, green: CGFloat(arc4random() % 255 + 1)/255.0, blue: CGFloat(arc4random() % 255 + 1)/255.0, alpha: 0.5);
                    temp.font = NSFont(name: "Times New Roman", size: 20.0);
                    temp.identifier = NSUserInterfaceItemIdentifier(field.label.uppercased());
                    self.fields2.append(temp);
                    self.addSubview(temp);
                    break;
                case .TEXTAREA:
                    let root = NSScrollView(frame: CGRect(x: self.frame.size.width / 3.0,
                                                          y: self.frame.height - 70 - CGFloat((i * 30)) + 30.0,
                                                          width: self.frame.size.width - self.frame.size.width / 3.0, height: 30));
                    let temp : NSTextView = NSTextView(frame: frame);
                    temp.isEditable = field.editable;
                    temp.isSelectable = true;
                    temp.backgroundColor = NSColor(calibratedRed: CGFloat(arc4random() % 255 + 1)/255.0, green: CGFloat(arc4random() % 255 + 1)/255.0, blue: CGFloat(arc4random() % 255 + 1)/255.0, alpha: 0.5);
                    temp.string = field.value[0] as! String;
                    temp.focusRingType = .none;
                    temp.autoresizingMask = [.height, .maxXMargin, .width];
                    root.autoresizingMask = [.height, .maxXMargin, .width];
                    temp.isVerticallyResizable = false;
                    temp.isHorizontallyResizable = false;
                    temp.enclosingScrollView?.hasVerticalScroller = true;
                    root.documentView = temp;
                    temp.font = NSFont(name: "Times New Roman", size: 12.0);
                    temp.identifier = NSUserInterfaceItemIdentifier(field.label.uppercased());
                    self.fields2.append(temp);
                    self.addSubview(root);
                    break;
                case .SWITCH:
                    let temp : NSSegmentedControl = NSSegmentedControl(labels: field.options as! [String], trackingMode: .selectOne, target: self, action: nil);
                    temp.frame = CGRect(x: self.frame.size.width / 3.0,
                        y: self.frame.height - 70 - CGFloat((i * 30)) + 30.0,
                        width: self.frame.size.width - self.frame.size.width / 3.0, height: 30);
                    if (field.value[0] as? Bool != nil) {
                        temp.selectedSegment = ((field.value[0] as! Bool) == true ? 0 : 1);
                    }
                    temp.focusRingType = .none;
                    temp.font = NSFont(name: "Times New Roman", size: 12.0);
                    //temp.isEnabled = field.editable;
                    temp.autoresizingMask = [.height, .maxXMargin, .width];
                    temp.identifier = NSUserInterfaceItemIdentifier(field.label.uppercased());
                    self.fields2.append(temp);
                    self.addSubview(temp);
                    break;
                default:
                    break;
            }
            //self.subviews.append(field);
            i += 1;
        }
        let saveButton : NSButton = NSButton(frame: CGRect(x: 0.0, y: self.frame.height - 70 - CGFloat((i * 30)) + 20.0, width: self.frame.size.width / 2, height: 40))
        saveButton.action = #selector(saveObject);
        saveButton.title = "Save"
        saveButton.target = self;
        saveButton.isBordered = false;
        saveButton.autoresizingMask = [.width, .maxXMargin];
        saveButton.wantsLayer = true;
        saveButton.layer?.backgroundColor = NSColor.gray.cgColor;
        let resetButton : NSButton = NSButton(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.height - 70 - CGFloat((i * 30)) + 20.0, width: self.frame.size.width / 2, height: 40))
        resetButton.action = #selector(reset);
        resetButton.target = self;
        resetButton.autoresizingMask = [.width, .minXMargin, .maxXMargin];
        resetButton.title = "Reset";
        resetButton.isBordered = false;
        resetButton.wantsLayer = true;
        resetButton.layer?.backgroundColor = NSColor.red.cgColor;
        self.addSubview(saveButton);
        self.addSubview(resetButton);
        var j = 0;
        for view : NSView in self.subviews {
            if (j < self.subviews.count - 1) {
                view.nextKeyView = self.subviews[j + 1];
            }
            else {
                view.nextKeyView = self.subviews[0];
            }
            j+=1;
        }
    }
    
    private func findField(name : String) -> NSView? {
        for cursor : NSView in self.fields2 {
            if (cursor.identifier!.rawValue.uppercased() == name.uppercased()) {
                return cursor;
            }
        }
        return nil;
    }

    @objc private func saveObject(sender : Any?) {
        GUIService.setValues(item: self.item, fields: self.fields2);
        if (self.item as? Company != nil) {
            self.setObject(item: CompanyService.getCompany(id: (self.item as! Company).companyId));
        }
        else {
            self.setObject(item: ResultService.getResult(id: (self.item as! Result).resultId));
        }
    }
    
    @objc private func reset(sender : Any?) {
        for field : FormField in self.fields {
            field.value = [""];
        }
    }

    
    public func setObject(item : Item) {
        self.item = item;
        for textField in self.subviews {
            if ((textField as? NSTextField) != nil || (textField as? NSTextView) != nil) {
                textField.removeFromSuperview();
            }
        }
        self.prepare();
    }
    
    public func reloadFields() {
        self.prepare();
    }
}

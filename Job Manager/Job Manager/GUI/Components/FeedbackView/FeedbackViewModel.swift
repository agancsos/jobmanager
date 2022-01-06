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

public class FeedbackViewModel : NSWindow {
    var feedbackBaseEndpoint : String = "http://api.abelgancsos.com:1137/feedback.php";
    var feedbackInputView    : NSTextView = NSTextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
    var cancelButton         : NSButton = NSButton(title: "", target: nil, action: nil);
    var submitButton         : NSButton = NSButton(title: "", target: nil, action: nil);
    var buttonHeight         : CGFloat = 40;
    
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
    
    private func addFeedbackView() {
        self.feedbackInputView = NSTextView(frame:
            CGRect(x: 0,
                   y: self.buttonHeight,
                   width: self.frame.size.width,
                   height: self.frame.size.height - self.buttonHeight - 30));
        self.feedbackInputView.autoresizingMask = [.width, .height];
        self.feedbackInputView.isSelectable = true;
        self.feedbackInputView.isEditable = true;
        self.feedbackInputView.font = NSFont(name: "Times New Roman", size: 14);
        self.contentView?.addSubview(self.feedbackInputView);
    }
    
    private func addCancelButton() {
        self.cancelButton = NSButton(title: "Cancel", target: self, action: #selector(cancelFeedback));
        self.cancelButton.frame = CGRect(
            x: 0,
            y: 0,
            width: self.contentView!.frame.size.width / 2,
            height: self.buttonHeight);
        self.cancelButton.autoresizingMask = [.width, .height];
        self.cancelButton.isBordered = false;
        self.cancelButton.wantsLayer = true;
        self.cancelButton.layer?.backgroundColor = NSColor(deviceRed: 0.5, green: 0.0, blue: 0.0, alpha: 1.0).cgColor;
        self.contentView?.addSubview(self.cancelButton);
    }
    
    private func addSubmitButton() {
        self.submitButton = NSButton(title: "Submit", target: self, action: #selector(submitFeedback));
        self.submitButton.frame = CGRect(
            x: self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width,
            y: self.cancelButton.frame.origin.y,
            width: self.cancelButton.frame.size.width,
            height: self.cancelButton.frame.size.height);
        self.submitButton.autoresizingMask = [.width, .height];
        self.submitButton.isBordered = false;
        self.submitButton.wantsLayer = true;
        self.submitButton.layer?.backgroundColor = NSColor(deviceRed: 0.0, green: 0.5, blue: 0.0, alpha: 1.0).cgColor;
        self.contentView?.addSubview(self.submitButton);
    }
    
    private func prepare() {
        self.title = "Feedback";
        self.isReleasedWhenClosed = false;
        self.addFeedbackView();
        self.addCancelButton();
        self.addSubmitButton();
    }
    
    public func show() {
        self.makeKeyAndOrderFront(self);
    }
    
    @objc func cancelFeedback() {
        self.feedbackInputView.string = "";
        self.close();
    }
    
    @objc func submitFeedback() {
        let urlPath : String = String(format:"%@?m=add&a=%@&t=%@",
                                      self.feedbackBaseEndpoint,
                                      SR.applicationName.replacingOccurrences(of: " ", with: "+"),
                                      SystemService.urlEncode(text: feedbackInputView.string));
        var response : String = "";
        do {
            try response = NSString(contentsOf: URL(string: urlPath)!, encoding: String.Encoding.utf8.rawValue) as String;
        }
        catch { }
        if(response == "SUCCESS"){
            self.feedbackInputView.string = "";
            GUIService.alert(message: SR.successFeedback, title: "Success", fontSize: CGFloat(SR.alertFontSize));
        }
        else {
            GUIService.alert(message: SR.failureFeedback, title: "Failure", fontSize: CGFloat(SR.alertFontSize));
        }
    }
}

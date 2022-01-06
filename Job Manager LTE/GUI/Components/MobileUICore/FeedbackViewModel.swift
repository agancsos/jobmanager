//
//  MobileFeedbackViewModel.swift
//
//  Created by Abel Gancsos on 11/20/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

class FeedbackViewModel : MobileFeatureViewModel {
    var feedbackBaseEndpoint : String = "http://safe.abelgancsos.com:1137/api/feedback.php";
    var feedbackInputView : UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.prepare();
    }
    
    override init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.prepare();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addFeedbackInput() {
        self.feedbackInputView = UITextView(frame:
            CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.feedbackInputView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.feedbackInputView.font = UIFont(name: "Courier New", size: 16);
        self.addSubview(self.feedbackInputView);
    }
    
    private func setRightButton() {
        self.rightBarItem = UIBarButtonItem(
            title: "Submit",
            style: .plain,
            target: self,
            action: #selector(submitFeedback));
    }
    
    internal override func prepare() {
        super.prepare();
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        self.featureModel = FeatureModel(name: "Feedback", label: "Feedback", display: true);
        self.setRightButton();
        self.addFeedbackInput();
    }
    
    /**
      * Event handlers
      */
    @objc func submitFeedback() {
        ViewService.alert(message: "Test", title: "TEST");
        self.feedbackInputView.text = "";
    }
}

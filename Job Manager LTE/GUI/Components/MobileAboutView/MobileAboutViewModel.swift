//
//  MobileAboutView.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/30/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Common

class MobileAboutViewModel : MobileFeatureViewModel {
    var versionLabel              : UILabel = UILabel();
    var copyrightLabel            : UILabel = UILabel();
	var copyrightVersionContainer : UIView = UIView();
    var aboutWebView              : WKWebView = WKWebView();
	var labelHeight               : Double = 10;
    
    override init() {
        super.init(frame: CGRect(x: 0, y: 150, width: 200, height: 150));
        self.prepare();
    }
    
    override init(frame : CGRect) {
        super.init(frame : frame);
        self.prepare();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
	private func addContainer() {
		self.copyrightVersionContainer = UIView(frame:
			CGRect(
				x: self.aboutWebView.frame.origin.x,
				y: (self.aboutWebView.frame.origin.y + self.aboutWebView.frame.size.height),
				width: self.frame.size.width,
				height: CGFloat(self.labelHeight)));
		self.copyrightVersionContainer.autoresizingMask = [.flexibleWidth, .flexibleTopMargin];
		self.copyrightVersionContainer.backgroundColor = UIColor.black;
		self.addSubview(self.copyrightVersionContainer);
	}
	
	private func addVersionLabel() {
		self.versionLabel = UILabel(frame:
			CGRect(x: self.copyrightLabel.frame.origin.x + self.copyrightLabel.frame.size.width,
				   y: self.copyrightLabel.frame.origin.y,
				   width: self.frame.size.width / 2,
				   height: self.copyrightLabel.frame.size.height));
		self.versionLabel.text = String(format: "v. %@", SystemService.getVersion().version());
        self.versionLabel.autoresizingMask = [.flexibleLeftMargin];
		self.versionLabel.backgroundColor = self.copyrightLabel.backgroundColor;
		self.versionLabel.textColor = self.copyrightLabel.textColor;
		self.versionLabel.textAlignment = .right;
		self.versionLabel.font = self.copyrightLabel.font;
		self.copyrightVersionContainer.addSubview(self.versionLabel);
	}
	
	private func addCopyrightLabel() {
		self.copyrightLabel = UILabel(frame:
			CGRect(x: 0,
				   y: 0,
				   width: self.copyrightVersionContainer.frame.size.width / 2,
				   height: CGFloat(labelHeight)));
		self.copyrightLabel.text = "(c) \(SystemService.getYear()) \(SR.copyrightLabelText)";
		self.copyrightLabel.backgroundColor = UIColor.black;
		self.copyrightLabel.textColor = UIColor.white;
		self.copyrightLabel.font = UIFont(name: SR.resourceDefaultTitleFont, size: 8);
		self.copyrightVersionContainer.addSubview(self.copyrightLabel);
	}
	
	private func addAboutTextView() {
        self.aboutWebView.frame = CGRect(x: 0,
                   y: 0,
                   width: self.frame.size.width,
                   height: (self.frame.size.height > 0 ? self.frame.size.height - CGFloat(self.labelHeight) : self.frame.size.height));
		self.aboutWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.addSubview(self.aboutWebView);
		if(SystemService.fileExists(path: Bundle.main.path(forResource: SR.aboutFileName, ofType: "html") ?? "")){
            self.aboutWebView.loadHTMLString(SystemService.readFile(path: Bundle.main.path(forResource: SR.aboutFileName, ofType: "html")!), baseURL: nil);
		}
	}
	
    internal override func prepare() {
        super.prepare();
		self.featureModel = FeatureModel(name: "About", label: "About", display: true);
		self.addAboutTextView();
		self.addContainer();
		self.addCopyrightLabel();
		self.addVersionLabel();
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
}

//
//  MobileFeatureViewModel.swift
//
//  Created by Abel Gancsos on 11/22/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

class MobileFeatureViewModel : UIView {
	var featureModel   : FeatureModel = FeatureModel();
    var frameSize      : CGSize  = CGSize(width: 0, height: 0);
    var rightBarItem   : UIBarButtonItem? = nil;
    var isActive       : Bool = false;
    
    init() {
        super.init(frame: CGRect.init(x : 0, y : 0, width : 0, height : 0));
        self.prepare();
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame);
        self.prepare();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func prepare() {
        if (ViewService.getRootController() != nil) {
            self.frameSize = ViewService.getMainController()!.applicationViewModel.frame.size;
        }
        self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.frameSize);
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
    
    public func setIsActive(active: Bool) { self.isActive = active; }
}

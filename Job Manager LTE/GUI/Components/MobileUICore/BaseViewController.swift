//
//  BaseViewControllers.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/30/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import Common

class BaseViewController : UIViewController {
    var toolbar               : UINavigationBar? = UINavigationBar();
    var navView               : MobileMenuViewModel = MobileMenuViewModel();
    var applicationViewModel  : UIView = UIView();
    var rightBarItem          : UIBarButtonItem? = nil;

    init() {
        super.init(nibName: nil, bundle: Bundle.main);
        self.prepare();
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        prepare();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.prepare();
        UIApplication.shared.isStatusBarHidden = false;
        if(UIApplication.shared.isStatusBarHidden) {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);
		self.navView.model.refreshFeatures();
		ViewService.changeApplicationView(feature: self.navView.model.features[0]);
        navView.refreshFeatures();
        self.toolbar!.topItem?.rightBarButtonItem?.target = navView.model.features[0];
        self.applicationViewModel.addSubview(navView.model.features[0]);
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: Bundle.main);
    }
    
    private func setToolbar() {
        self.toolbar!.frame = CGRect(x: 0,
                                     y: ViewService.getOriginY(),
                                     width: self.view.frame.size.width,
									 height: 44);
        ViewService.initialOrigin = ViewService.getOriginY();
        self.toolbar!.items?.append(UINavigationItem(title: Bundle.main.infoDictionary!["CFBundleName"] as! String));
        self.toolbar!.barTintColor = UIConfiguration.toolbarTintColor;
		self.toolbar!.isTranslucent = true;
        self.toolbar!.autoresizingMask = [.flexibleWidth];
        self.toolbar!.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIConfiguration.toolbarFontColor,
            NSAttributedString.Key.font : UIFont(name: RegistryPropertyStore().getProperty(key: SR.keyTitleFont) as! String, size: CGFloat(SR.resourceTitleFontSize)) ??
                UIFont(name: SR.resourceDefaultTitleFont, size: CGFloat(SR.resourceTitleFontSize)) as Any];
        self.view.addSubview(self.toolbar!);
    }
    
    private func addMenuItem() {
        self.toolbar?.topItem?.leftBarButtonItem = UIBarButtonItem(image:
            UIImage(contentsOfFile: Bundle.main.path(forResource: SR.resourceToolbarMenu,
            ofType: "png")!),
            style: UIBarButtonItem.Style.plain, target: self, action: #selector(openMenu));
        self.toolbar!.topItem?.leftBarButtonItem!.tintColor = UIConfiguration.menuItemTintColor;
    }
    	
    private func addNavigation() {
        self.navView = MobileMenuViewModel(frame :
            CGRect(x: 0,
                   y: self.applicationViewModel.frame.origin.y,
                   width: self.view.frame.size.width / 2,
				   height: self.applicationViewModel.frame.size.height));
        self.navView.autoresizingMask = self.applicationViewModel.autoresizingMask;
        self.navView.alpha = CGFloat(SR.resourceNavigationAlpha);
        self.view.addSubview(self.navView);
    }

	private func addApplicationView() {
		self.applicationViewModel = UIView(frame :
			CGRect(x: 0,
                   y: self.toolbar!.frame.origin.y + self.toolbar!.frame.size.height,
				   width: self.view.frame.size.width,
				   height: self.view.frame.size.height - (self.toolbar!.frame.origin.y + self.toolbar!.frame.size.height)));
        self.applicationViewModel.autoresizingMask = [.flexibleWidth, .flexibleHeight];
		if(RegistryPropertyStore().getProperty(key: "#GUI.Layout.Debug.Window") as! String == "1") {
			self.applicationViewModel.backgroundColor = UIColor.red;
		}
		self.view.addSubview(self.applicationViewModel);
	}
    
    /**
 	 * Despite this method being officially deprecated as of IOS 9, this method is
 	 * required for CORRECTIVE code.  With the newlly recommended willTransform method,
 	 * the operation is PREVENTATIVE, which does nothing to correct issues.
 	 */
    override func didRotate(from fromInterfaceOrientation : UIInterfaceOrientation) {
        //super.didRotate(from: fromInterfaceOrientation);
        self.toolbar!.frame.origin.y = ViewService.initialOrigin;
        if(ViewService.initialOrigin == 0 && !UIDevice.current.orientation.isLandscape) {
            self.toolbar!.frame.origin.y = UIApplication.shared.statusBarFrame.origin.y + UIApplication.shared.statusBarFrame.size.height;
        }
        self.applicationViewModel.frame.origin.y = self.toolbar!.frame.origin.y + self.toolbar!.frame.size.height;
        if(fromInterfaceOrientation.isPortrait) {
            self.toolbar!.frame.origin.y = 0;
            self.applicationViewModel.frame.origin.y = self.toolbar!.frame.origin.y + self.toolbar!.frame.size.height - 13;
        }
        self.applicationViewModel.frame.size.height = self.view.frame.size.height - self.applicationViewModel.frame.origin.y;
        self.navView.frame = self.applicationViewModel.frame;
        self.navView.frame.size.width = self.view.frame.size.width / 2;
    }
    
    private func prepare() {
        self.view.translatesAutoresizingMaskIntoConstraints = true;
        self.view.autoresizesSubviews = true;
        self.setToolbar();
        self.addMenuItem();
		self.addApplicationView();
        self.addNavigation();
    }
	
    @objc func openMenu() {
        navView.toggleView();
    }
}

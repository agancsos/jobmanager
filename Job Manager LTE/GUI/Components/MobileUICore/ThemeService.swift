//
//  ThemeService.swift
//
//  Created by Abel Gancsos on 11/25/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import Common

class ThemeService {
	static var theme : String = RegistryPropertyStore().getProperty(key: SR.keyGUITheme) as! String ;
	static var themes : [String] = [ "dark", "light" ];
	
	private static func setBackground(object : UIView) {
		switch(theme.lowercased()) {
		case "dark":
			object.backgroundColor = UIConfiguration.themeDarkBackground;
		case "light":
			object.backgroundColor = UIConfiguration.themeLightBackground;
		default:
			break;
		}
	}

	private static func setBackground(object : UITableView) {
		switch(theme.lowercased()) {
			case "dark":
				object.backgroundColor = UIConfiguration.themeDarkBackground;
			case "light":
				object.backgroundColor = UIConfiguration.themeLightBackground;
			default:
				break;
		}
	}
	
	private static func setTextColor(object : UIView) {
		if(object as? UILabel != nil) {
			switch(theme.lowercased()) {
				case "dark":
					(object as! UILabel).textColor = UIConfiguration.themeDarkFontColor;
				case "light":
					(object as! UILabel).textColor = UIConfiguration.themeLightFontColor;
				default:
					break;
			}
		}
		if(object as? UITextView != nil) {
			switch(theme.lowercased()) {
				case "dark":
					(object as! UITextView).textColor = UIConfiguration.themeDarkFontColor;
				case "light":
					(object as! UITextView).textColor = UIConfiguration.themeLightFontColor;
				default:
					break;
			}
		}
	}
	
	public static func setTheme(object : UIView) {
		if(self.theme == "") {
			self.theme = "dark";
		}
		self.setBackground(object: object);
		self.setTextColor(object: object);
	}
}

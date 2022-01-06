//
//  SettingItem.swift
//
//  Created by Abel Gancsos on 11/25/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

enum SettingType {
	case NONE;
	case TEXTFIELD;
	case TEXTVIEW;
	case SWITCH;
	case LIST;
	case BUTTON;
	
	func getName() -> String {
		switch(self) {
			case .SWITCH:
				return "Switch";
			case .TEXTFIELD:
				return "Textfield";
			case .TEXTVIEW:
				return "Textview";
			case .LIST:
				return "List";
			case .BUTTON:
				return "Button";
			default:
				return "None";
		}
	}
}

class SettingItem {
	var name        : String = "";
	var placeholder : String = "";
	var options     : [String] = [];
	var type        : SettingType = .NONE;
	var label       : String = "";
    var editable    : Bool = true;
	
	init() {
		
	}
	
	init(name : String = "", placeholder : String = "", options : [String] = [], type : SettingType = .NONE, label : String = "") {
		self.name = name;
		self.placeholder = placeholder;
		self.options = options;
		self.type = type;
		self.label = label;
		if(self.label == ""){
			self.label = self.name;
		}
	}
}

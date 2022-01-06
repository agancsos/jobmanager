//
//  PreferenceWindowModel.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
import JobManager

class PreferenceModel {
	var settings : [SettingItem] = [];
	
	public init() {
		self.prepare();
	}
	
	private func prepare() {
		self.settings.append(SettingItem(name: SR.keyTraceLevel, placeholder: SR.keyTraceLevel, options: ["0", "1", "2", "3", "4", "5"], type: .Switch, label: SR.keyTraceLevel));
        self.settings.append(SettingItem(name: SR.keyCheckWebIcon, placeholder: SR.keyCheckWebIcon, options: ["Off", "On"], type: .Switch, label: SR.keyCheckWebIcon));
        self.settings.append(SettingItem(name: SR.keyEnableEditWindow, placeholder: SR.keyEnableEditWindow, options: ["Off", "On"], type: .Switch, label: SR.keyEnableEditWindow));
        self.settings.append(SettingItem(name: SR.keyBannedCompanies, placeholder: SR.keyBannedCompanies, options: [], type: .TextField, label: SR.keyBannedCompanies));
        self.settings.append(SettingItem(name: SR.keyEndpoint, placeholder: SR.keyEndpoint, options: [], type: .TextField, label: SR.keyEndpoint));
	}
	
	public func refresh() {
		self.settings.removeAll();
		self.prepare();
	}
	
	public func findSetting(name : String) -> SettingItem {
		for setting in self.settings {
			if(setting.name == name){
				return setting;
			}
		}
		return SettingItem();
	}
}

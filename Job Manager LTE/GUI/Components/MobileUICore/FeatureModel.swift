//
//  MobileFeatureModel.swift
//
//  Created by Abel Gancsos on 11/25/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class FeatureModel {
	var featureName    : String  = "";
	var featureLabel   : String  = "";
	var featureDisplay : Bool    = true;

	init(name : String = "", label : String = "", display : Bool = true) {
		self.featureName = name;
		self.featureLabel = label;
		self.featureDisplay = display;
	}
}

//
//  Configuration.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/23/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

class UIConfiguration {
    public static let toolbarTintColor     : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1);
    public static let menuItemTintColor    : UIColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1);
	public static let defaultBackground    : UIColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1);
	
	public static let themeDarkBackground  : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55);
	public static let themeDarkFontColor   : UIColor = .white;
	public static let themeLightBackground : UIColor = .white;
	public static let themeLightFontColor  : UIColor = .black;
    
    public static let formFieldLabelFont   : UIFont = UIFont(name: "Arial", size: 14)!;
    public static var toolbarFontColor     = UIColor.init(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0);
}

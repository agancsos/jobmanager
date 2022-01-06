//
//  Configuration.swift
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

public class PlainPropertyStore : PropertyStore {
	private var delimiter : Character = "=";
	
    /// This is the default constructor
	override init(src : String = "") {
		super.init(src: src);
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter path: Full path of the text configuration file
	init(path : String, delim : Character = "=") {
		super.init(src : path);
		delimiter = delim;
    }
    
    /// This method retrieves the value of a "key" or parameter
    ///
    /// - Parameter key: Name of the key/parameter
    /// - Returns: Value of the key or blank if it doesn't exist
    public override func getProperty(key : String) -> Any {
		let rawText : String = readFile();
		let rawPairs = rawText.split(separator: "\n");
		for rawPair in rawPairs {
			let comps = rawPair.split(separator: delimiter);
			if(comps.count == 2) {
				if(comps[0] == key) {
					return String(comps[1]);
				}
			}
		}
        return "";
    }
	
	public override func setProperty(key : String, value : Any) {
		var buffer : String = "";
		let rawText : String = readFile();
		let rawPairs = rawText.split(separator: "\n");
		for rawPair in rawPairs {
			let comps = rawPair.split(separator: delimiter);
			if(comps.count == 2) {
				if(comps[0] == key) {
					buffer += "\(comps[0])\(delimiter)\(value)";
				}
				else {
					buffer += "\(comps[0])\(delimiter)\(comps[1])";
				}
			}
		}
	}
	
	override public func getKeys() -> [String] {
		var result : [String] = [];
		let rawText : String = readFile();
		let rawPairs = rawText.split(separator: "\n");
		for rawPair in rawPairs {
			let comps = rawPair.split(separator: delimiter);
			if(comps.count == 2) {
				result.append(String(comps[0]));
			}
		}
		return result;
	}
}
